#!/bin/bash

echo "🚀 Proteksi Anti Tautan Server..."

# Jalur file
INDEX_FILE="/var/www/pterodactyl/resources/views/admin/servers/index.blade.php"
VIEW_DIR="/var/www/pterodactyl/resources/views/admin/servers/view"
TIMESTAMP=$(date -u +"%Y-%m-%d-%H-%M-%S")

# Cadangkan file asli
jika [ -f "$INDEX_FILE" ]; maka
  cp "$INDEX_FILE" "${INDEX_FILE}.bak_${TIMESTAMP}"
  echo "📦 File indeks cadangan dibuat: ${INDEX_FILE}.bak_${TIMESTAMP}"
fi

# 1. Perbarui File Indeks - Hanya ID admin 1 yang bisa dikelola, tapi Buat Baru bisa untuk semua admin
cat > "$INDEX_FILE" << 'EOF'
@extends('layouts.admin')
@section('judul')
    Server
@akhirbagian

@section('header konten')
    <h1>Server<small>Semua server yang tersedia di sistem.</small></h1>
    <ol class="breadcrumb">
        <li><a href="{{ route('admin.index') }}">Admin</a></li>
        <li class="active">Server</li>
    </ol>
@akhirbagian

@section('konten')
<div class="row">
    <div class="col-xs-12">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Daftar Server</h3>
                <div class="box-tools search01">
                    <form action="{{ route('admin.servers') }}" method="GET">
                        <div class="input-group input-group-sm">
                            <input type="text" name="query" class="form-control pull-right" value="{{ request()->input('query') }}" placeholder="Cari Server">
                            <div class="input-group-btn">
                                <button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button>
                                <!-- BUAT BISA DIKLIK OLEH SEMUA ADMIN BARU -->
                                <a href="{{ route('admin.servers.new') }}"><button type="button" class="btn btn-sm btn-primary" style="border-radius:0 3px 3px 0;margin-left:2px;">Buat Baru</button></a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="box-body table-responsive no-padding">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Nama Server</th>
                            UUID</th>
                            Pemilik
                            <th>Node</th>
                            <th>Koneksi</th>
                            <th class="text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($servers as $server)
                            <tr class="align-middle">
                                <td class="middle">
                                    <strong>{{ $server->name }}</strong>
                                    @if($server->id == 26)
                                    <br><small class="text-muted">Teknologi Jhoanley</small>
                                    @endif
                                </td>
                                <td class="middle"><code>{{ $server->uuidShort }}</code></td>
                                <td class="middle">
                                    <span class="label label-default">
                                        <i class="fa fa-user"></i> {{ $server->user->username }}
                                    </span>
                                </td>
                                <td class="middle">
                                    <span class="label label-info">
                                        <i class="fa fa-server"></i> {{ $server->node->name }}
                                    </span>
                                </td>
                                <td class="middle">
                                    <code>{{ $server->allocation->alias }}:{{ $server->allocation->port }}</code>
                                    @if($server->id == 26)
                                    <br><small><code>Teknologi Jhoanley:2007</code></small>
                                    @endif
                                </td>
                                <td class="text-center">
                                    @if(auth()->user()->id === 1)
                                        <!-- ID Admin 1 dapat mengakses semua -->
                                        <a href="{{ route('admin.servers.view', $server->id) }}" class="btn btn-xs btn-primary">
                                            <i class="fa fa-wrench"></i> Kelola
                                        </a>
                                    @kalau tidak
                                        <!-- Admin lain tidak bisa mengakses pengelolaan server yang ada -->
                                        <span class="label label-warning" data-toggle="tooltip" title="Hanya Root Admin yang bisa mengakses">
                                            <i class="fa fa-shield"></i> Terlindungi
                                        </span>
                                    @endif
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
            @if($servers->hasPages())
                <div class="box-footer with-border">
                    <div class="col-md-12 text-center">{!! $servers->appends(['query' => Request::input('query')])->render() !!}</div>
                </div>
            @endif
        </div>

        <!-- Kotak Informasi Keamanan -->
        @if(auth()->user()->id !== 1)
        <div class="alert alert-warning">
            <h4 style="margin-top: 0;">
                <i class="fa fa-shield"></i> Perlindungan Keamanan Aktif
            </h4>
            <p style="margin-bottom: 5px;">
                <strong>🔒 Akses Manajemen Server Dibatasi:</strong>
                Hanya <strong>Root Administrator (ID: 1)</strong> yang dapat mengelola server yang ada.
            </p>
            <p style="margin-bottom: 0; font-size: 12px;">
                <strong>✅ Buat Server Baru:</strong> Tersedia untuk semua administrator<br>
                <strong>🚫 Kelola yang Sudah Ada:</strong> Hanya Admin Root<br>
                <i class="fa fa-info-circle"></i>
                Dilindungi oleh:
                <span class="label label-primary">@KawakunChan</span>
                <span class="label label-success">@TESTIKawakunChan</span>
                <span class="label label-info">KawakunChan Tech</span>
            </p>
        </div>
        @kalau tidak
        <div class="alert alert-success">
            <h4 style="margin-top: 0;">
                <i class="fa fa-crown"></i> Akses Administrator Root
            </h4>
            <p style="margin-bottom: 0;">
                Anda memiliki akses penuh sebagai <strong>Root Administrator (ID: 1)</strong>.
                Semua server dapat dikelola secara normal.
            </p>
        </div>
        @endif
    </div>
