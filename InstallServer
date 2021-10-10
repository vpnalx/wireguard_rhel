#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install wireguard -y
sudo apt install wireguard-tools -y


sudo sed -i '/net.ipv4.ip_forward=1 /s/^#//' /etc/sysctl.conf

echo " creating server configuration"
sudo sysctl -p

cd /etc/wireguard
umask 077
sudo wg genkey | tee private.key | wg pubkey > public.key

echo "
[Interface]
PrivateKey = $(sudo cat /etc/wireguard/private.key)
Address = 10.5.0.1/24
MTU = 1420
ListenPort = 51820" > wg0.conf

sudo wg-quick up wg0
sudo systemctl enable wg-quick@wg0

echo -n "It is recommended to reboot the system. Enter 'yes' to reboot :   "
read input

if [ "$input" = "yes" ] ;then
        sudo reboot
else
        echo " Manually reboot the system later"
fi
