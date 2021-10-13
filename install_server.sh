#!/bin/bash


#checking if the script is being run as sudo or by root useir

if (($EUID != 0)); then
        echo "Please run this script as root or using sudo"
        exit
fi

apt update -y
apt upgrade -y
apt install wireguard -y
apt install qrencode -y

#Uncommenting the ipv4 forward line from /etc/sysctl.conf

sed -i '/net.ipv4.ip_forward=1 /s/^#//g' /etc/sysctl.conf

sysctl -p

echo " creating server configuration"

cd /etc/wireguard
umask 077
wg genkey | tee private.key | wg pubkey > public.key

echo "
[Interface]
PrivateKey = $(sudo cat /etc/wireguard/private.key)
Address = 10.5.0.1/24
MTU = 1420
ListenPort = 51820" > wg0.conf

wg-quick up wg0
systemctl enable wg-quick@wg0

echo " Downloading other required files for client configurarion.."


cd 
wget https://raw.githubusercontent.com/vpnalx/wireguard/main/create_clients.sh
wget https://raw.githubusercontent.com/vpnalx/wireguard/main/remove_all_clients.sh
wget https://raw.githubusercontent.com/vpnalx/wireguard/main/uninstall_wg.sh
wget https://raw.githubusercontent.com/vpnalx/wireguard/main/helpwg.sh
wget https://raw.githubusercontent.com/vpnalx/wireguard/main/remove_client.sh
wget https://raw.githubusercontent.com/vpnalx/wireguard/main/qr_client.sh

mv create_clients.sh /usr/local/bin/vpnA
mv remove_all_clients.sh /usr/local/bin/vpnDA
mv uninstall_wg.sh /usr/local/bin/vpnU
mv helpwg.sh /usr/local/bin/vpn
mv remove_client.sh /usr/local/bin/vpnD
mv qr_client.sh /usr/local/bin/vpnQ

cd /usr/local/bin

chmod +x vpnA vpnDA vpnU vpnD vpnQ vpn


echo -e "It is recommended to reboot the system. \nEnter 'yes' to reboot :   "

read -p input

if [ "$input" = "yes" ] ;then
        reboot
else
        echo " Manually reboot the system later"
fi
