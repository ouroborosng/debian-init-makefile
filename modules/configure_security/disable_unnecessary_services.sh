#!/bin/bash
set -e

echo "Checking and disabling unnecessary services..."
SERVICES=("telnet" "ftp" "rsh-server" "rlogin" "rexec")

for SERVICE in "${SERVICES[@]}"; do
    if systemctl is-active --quiet $SERVICE; then
        echo "Disabling and stopping $SERVICE..."
        systemctl stop $SERVICE
        systemctl disable $SERVICE
    fi
done

echo "All unnecessary services have been checked and disabled."