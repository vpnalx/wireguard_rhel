#!/bin/bash
#test comment
#test 1
sudo rm -rf /etc/wireguard
sudo dnf remove wireguard -y
sudo dnf remove wireguard-tools -y


echo "deleting wireguard scripts"
sudo rm /usr/local/bin/*
