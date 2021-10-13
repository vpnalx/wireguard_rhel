#!/bin/bash

echo "enter the client name:   "
read client_name
cat /etc/wireguard/$client_name.conf
