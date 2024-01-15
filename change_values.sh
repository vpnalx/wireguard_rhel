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
                    # If confirmed, exit the loop
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
