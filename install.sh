#!/bin/bash

# Warna
BIRU='\033[0;34m'       
MERAH='\033[0;31m'
HIJAU='\033[0;32m'
KUNING='\033[0;33m'
NC='\033[0m'

# Tampilkan pesan selamat datang
display_welcome() {
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] [+]${NC}"
  echo -e "${WHITE}[+] AUTO INSTALLER THEMA [+]${NC}"
  echo -e "${WHITE}[+] © KawakunChan [+]${NC}"
  echo -e "${BLUE}[+] [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""
  echo -e "script ini di buat untuk mempermudah penginstalasian thema pterodactyle,"
  echo -e "dilarang keras untuk dikasih gratis."
  echo -e ""
  gema -e "𝗧𝗘𝗟𝗘𝗚𝗥𝗔𝗠 :"
  echo -e "@KawakunChan"
  echo -e "KREDIT :"
  echo -e "@KawakunChan"
  tidur 4
  jernih
}

#Perbarui dan instal jq
instal_jq() {
  echo -e " "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] PERBARUI & PASANG JQ [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e " "
  sudo apt update && sudo apt install -y jq
  jika [ $? -eq 0 ]; maka
    echo -e " "
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
    echo -e "${GREEN}[+] INSTALL JQ BERHASIL [+]${NC}"
    echo -e "${GREEN}[+] =============================================== [+]${NC}"
  kalau tidak
    echo -e " "
    echo -e "${RED}[+] =============================================== [+]${NC}"
    echo -e "${RED}[+] INSTAL JQ GAGAL [+]${NC}"
    echo -e "${RED}[+] =============================================== [+]${NC}"
    keluar 1
  fi
  echo -e " "
  tidur 1
  jernih
}
#Periksa token pengguna
check_token() {
  echo -e " "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] LISENSI PENGEMBANG NOL [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e " "
  echo -e "${YELLOW}MASUKAN AKSES TOKEN :${NC}"
  baca -r USER_TOKEN

  jika [ "$USER_TOKEN" = "KawakunChan" ]; maka
    echo -e "${HIJAU}AKSES BERHASIL${NC}}"
  kalau tidak
    echo -e "${GREEN}Beli dulu Gih Ke ZeroDev${NC}"
    echo -e "${YELLOW}TELEGRAM : @ext4you${NC}"
    echo -e "${YELLOW}WHATSAPP : 6287767050506${NC}"
    echo -e "${YELLOW}HARGA TOKEN : 10K GRATIS UPDATE JIKA ADA TOKEN BARU${NC}"
    echo -e "${YELLOW}©zerodeveloper${NC}"
    keluar 1
  fi
  jernih
}

# Instal tema
instal_tema() {
  jika benar; lakukan
    echo -e " "
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo -e "${WHITE}[+] PILIH TEMA [+]${NC}"
    echo -e "${BLUE}[+] =============================================== [+]${NC}"
    echo -e " "
    echo -e "PILIH TEMA YANG INGIN DI INSTALL"
    gema "1. bintang"
    echo "2. penagihan"
    gema "3. teka-teki"
    echo "x. kembali"
    echo -e "masukan pilihan (1/2/3/x) :"
    baca -r PILIH_TEMA
    kasus "$SELECT_THEME" dalam
      1)
        URL_TEMA=$(echo -e "https://github.com/gitfdil1248/thema/raw/main/C2.zip")
        merusak
        ;;
      2)
        THEME_URL=$(echo -e "\x68\x74\x74\x70\x73\x3A\x2F\x2F\x67\x69\x74\x68\x75\x62\x2E\x63\x6F\x6D\x2F\x44\x49\x54\x5A\x5A\x31\x31\x32\x2F\x66\x6F\x78\x78\x68\x6F\x73\x74\x74\x2F\x72\x61\x77\x2F\x6D\x61\x69\x6E\x2F\x43\x31\x2E\x7A\x69\x70")
        merusak
        ;;
      3)
        URL_TEMA=$(echo -e "https://github.com/gitfdil1248/thema/raw/main/C3.zip")
        merusak
        ;;
      X)
        kembali
        ;;
      *)
        echo -e "${RED}Pilihan tidak valid, silakan coba lagi.${NC}"
        ;;
    esac
  Selesai
  
jika [ -e /root/pterodactyl ]; maka
    sudo rm -rf /root/pterodactyl
  fi
  wget -q "$THEME_URL"
  sudo unzip -o "$(basename "$THEME_URL")"
  
