#!/bin/bash

echo "enter the client name:   "
read client_name
sudo cat /etc/wireguard/$client_name.conf
