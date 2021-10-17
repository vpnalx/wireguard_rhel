#!/bin/bash

if (($EUID != 0)); then
        echo "Please run this script as root or using sudo"
        exit
fi
echo "Downloading wireguard server installation script from https://raw.githubusercontent.com/vpnalx/wireguard/wg_server_install_script"

sudo wget https://raw.githubusercontent.com/vpnalx/wireguard/main/install_server.sh

echo " making the script executable"

sudo chmod +x install_server.sh



echo "Running the script using sudo ./install_server"
echo "to install wireguard server and download client configuration scripts to this machine"



