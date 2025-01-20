#!/bin/bash
# mod by amiruldev

if [ "$(id -u)" -ne 0 ]; then
  echo "Script ini harus dijalankan sebagai root."
  exit 1
fi

# Unduh file config
wget -qO /etc/ssh/sshd_config https://raw.githubusercontent.com/XinnChan/ippanel/refs/heads/main/sshd_configs
systemctl restart sshd
clear

echo -e "Masukkan Password baru root:"
read -s pwe
usermod -p "$(openssl passwd -1 "$pwe")" root
clear
echo -e "Masukkan Hostname baru:"
read new_hostname
hostnamectl set-hostname "$new_hostname"
banner_file="/etc/motd"
echo "clear" > "$banner_file"
echo "============================================" > "$banner_file"
echo "Welcome to $new_hostname VPS" >> "$banner_file"
echo "Managed By Xin Kenji" >> "$banner_file"
echo "Whatsapp: +6282143067466" >> "$banner_file"
echo "============================================" >> "$banner_file"

ip_address=$(curl -Ls http://ipinfo.io/ip)
clear
printf "Mohon Simpan Informasi Akun VPS Ini\n"
printf "============================================\n"
printf "Akun Root (Akun Utama)\n"
printf "Hostname   = %s\n" "$new_hostname"
printf "Ip address = %s\n" "$ip_address"
printf "Username   = root\n"
printf "Password   = %s\n" "$pwe"
printf "Made By Xc Corporation || XCDDOS\n"
printf "============================================\n"
echo ""

if [ -f /etc/update-motd.d/10-uname ]; then
  rm /etc/update-motd.d/10-uname
fi

custom_banner_script="/etc/update-motd.d/10-custom-banner"
echo "#!/bin/sh" > "$custom_banner_script"
echo "cat /etc/motd" >> "$custom_banner_script"
chmod +x "$custom_banner_script"

exit
