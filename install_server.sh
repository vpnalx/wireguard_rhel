#!/bin/bash

# Function to display the current values
display_values() {
    echo "1. Public IP: $public_ip"
    echo "2. IP with Mask (Default Interface): $ip_with_mask"
    echo "3. Interface Name (Default Route): $if_name"
}

# Function to change values based on user input
change_values() {
    while true; do
        read -p "Do you want to change the values? (yes/no): " change_response

        case $change_response in
            [Yy][Ee][Ss])
                display_values

                # Prompt for each value individually
                read -p "Do you want to change the Public IP? (yes/no): " change_public_ip
                if [[ $change_public_ip == "yes" ]]; then
                    read -p "Enter new Public IP: " public_ip
                fi

                read -p "Do you want to change the IP with Mask? (yes/no): " change_ip_with_mask
                if [[ $change_ip_with_mask == "yes" ]]; then
                    read -p "Enter new IP with Mask: " ip_with_mask
                fi

                read -p "Do you want to change the Interface Name? (yes/no): " change_if_name
                if [[ $change_if_name == "yes" ]]; then
                    read -p "Enter new Interface Name: " if_name
                fi

                # Confirm changes
                display_values
                read -p "Are these values correct? (yes/no): " confirm_changes

                if [[ $confirm_changes == "yes" ]]; then
                    # If confirmed, proceed with changes
                    apply_changes
                    break
                else
                    # If not confirmed, repeat the prompt
                    echo "Changes not confirmed. Please review and try again."
                fi
                ;;
            [Nn][Oo])
                echo "No changes were made. Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid input. Please enter 'yes' or 'no'."
                ;;
        esac
    done
}


# Function to apply changes
apply_changes() {
    # Uncommenting the ipv4 forward line from /etc/sysctl.conf
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/99-sysctl.conf
    sysctl -p

    # Creating server configuration
    cd /etc/wireguard
    umask 077
    wg genkey | tee private.key | wg pubkey > public.key

    echo "
[Interface]
PrivateKey = $(sudo cat /etc/wireguard/private.key)
Address = 10.5.0.1/24
MTU = 1420
ListenPort = 51820
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $if_name -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $if_name -j MASQUERADE " > wg0.conf

    wg-quick up wg0
    systemctl enable wg-quick@wg0

    # Downloading other required files for client configuration
    cd /usr/local/bin
    wget https://raw.githubusercontent.com/vpnalx/wireguard_rhel/main/create_clients.sh  
    wget https://raw.githubusercontent.com/vpnalx/wireguard_rhel/main/remove_all_clients.sh  
    wget https://raw.githubusercontent.com/vpnalx/wireguard_rhel/main/uninstall_wg.sh   
    wget https://raw.githubusercontent.com/vpnalx/wireguard_rhel/main/helpwg.sh   
    wget https://raw.githubusercontent.com/vpnalx/wireguard_rhel/main/remove_client.sh  
    wget https://raw.githubusercontent.com/vpnalx/wireguard_rhel/main/qr_client.sh  
    wget https://raw.githubusercontent.com/vpnalx/wireguard_rhel/main/client_config_text.sh   

    mv create_clients.sh vpnA
    mv remove_all_clients.sh vpnDA
    mv uninstall_wg.sh vpnU
    mv helpwg.sh vpn
    mv remove_client.sh vpnD
    mv qr_client.sh vpnQ
    mv client_config_text.sh vpnCT

    chmod +x vpnA vpnDA vpnU vpnD vpnQ vpn vpnCT

    echo "$public_ip" > /etc/wireguard/PublicIP

    echo $'*************************************\nUse these commands to configure your WireGuard clients'
    echo $'\nvpn   :- Display help message\nvpnA  :- Add a new client\nvpnCT :- Show client configuration in Text\nvpnQ  :- Generate QR code for client configuration\nvpnD  :- Delete a client\nvpnDA :- Delete all clients\nvpnU  :- Uninstall WireGuard VPN and all configuration'
    echo $'\n*************************************'
    echo -e "It is most likely that you need to reboot the system to get the WireGuard service up and running.\nEnter 'yes' to reboot :   "

    read -r input

    if [ "$input" = "yes" ] ;then
        reboot
    else
        echo "Manually reboot the system later"
    fi
}

# Checking if the script is being run as sudo or by root user
if (($EUID != 0)); then
    echo "Please run this script as root or using sudo"
    exit
fi

# Install required packages
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
dnf update -y
dnf install wget qrencode wireguard-tools -y


# Get public IP
public_ip=$(curl -4 ifconfig.co 2>/dev/null)

# Initialize variables
ip_with_mask=""
if_name=""

default_route_info=$(ip route | grep default)
if [[ $default_route_info =~ dev[[:space:]]([[:alnum:]]+) ]]; then
    if_name=${BASH_REMATCH[1]}
    ip_with_mask=$(ip addr show dev $if_name | awk '/inet / {print $2}')
fi

# Display current values
display_values

# Ask user if they want to change values
change_values
