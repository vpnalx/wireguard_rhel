#!/bin/bash

echo "enter the client name:   "
read client_name
sudo cat /etc/wireguard/client_configs/$client_name.conf
