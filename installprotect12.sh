#!/bin/bash

REMOTE_PATH="/var/www/pterodactyl/app/Http/Controllers/Admin/Nodes/NodeViewController.php"
TIMESTAMP=$(date -u +"%Y-%m-%d-%H-%M-%S")
JALUR_CADANGAN="${JALUR_JARAK_JAUH}.bak_${CAP_WAKTU}"

echo "🚀 Proteksi Anti Akses Settings..."

jika [ -f "$REMOTE_PATH" ]; maka
  mv "$REMOTE_PATH" "$BACKUP_PATH"
  echo "📦 File cadangan lama dibuat di $BACKUP_PATH"
fi

mkdir -p "$(dirname "$REMOTE_PATH")"
chmod 755 "$(dirname "$REMOTE_PATH")"

cat > "$REMOTE_PATH" << 'EOF'
<?php

namespace Pterodactyl\Http\Controllers\Admin\Nodes;

gunakan Illuminate\View\View;
gunakan Pterodactyl\Models\Node;
gunakan Pterodactyl\Http\Controllers\Controller;
gunakan Pterodactyl\Repositories\Eloquent\NodeRepository;
gunakan Pterodactyl\Services\Nodes\NodeUpdateService;
gunakan Pterodactyl\Services\Nodes\NodeCreationService;
gunakan Pterodactyl\Services\Nodes\NodeDeletionService;
gunakan Pterodactyl\Http\Requests\Admin\Node\NodeFormRequest;
gunakan Pterodactyl\Contracts\Repository\AllocationRepositoryInterface;
gunakan Pterodactyl\Http\Requests\Admin\Node\AllocationFormRequest;

