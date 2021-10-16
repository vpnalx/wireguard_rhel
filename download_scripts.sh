#!/bin/bash

if (($EUID != 0)); then
        echo "Please run this script as root or using sudo"
        exit
fi
echo "donwloading wireguard server installation script from https://raw.githubusercontent.com/vpnalx/wireguard/wg_server_install_script"

sudo wget https://raw.githubusercontent.com/vpnalx/wireguard/main/install_server.sh

sudo chmod +x install_server.sh

sudo ./install_server.sh



