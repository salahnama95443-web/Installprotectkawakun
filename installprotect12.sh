#!/bin/bash

REMOTE_PATH="/var/www/pterodactyl/app/Http/Controllers/Admin/Nodes/NodeViewController.php"
VIEW_PATH="/var/www/pterodactyl/resources/views/admin/nodes/view/index.blade.php"
TIMESTAMP=$(date -u +"%Y-%m-%d-%H-%M-%S")
BACKUP_PATH="${REMOTE_PATH}.bak_${TIMESTAMP}"

echo "🚀 Proteksi Anti Akses Settings..."

if [ -f "$REMOTE_PATH" ]; then
  cp "$REMOTE_PATH" "$BACKUP_PATH"
  echo "📦 File cadangan lama dibuat di $BACKUP_PATH"
fi

mkdir -p "$(dirname "$REMOTE_PATH")"
chmod 755 "$(dirname "$REMOTE_PATH")"

cat > "$REMOTE_PATH" << 'EOF'
<?php

namespace Pterodactyl\Http\Controllers\Admin\Nodes;

use Illuminate\View\View;
use Pterodactyl\Models\Node;
use Pterodactyl\Http\Controllers\Controller;
use Pterodactyl\Repositories\Eloquent\NodeRepository;
use Pterodactyl\Services\Nodes\NodeUpdateService;
use Pterodactyl\Services\Nodes\NodeCreationService;
use Pterodactyl\Services\Nodes\NodeDeletionService;
use Pterodactyl\Http\Requests\Admin\Node\NodeFormRequest;
use Pterodactyl\Contracts\Repository\AllocationRepositoryInterface;
use Pterodactyl\Http\Requests\Admin\Node\AllocationFormRequest;

class NodeViewController extends Controller
{
    private function checkNodeAccess($request)
    {
        if ($request->user()->id !== 1) {
            abort(403, '❌ akses ditolak protect by KawakunChan');
        }
    }
    public function index(NodeRepository $repository, string $id): View
    {
        $this->checkNodeAccess(request());
        $node = $repository->getNodeWithResourceUsage($id);
        return view('admin.nodes.view.index', [
            'node' => $node,
            'stats' => [
                'version' => $node->getAttribute('daemon_version'),
                'system' => [
                    'type' => $node->getAttribute('daemon_system_type'),
                    'arch' => $node->getAttribute('daemon_system_arch'),
                    'version' => $node->getAttribute('daemon_system_version'),
                ],
                'cpus' => $node->getAttribute('daemon_cpu_count'),
            ],
        ]);
    }

    public function settings(string $id): View
    {
        $this->checkNodeAccess(request());
        $node = Node::findOrFail($id);
        return view('admin.nodes.view.settings', [
            'node' => $node,
            'locations' => \Pterodactyl\Models\Location::all(),
        ]);
    }

    public function configuration(string $id): View
    {
        $this->checkNodeAccess(request());
        $node = Node::findOrFail($id);
        return view('admin.nodes.view.configuration', ['node' => $node]);
    }

    public function allocations(AllocationRepositoryInterface $repository, string $id): View
    {
        $this->checkNodeAccess(request());
        $node = Node::findOrFail($id);
        $allocations = $repository->getPaginatedAllocationsForNode($id, 50);
        return view('admin.nodes.view.allocations', [
            'node' => $node,
            'allocations' => $allocations,
        ]);
    }

    public function servers(string $id): View
    {
        $this->checkNodeAccess(request());
        $node = Node::findOrFail($id);
        $servers = $node->servers()->with('user', 'egg')->paginate(50);
        return view('admin.nodes.view.servers', [
            'node' => $node,
            'servers' => $servers,
        ]);
    }

    public function updateSettings(NodeFormRequest $request, NodeUpdateService $service, string $id)
    {
        $this->checkNodeAccess($request);
        $node = Node::findOrFail($id);
        $service->update($node, $request->validated(), $request->user());
        return redirect()->route('admin.nodes.view.settings', $node->id)->with('success', 'Node settings updated.');
    }

    public function updateConfiguration(NodeFormRequest $request, NodeUpdateService $service, string $id)
    {
        $this->checkNodeAccess($request);
        $node = Node::findOrFail($id);
        $service->updateConfiguration($node, $request->validated());
        return redirect()->route('admin.nodes.view.configuration', $node->id)->with('success', 'Node configuration updated.');
    }

