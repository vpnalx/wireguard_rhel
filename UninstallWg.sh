#!/bin/bash
sudo rm -rf /etc/wireguard
sudo apt purge wireguard -y
sudo apt purge wireguard-tools -y
sudo ip link delete wg0
