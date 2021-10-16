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
ListenPort = 51820
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE " > wg0.conf

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
wget https://raw.githubusercontent.com/vpnalx/wireguard/main/client_config_text.sh

mv create_clients.sh /usr/local/bin/vpnA
mv remove_all_clients.sh /usr/local/bin/vpnDA
mv uninstall_wg.sh /usr/local/bin/vpnU
mv helpwg.sh /usr/local/bin/vpn
mv remove_client.sh /usr/local/bin/vpnD
mv qr_client.sh /usr/local/bin/vpnQ
mv client_config_text.sh /usr/local/bin/vpnCT
cd /usr/local/bin

chmod +x vpnA vpnDA vpnU vpnD vpnQ vpn vpnCT

echo echo "enter the public IP or DNS name of your server"
read PublicIP  < /dev/tty

echo $PublicIP > /etc/wireguard/PublicIP

echo $'*************************************\nUse these commands to configure your wireguard clients'
echo $'\nvpn   :- Display help message\nvpnA  :- Add a new client\nvpnCT  :- Show client configuration in Text\nvpnQ  :- Generate QR code for client configuration\nvpnD  :- Delete a client\nvpnDA :- Delete all clients\nvpnU  :- Uninstall wireguard VPN and all configuration'
echo $'\n*************************************'
echo -e "It is recommended to reboot the system.\nEnter 'yes' to reboot :   "

read input < /dev/tty

if [ "$input" = "yes" ] ;then
	reboot
else
        echo " Manually reboot the system later"
fi