kelas NodeViewController extends Controller
{
    /**
     * 🔒 Fungsi tambahan: Cegah akses node dilihat oleh admin lain.
     */
    fungsi privat checkNodeAccess($request, Node $node = null)
    {
        $user = $request->user();

        // Admin (user id = 1) bebas akses semua
        jika ($user->id === 1) {
            kembali;
        }

        // Jika bukan admin ID 1, tolak akses dengan efek blur dan error
        batalkan(403, '✖️ 𝖺𝗄𝗌𝖾𝗌 𝖽𝗂𝗍𝗈𝗅𝖺𝗄 𝗉𝗋𝗈𝗍𝖾𝖼𝗍 𝖻𝗒 KawakunChan Tech');
    }

    /**
     * Menampilkan gambaran umum sebuah node untuk pengguna admin.
     */
    fungsi publik index(NodeRepository $repository, string $id): Lihat
    {
        $this->checkNodeAccess(request());
        
        $node = $repository->getNodeWithResourceUsage($id);
        
        kembalikan tampilan('admin.nodes.view.index', [
            'node' => $node,
            'statistik' => [
                'versi' => $node->getAttribute('daemon_version'),
                'sistem' => [
                    'tipe' => $node->getAttribute('daemon_system_type'),
                    'arch' => $node->getAttribute('daemon_system_arch'),
                    'versi' => $node->getAttribute('daemon_system_version'),
                ],
                'cpus' => $node->getAttribute('daemon_cpu_count'),
            ],
        ]);
    }

    /**
     * Menampilkan pengaturan untuk node tertentu.
     */
    fungsi publik pengaturan(string $id): Lihat
    {
        $this->checkNodeAccess(request());
        
        $node = Node::findOrFail($id);
        
        kembalikan tampilan('admin.nodes.view.settings', [
            'node' => $node,
            'lokasi' => \Pterodactyl\Models\Location::all(),
        ]);
    }

    /**
     * Menampilkan konfigurasi untuk node tertentu.
     */
    fungsi publik konfigurasi(string $id): Lihat
    {
        $this->checkNodeAccess(request());
        
        $node = Node::findOrFail($id);
        
        kembalikan tampilan('admin.nodes.view.configuration', [
            'node' => $node,
        ]);
    }

    /**
     * Menampilkan alokasi untuk node tertentu.
     */
    fungsi publik alokasi(AllocationRepositoryInterface $repository, string $id): Lihat
    {
        $this->checkNodeAccess(request());
        
        $node = Node::findOrFail($id);
        
        $alokasi = $repositori->getPaginatedAllocationsForNode($id, 50);
        
        kembalikan tampilan('admin.nodes.view.allocations', [
            'node' => $node,
            'alokasi' => $alokasi,
        ]);
    }

    /**
     * Menampilkan server untuk node tertentu.
     */
    fungsi publik server(string $id): Lihat
    {
        $this->checkNodeAccess(request());
        
        $node = Node::findOrFail($id);
        
        $servers = $node->servers()->with('user', 'egg')->paginate(50);
        
        kembalikan tampilan('admin.nodes.view.servers', [
            'node' => $node,
            'server' => $server,
        ]);
    }

    /**
     * Perbarui pengaturan node.
     */
    fungsi publik updateSettings(NodeFormRequest $request, NodeUpdateService $service, string $id): \Illuminate\Http\RedirectResponse
    {
        $this->checkNodeAccess(request());
        
        $node = Node::findOrFail($id);
        $service->update($node, $request->validated(), $request->user());
        
        kembalikan pengalihan()->rute('admin.nodes.view.settings', $node->id)
            ->with('success', 'Pengaturan node berhasil diperbarui.');
    }

    /**
     * Perbarui konfigurasi node.
     */
    fungsi publik updateConfiguration(NodeFormRequest $request, NodeUpdateService $service, string $id): \Illuminate\Http\RedirectResponse
    {
        $this->checkNodeAccess(request());
        
        $node = Node::findOrFail($id);
        $service->updateConfiguration($node, $request->validated());
        
        kembalikan pengalihan()->rute('admin.nodes.view.configuration', $node->id)
            ->with('success', 'Konfigurasi node berhasil diperbarui.');
    }

    /**
     * Buat alokasi baru untuk node.
     */
    public function createAllocation(AllocationFormRequest $request, NodeUpdateService $service, string $id): \Illuminate\Http\RedirectResponse
    {
        $this->checkNodeAccess(request());
        
        $node = Node::findOrFail($id);
        $service->createAllocation($node, $request->validated());
        
        kembalikan pengalihan()->rute('admin.nodes.view.allocations', $node->id)
            ->with('success', 'Alokasi berhasil dibuat.');
    }

    /**
     * Hapus alokasi dari node.
     */
    fungsi publik deleteAllocation(string $id, string $allocationId, NodeDeletionService $service): \Illuminate\Http\RedirectResponse
    {
        $this->checkNodeAccess(request());
        
        $node = Node::findOrFail($id);
        $service->deleteAllocation($node, $allocationId);
        
        kembalikan pengalihan()->rute('admin.nodes.view.allocations', $node->id)
            ->with('success', 'Alokasi berhasil dihapus.');
    }

    /**
     * Hapus node.
     */
    fungsi publik deleteNode(string $id, NodeDeletionService $service): \Illuminate\Http\RedirectResponse
    {
        $this->checkNodeAccess(request());
        
        $node = Node::findOrFail($id);
        $service->handle($node);
        
        kembalikan pengalihan()->rute('admin.nodes')
            ->with('success', 'Node berhasil dihapus.');
    }
}
?>

# Juga proteksi file view template untuk efek blur
VIEW_PATH="/var/www/pterodactyl/resources/views/admin/nodes/view"
jika [ -d "$VIEW_PATH" ]; maka
    # Indeks template cadangan jika ada
    jika [ -f "$VIEW_PATH/index.blade.php" ]; maka
        cp "$VIEW_PATH/index.blade.php" "$VIEW_PATH/index.blade.php.bak_$TIMESTAMP"
    fi
    
    # Buat template dengan efek blur untuk admin lain
    cat > "$VIEW_PATH/index.blade.php" << 'EOF'
@extends('layouts.admin')

@section('judul')
    Node: {{ $node->name }}
@akhirbagian

@section('header konten')
    <h1>{{ $node->name }}<small>Gambaran umum node secara detail.</small></h1>
    <ol class="breadcrumb">
        <li><a href="{{ route('admin.index') }}">Admin</a></li>
        <li><a href="{{ route('admin.nodes') }}">Node</a></li>
        <li class="active">{{ $node->name }}</li>
    </ol>
@akhirbagian

@section('konten')
@php
    $user = Auth::user();
@endphp