jika [ "$SELECT_THEME" -eq 1 ]; maka
  echo -e " "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] INSTALASI THEMA [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e " "
  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E pesta -
  sudo apt install -y nodejs
  sudo npm i -g yarn
  cd /var/www/pterodactyl
  yarn add react-feather
  php artisan migrate
  pembuatan benang:produksi
  php artisan view:clear
  sudo rm /root/C2.zip
  sudo rm -rf /root/pterodactyl

  echo -e " "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] INSTALASI BERHASIL [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e ""
  tidur 2
  jernih
  keluar 0

jika [ "$SELECT_THEME" -eq 2 ]; maka
  echo -e " "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] INSTALASI THEMA [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e " "
  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E pesta -
  sudo apt install -y nodejs
  npm i -g yarn
  cd /var/www/pterodactyl
  yarn add react-feather
  php artisan billing:install stable
  php artisan migrate
  pembuatan benang:produksi
  php artisan view:clear
  sudo rm /root/C1.zip
  sudo rm -rf /root/pterodactyl

  echo -e " "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] INSTALASI BERHASIL [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e " "
  tidur 2
  jernih
  kembali

jika [ "$SELECT_THEME" -eq 3 ]; maka
  echo -e " "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] INSTALASI THEMA [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e " "

    # Menyanyakan informasi kepada pengguna untuk tema Enigma
    echo -e "${YELLOW}Masukkan link wa (https://wa.me...) : ${NC}"
    baca LINK_WA
    echo -e "${YELLOW}Masukkan link group (https://.....) : ${NC}"
    baca LINK_GROUP
    echo -e "${YELLOW}Masukkan link channel (https://...) : ${NC}"
    baca LINK_CHNL

    # Mengganti placeholder dengan nilai dari pengguna
    sudo sed -i "s|LINK_WA|$LINK_WA|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
    sudo sed -i "s|LINK_GROUP|$LINK_GROUP|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
    sudo sed -i "s|LINK_CHNL|$LINK_CHNL|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
    

  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E pesta -
  sudo apt install -y nodejs
  sudo npm i -g yarn
  cd /var/www/pterodactyl
  yarn add react-feather
  php artisan migrate
  pembuatan benang:produksi
  php artisan view:clear
  sudo rm /root/C3.zip
  sudo rm -rf /root/pterodactyl

  echo -e " "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] INSTALASI BERHASIL [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e ""
  tidur 5
kalau tidak
  gema "
  echo "Pilihan tidak valid. silahkan pilih 1/2/3."
fi
}