</div>
@akhirbagian

@section('footer-scripts')
    @induk
    <script>
        $(dokumen).siap(fungsi() {
            $('[data-toggle="tooltip"]').tooltip();
            
            // Blokir manajemen server untuk admin selain ID 1
            @if(auth()->user()->id !== 1)
            $('a[href*="/admin/servers/view/"]').on('click', function(e) {
                e.preventDefault();
                alert('🚫 Access Denied: Hanya Root Administrator (ID: 1) yang dapat mengelola server yang ada.\n\n✅ Anda masih bisa membuat server baru dengan tombol "Create New"\n\nProtected by: @KawakunChan');
            });
            @endif
        });
    </script>
@akhirbagian
Akhir dari

echo "✅ Index file berhasil diproteksi (Create New bisa untuk semua admin)"

# 2. Proteksi view server untuk admin selain ID 1 dengan efek blur sederhana
mkdir -p "$VIEW_DIR"

# Buat perlindungan untuk semua view server
cari "$VIEW_DIR" -nama "*.blade.php" | sementara baca view_file; lakukan
    jika [ -f "$view_file" ]; maka
        cp "$view_file" "${view_file}.bak_${TIMESTAMP}" 2>/dev/null
    fi
    
    # Buat tampilan file dengan perlindungan sederhana - BLUR EFFECT
    cat > "$view_file" << 'EOF'
@if(auth()->user()->id !== 1)
{{-- PERLINDUNGAN BLUR UNTUK ADMIN NON-ROOT --}}
<div style="
    posisi: tetap;
    atas: 0;
    kiri: 0;
    lebar: 100%;
    tinggi: 100%;
    latar belakang: rgba(0,0,0,0.8);
    filter latar belakang: buram(20px);
    Indeks z: 9999;
    tampilan: fleksibel;
    sejajarkan item: tengah;
    justify-content: center;
    arah-fleksibel: kolom;
    warna: putih;
    perataan teks: tengah;
    padding: 20px;
">
    <div style="
        latar belakang: rgba(255,255,255,0.1);
        padding: 40px;
        radius-batas: 15px;
        filter latar belakang: buram(10px);
        batas: 1px solid rgba(255,255,255,0.2);
        lebar maksimum: 500px;
        lebar: 100%;
    ">
        <div style="font-size: 48px; margin-bottom: 20px;">🔒</div>
        <h2 style="margin: 0 0 10px 0; color: white;">Akses Dibatasi</h2>
        <p style="margin: 0 0 20px 0; opacity: 0.9;">
            Hanya Root Administrator (ID: 1) yang dapat mengakses manajemen server.
        </p>
        <div style="
            latar belakang: rgba(255,255,255,0.1);
            padding: 15px;
            radius batas: 10px;
            margin: 20px 0;
            batas: 1px solid rgba(255,255,255,0.1);
        ">
            <strong style="display: block; margin-bottom: 10px;">Dilindungi oleh Tim Keamanan:</strong>
            <div style="display: flex; gap: 10px; justify-content: center; flex-wrap: wrap;">
                <span style="background: #e84393; padding: 5px 12px; border-radius: 15px; font-size: 12px;">@KawakunChan</span>
                <span style="background: #0984e3; padding: 5px 12px; border-radius: 15px; font-size: 12px;">@TESTIKawakunChan</span>
                <span style="background: #00b894; padding: 5px 12px; border-radius: 15px; font-size: 12px;">@KawakunChan</span>
            </div>
        </div>
        <button onclick="window.location.href='/admin/servers'" style="
            latar belakang: rgba(255,255,255,0.2);
            warna: putih;
            batas: 1px solid rgba(255,255,255,0.3);
            padding: 10px 25px;
            radius-batas: 25px;
            kursor: penunjuk;
            ketebalan huruf: tebal;
            margin-atas: 10px;
        ">
            ← Kembali ke Daftar Server
        </button>
    </div>
