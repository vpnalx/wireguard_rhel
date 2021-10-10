#!/bin/bash

sudo rm -rf /etc/wireguard/clients
sudo rm -rf /etc/wireguard/configs

echo " regenerating server configuration"


cd /etc/wireguard
umask 077
sudo wg genkey | tee private.key | wg pubkey > public.key

echo "[Interface]
PrivateKey = $(sudo cat /etc/wireguard/private.key)
Address = 10.5.0.1/24
MTU = 1420
ListenPort = 51820" > wg0.conf

sudo systemctl restart wg-quick@wg0
