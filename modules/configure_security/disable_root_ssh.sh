#!/bin/bash
set -e

echo "Disabling root login over SSH..."
sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart ssh

echo "Root login over SSH has been disabled."