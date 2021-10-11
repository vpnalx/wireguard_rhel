#!/bin/bash

#Creating directories for client keys and configs

sudo mkdir -p foo /etc/wireguard/client_keys
sudo mkdir -p foo /etc/wireguard/configs

echo " enter the name of the client"
read client_name

echo "enter the public IP or DNS name of your server"
read PublicIP


cd /etc/wireguard/client_keys
umask 077

sudo wg genkey | tee "$client_name".private.key | wg pubkey > "$client_name".public.key


#Using the number of config files to automatically increment the Last Octect(LO) of ip address for each client configuration file.

LO=$(ls /etc/wireguard/configs | wc -l)
LOV=$((LO+10))
# LOV= last octect value, ie, adding 10 to the number of configs to use values from 10.5.0.10,11,12,13,14....etc

echo "[Interface]
PrivateKey = $(cat "/etc/wireguard/clients/"$client_name".private.key")
ListenPort = 51820
Address = 10.5.0."$LOV"/24 " > /etc/wireguard/configs/$client_name.conf

echo "
[Peer]
PublicKey = $(cat /etc/wireguard/public.key)
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = $PublicIP:51820" >>/etc/wireguard/configs/$client_name.conf

echo " created $client_name.conf"

echo "
[Peer] #$client_name#
PublicKey = $(cat /etc/wireguard/client_keys/"$client_name".public.key)
AllowedIPs =10.5.0."$LOV"/32" >> /etc/wireguard/wg0.conf

echo "udpated server configuration with the new client information"

echo "deleting key files from /etc/wireguard/clent_keys"
sudo rm -rf /etc/wireguard/client_keys/

echo "done"

sudo systemctl restart wg-quick@wg0.service
