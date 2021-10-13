#!/bin/bash

echo "enter the client name:  "
read qrclient

qrencode -t "ansiutf8" < /etc/wireguard/client_configs/$qrclient.conf