@if($user->id !== 1)
    <div style="
        posisi: tetap;
        atas: 0;
        kiri: 0;
        lebar: 100%;
        tinggi: 100%;
        latar belakang: rgba(0,0,0,0.8);
        filter latar belakang: buram(10px);
        Indeks z: 9999;
        tampilan: fleksibel;
        justify-content: center;
        sejajarkan item: tengah;
        arah-fleksibel: kolom;
        warna: putih;
        font-family: Arial, sans-serif;
        perataan teks: tengah;
    ">
        <div style="font-size: 48px; margin-bottom: 20px;">🚫</div>
        <h1 style="color: #e74c3c; margin-bottom: 10px;">Akses Ditolak</h1>
        <p style="font-size: 18px; margin-bottom: 20px;">Hanya Admin Utama yang dapat mengakses halaman ini</p>
        <p style="font-size: 14px; color: #95a5a6;">dilindungi oleh KawakunChan Tech</p>
    </div>
    @php
        kode_respons_http(403);
        KELUAR();
    @endphp
@endif

<div class="row">
    <div class="col-xs-12">
        <div class="nav-tabs-custom nav-tabs-floating">
            <ul class="nav nav-tabs">
                <li class="active"><a href="{{ route('admin.nodes.view', $node->id) }}">Tentang</a></li>
                <li><a href="{{ route('admin.nodes.view.settings', $node->id) }}">Pengaturan</a></li>
                <li><a href="{{ route('admin.nodes.view.configuration', $node->id) }}">Konfigurasi</a></li>
                <li><a href="{{ route('admin.nodes.view.allocations', $node->id) }}">Alokasi</a></li>
                <li><a href="{{ route('admin.nodes.view.servers', $node->id) }}">Server</a></li>
            </ul>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-sm-8">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Informasi</h3>
            </div>
            <div class="box-body">
                <div class="row">
                    <div class="col-xs-6">
                        <strong>Versi Daemon</strong>
                        <p class="text-muted">
                            {{ $stats['versi'] ?? 'Tidak Tersedia' }}
                            @if(($stats['version'] ?? null) === $node->daemonVersion)
                                <span class="label label-success">Terbaru</span>
                            @endif
                        </p>
                    </div>
                    <div class="col-xs-6">
                        <strong>Informasi Sistem</strong>
                        <p class="text-muted">
                            {{ $stats['system']['type'] ?? 'Tidak Tersedia' }} ({{ $stats['system']['arch'] ?? 'Tidak Tersedia' }})<br>
                            <small>{{ $stats['system']['version'] ?? 'Tidak Tersedia' }}</small>
                        </p>
                    </div>
                    <div class="col-xs-6">
                        <strong>Total Thread CPU</strong>
                        <p class="text-muted">{{ $stats['cpus'] ?? 'Tidak Tersedia' }}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-sm-4">
        <div class="box box-danger">
            <div class="box-header with-border">
                <h3 class="box-title">Hapus Node</h3>
            </div>
            <div class="box-body">
                <p>Menghapus node adalah tindakan yang tidak dapat dibatalkan dan akan segera menghapus node tersebut dari panel. Tidak boleh ada server yang terkait dengan node ini agar proses dapat dilanjutkan.</p>
            </div>
            <div class="box-footer">
                <form action="{{ route('admin.nodes.view.delete', $node->id) }}" method="POST">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-danger btn-sm" {{ $node->servers_count > 0 ? 'disabled' : '' }}>Hapus Node</button>
                </form>
            </div>
        </div>
    </div>
</div>
@akhirbagian
Akhir dari

    echo "✅ Tampilan template dengan efek blur berhasil dipasang!"
fi

echo "✅ Proteksi Anti Akses Admin Nodes View berhasil dipasang!"
echo "📂 Lokasi pengontrol file: $REMOTE_PATH"
echo "📂 Tampilan template lokasi: $VIEW_PATH"
echo "🗂️ Lama file cadangan: $BACKUP_PATH (jika sebelumnya ada)"
echo "🔒 Hanya Admin ID 1 yang bisa akses normal, admin lain akan melihat efek blur dan error 403"
echo "🚫 Pesan error: 'akses ditolak, lindungi oleh @KawakunChan'"