</div>

<script>
    // Mencegah klik kanan
    document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
    });
    
    // Pengalihan otomatis setelah 5 detik
    setTimeout(() => {
        window.location.href = '/admin/servers';
    }, 5000);
</script>
@endif

{{-- ADMIN ID 1 MASIH BISA AKSES NORMAL --}}
@if(auth()->user()->id === 1)
@extends('layouts.admin')
@section('judul')
    Server — {{ $server->name }}
@akhirbagian

@section('header konten')
    <h1>{{ $server->name }}<small>{{ $server->description ?: 'Tidak ada deskripsi yang diberikan' }}</small></h1>
    <ol class="breadcrumb">
        <li><a href="{{ route('admin.index') }}">Admin</a></li>
        <li><a href="{{ route('admin.servers') }}">Server</a></li>
        <li class="aktif">{{ $server->name }}</li>
    </ol>
@akhirbagian

@section('konten')
<div class="row">
    <div class="col-xs-12">
        <div class="nav-tabs-custom nav-tabs-floating">
            <ul class="nav nav-tabs">
                <li class="active"><a href="#tab_1" data-toggle="tab">Detail</a></li>
                <li><a href="#tab_2" data-toggle="tab">Bangun</a></li>
                <li><a href="#tab_3" data-toggle="tab">Startup</a></li>
                <li><a href="#tab_4" data-toggle="tab">Basis Data</a></li>
                <li><a href="#tab_5" data-toggle="tab">Jadwal</a></li>
                <li><a href="#tab_6" data-toggle="tab">Pengguna</a></li>
                <li><a href="#tab_7" data-toggle="tab">Cadangan</a></li>
                <li><a href="#tab_8" data-toggle="tab">Jaringan</a></li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active" id="tab_1">
                    <div class="alert alert-success">
                        <i class="fa fa-crown"></i> <strong>Akses Administrator Utama</strong><br>
                        Anda memiliki akses penuh sebagai <strong>Root Administrator (ID: 1)</strong>.
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <dl>
                                <dt>Nama Server</dt>
                                <dd>{{ $server->name }}</dd>
                                <dt>Pemilik Server</dt>
                                <dd>{{ $server->user->username }}</dd>
                                <dt>Node</dt>
                                <dd>{{ $server->node->name }}</dd>
                            </dl>
                        </div>
                        <div class="col-md-6">
                            <dl>
                                <dt>Koneksi</dt>
                                <dd><code>{{ $server->allocation->alias }}:{{ $server->allocation->port }}</code></dd>
                                UUID</dt>
                                <dd><code>{{ $server->uuid }}</code></dd>
                                <dt>Status</dt>
                                <dd>
                                    @if($server->suspended)
                                        <span class="label label-danger">Ditangguhkan</span>
                                    @kalau tidak
                                        <span class="label label-success">Aktif</span>
                                    @endif
                                </dd>
                            </dl>
                        </div>
                    </div>
                </div>
                <!-- Konten tab lainnya akan ditempatkan di sini -->
            </div>
        </div>
    </div>
</div>
@akhirbagian
@endif
Akhir dari
    echo "✅ Dilindungi: $(basename "$view_file") dengan efek blur"
Selesai

# Atur izin
chmod 644 "$INDEX_FILE"
find "$VIEW_DIR" -name "*.blade.php" -exec chmod 644 {} \;

# Bersihkan cache
echo "🔄 Membersihkan cache..."
cd /var/www/pterodactyl
php artisan view:clear
php artisan cache:clear

gema "
echo "🎉 PROTEKSI BERHASIL DIPASANG!"
echo "✅ Admin ID 1: Dapat mengakses semua (daftar server, tampilan, dan manajemen)"
echo "✅ Admin lain: Bisa Buat server baru, tapi tidak bisa kelola yang sudah ada"
echo "✅ Lihat server: Efek blur untuk admin selain ID 1"
echo "✅ Tombol 'Buat Baru' bisa diklik oleh semua admin"
echo "🛡️ Keamanan oleh: @KawakunChan"