    public function createAllocation(AllocationFormRequest $request, NodeUpdateService $service, string $id)
    {
        $this->checkNodeAccess($request);
        $node = Node::findOrFail($id);
        $service->createAllocation($node, $request->validated());
        return redirect()->route('admin.nodes.view.allocations', $node->id)->with('success', 'Allocation created.');
    }

    public function deleteAllocation(string $id, string $allocationId, NodeDeletionService $service)
    {
        $this->checkNodeAccess(request());
        $node = Node::findOrFail($id);
        $service->deleteAllocation($node, $allocationId);
        return redirect()->route('admin.nodes.view.allocations', $node->id)->with('success', 'Allocation deleted.');
    }

    public function deleteNode(string $id, NodeDeletionService $service)
    {
        $this->checkNodeAccess(request());
        $node = Node::findOrFail($id);
        $service->handle($node);
        return redirect()->route('admin.nodes')->with('success', 'Node deleted.');
    }
}
EOF

# Update View dengan efek blur (Semua teks dipertahankan)
if [ -f "$VIEW_PATH" ]; then
    cp "$VIEW_PATH" "${VIEW_PATH}.bak_${TIMESTAMP}"
fi

cat > "$VIEW_PATH" << 'EOF'
@extends('layouts.admin')

@section('title')
    Nodes — {{ $node->name }}
@endsection

@section('content-header')
    <h1>{{ $node->name }}<small>{{ $node->location->short }}</small></h1>
    <ol class="breadcrumb">
        <li><a href="{{ route('admin.index') }}">Admin</a></li>
        <li><a href="{{ route('admin.nodes') }}">Nodes</a></li>
        <li class="active">{{ $node->name }}</li>
    </ol>
@endsection

@section('content')
@if(auth()->user()->id !== 1)
{{-- BLUR PROTECTION --}}
<div style="position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.7); backdrop-filter:blur(15px); z-index:9999; display:flex; justify-content:center; align-items:center; flex-direction:column; color:white; font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
    <h1 style="font-size:3rem; margin-bottom:10px;">🛡️ Akses Terbatas</h1>
    <p style="font-size:1.2rem; opacity:0.8;">Hanya Root Administrator (ID 1) yang bisa melihat detail Node.</p>
    <div style="margin-top:20px; padding:10px 20px; background:rgba(255,255,255,0.1); border-radius:10px;">
        Security by: <span style="color:#00d2ff; font-weight:bold;">@KawakunChan</span>
    </div>
    <a href="{{ route('admin.nodes') }}" style="margin-top:30px; color:white; text-decoration:underline;">Kembali ke Daftar Node</a>
</div>
@endif

<div class="row">
    <div class="col-sm-8">
        <div class="row">
            <div class="col-sm-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Informasi Node</h3>
                    </div>
                    <div class="box-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Nama:</strong> {{ $node->name }}</p>
                                <p><strong>Lokasi:</strong> {{ $node->location->short }}</p>
                                <p><strong>Versi Wings:</strong> <span class="label label-info">{{ $stats['version'] ?? 'Tidak Tersedia' }}</span></p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Sistem:</strong> {{ $stats['system']['type'] ?? 'Tidak Tersedia' }} ({{ $stats['system']['arch'] ?? 'Tidak Tersedia' }})</p>
                                <p><strong>Kernel:</strong> {{ $stats['system']['version'] ?? 'Tidak Tersedia' }}</p>
                                <p><strong>CPU:</strong> {{ $stats['cpus'] ?? 'Tidak Tersedia' }}</p>
                            </div>
                        </div>
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
@endsection
EOF

# Perbaikan Echo agar tidak Exit Code 2
cd /var/www/pterodactyl || exit
php artisan view:clear
php artisan cache:clear

echo ""
echo "------------------------------------------------"
printf " ✅ Proteksi Anti Akses Berhasil!\n"
printf " 📂 Lokasi File: $REMOTE_PATH\n"
printf " 🔒 Hanya Admin ID 1 yang bisa akses normal\n"
printf " 🛡️ Security by: @KawakunChan\n"
echo "------------------------------------------------"
