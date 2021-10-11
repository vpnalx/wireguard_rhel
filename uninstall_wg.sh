#!/bin/bash
#test comment
#test 1
sudo rm -rf /etc/wireguard
sudo apt purge wireguard -y
sudo apt purge wireguard-tools -y
sudo ip link delete wg0