# Hapus tema
uninstall_theme() {
  echo -e " "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] HAPUS TEMA [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e " "
  bash <(curl https://raw.githubusercontent.com/gitfdil1248/thema/main/repair.sh)
  echo -e " "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] HAPUS TEMA SUKSES [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e " "
  tidur 2
  jernih
}
instal_temaSteeler() {
#!/bin/bash

echo -e " "
echo -e "${BLUE}[+] =============================================== [+]${NC}"
echo -e "${BLUE}[+] INSTALASI THEMA [+]${NC}"
echo -e "${BLUE}[+] =============================================== [+]${NC}"
echo -e " "

# Unduh file tema
wget -O /root/C2.zip https://github.com/gitfdil1248/thema/raw/main/C2.zip

# Ekstrak file tema
unzip /root/C2.zip -d /root/pterodactyl

# Salin tema ke direktori Pterodactyl
sudo cp -rfT /root/pterodactyl /var/www/pterodactyl

# Instal Node.js dan Yarn
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E pesta -
sudo apt install -y nodejs
sudo npm i -g yarn

# Instal dependensi dan build tema
cd /var/www/pterodactyl
yarn add react-feather
php artisan migrate
pembuatan benang:produksi
php artisan view:clear

# Hapus file dan direktori sementara
sudo rm /root/C2.zip
sudo rm -rf /root/pterodactyl

echo -e " "
echo -e "${GREEN}[+] =============================================== [+]${NC}"
echo -e "${GREEN}[+] INSTALASI BERHASIL [+]${NC}"
echo -e "${GREEN}[+] =============================================== [+]${NC}"
echo -e ""
tidur 2
jernih
keluar 0

}
buat_node() {
  echo -e " "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] BUAT NODE [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e " "
  #!/bin/bash
#!/bin/bash

# Minta masukan dari pengguna
read -p "Masukkan nama lokasi: " location_name
read -p "Masukkan deskripsi lokasi: " location_description
read -p "Masukkan domain: " domain
read -p "Masukkan nama node: " node_name
read -p "Masukkan RAM (dalam MB): " ram
read -p "Masukkan jumlah ruang disk maksimum (dalam MB):" disk_space
baca -p "Masukkan Locid:" locid

# Ubah ke direktori pterodactyl
cd /var/www/pterodactyl || { echo "Direktori tidak ditemukan"; keluar 1; }

# Membuat lokasi baru
php artisan p:location:make <<EOF
nama_lokasi
$lokasi_deskripsi
Akhir dari

# Membuat node baru
php artisan p:node:make <<EOF
nama_node
$lokasi_deskripsi
$locid
https
$domain
Ya
TIDAK
TIDAK
$ram
$ram
ruang_disk
ruang_disk
100
8080
Tahun 2022
/var/lib/pterodactyl/volumes
Akhir dari

  echo -e " "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] BUAT NODE & LOKASI SUKSES [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e " "
  tidur 2
  jernih
  keluar 0
}
uninstall_panel() {
  echo -e " "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] HAPUS PANEL [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e " "


bash <(curl -s https://pterodactyl-installer.se) <<EOF
y
y
y
y
Akhir dari


  echo -e " "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] HAPUS PANEL SUKSES [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e " "
  tidur 2
  jernih
  keluar 0
}
konfigurasi_sayap() {
  echo -e " "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] KONFIGURASI SAYAP [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e " "
  #!/bin/bash

# Minta input token dari pengguna
read -p "Masukkan token Konfigurasi menjalankan sayap:" sayap

evaluasi "$sayap"
# Garis perintah systemctl start sayap
sudo systemctl start wings

  echo -e " "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] CONFIGURE WINGS SUKSES [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e " "
  tidur 2
  jernih
  keluar 0
}
hackback_panel() {
  echo -e " "
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+] HACK BACK PANEL [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e " "
  # Minta masukan dari pengguna
read -p "Masukkan Panel Nama Pengguna:" pengguna
read -p "password login " psswdhb
  #!/bin/bash
cd /var/www/pterodactyl || { echo "Direktori tidak ditemukan"; keluar 1; }

# Membuat lokasi baru
php artisan p:user:make <<EOF
Ya
hackback@gmail.com
$user
$user
$user
$psswdhb
Akhir dari
  echo -e " "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] AKUN TELAH DI TAMBAHKAN [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e " "
  tidur 2
  
  keluar 0
}
ubahpw_vps() {
  echo -e " "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] UBAH PASSWORD VPS [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e " "
baca -p "Masukkan Pw Baru:" pw
baca -p "Masukkan Ulang Pw Baru" pw

passwd <<EOF
$pw
$pw

Akhir dari


  echo -e " "
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e "${GREEN}[+] GANTI PW VPS SUKSES [+]${NC}"
  echo -e "${GREEN}[+] =============================================== [+]${NC}"
  echo -e " "
  tidur 2
  
  keluar 0
}
# Skrip utama
tampilan_selamat datang
instal_jq
token_pemeriksaan

jika benar; lakukan
  jernih
  echo -e " "
  echo -e "${RED} _,gggggggggg. ${NC}"
  echo -e "${RED} ,gggggggggggggggggg. ${NC}"
  echo -e "${RED} ,ggggg gggggggg. ${NC}"
  echo -e "${RED} ,ggg' 'ggg. ${NC}"
  echo -e "${RED}',gg ,ggg. 'ggg: ${NC}"
  echo -e "${RED}'ggg ,gg''' . ggg Auto Installer ZeroDeveloper Private ${NC}"
  echo -e "${RED}gggg gg , ggg ------------------------ ${NC}"
  echo -e "${WHITE}ggg: gg. - ,ggg • WhatsApp : 6285854642521 ${NC}"
  echo -e "${WHITE} ggg: ggg._ _,ggg • Kredit : KawakunChan ${NC}"
  echo -e "${WHITE} ggg. '.'''ggggggp • Dukungan oleh KawakunChan ${NC}"
  echo -e "${WHITE} 'ggg '-.__ ${NC}"
  echo -e "${WHITE} ggg ${NC}"
  echo -e "${WHITE} ggg ${NC}"
  echo -e "${WHITE} ggg. ${NC}"
  echo -e "${WHITE} ggg. ${NC}"
  echo -e "${WHITE} b. ${NC}"
  echo -e " "
  echo -e "BERIKUT LIST INSTALL :"
  echo "1. Pasang tema"
  echo "2. Hapus tema"
  echo "3. Konfigurasi Sayap"
  echo "4. Buat Node"
  echo "5. Hapus Instalasi Panel"
  echo "6. Tema Stellar"
  echo "7. Meretas Panel Belakang"
  echo "8. Ubah Pw Vps"
  echo "x. Keluar"
  echo -e "Masukkan pilihan 1/2/x:"
  baca -r PILIHAN_MENU
  jernih

  kasus "$MENU_CHOICE" dalam
    1)
      instal tema
      ;;
    2)
      hapus_tema
      ;;
      3)
      konfigurasi_sayap
      ;;
      4)
      buat_node
      ;;
      5)
      panel_uninstall
      ;;
      6)
      instal_temaSteeler
      ;;
      7)
      panel_balik_peretasan
      ;;
      8)
      ubahpw_vps
      ;;
    X)
      echo "Keluar dari skrip."
      keluar 0
      ;;
    *)
      echo "Pilihan tidak valid, silahkan coba lagi."
      ;;
  esac
Selesai
