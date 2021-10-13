#!/bin/bash

echo "enter the client name:  "
read qrclient

qrencode -t "ansiutf8" < ~/wg_client_configs/$qrclient.conf
