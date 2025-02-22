#!/bin/bash
set -e

echo "🎯 Installing apparmor-utils and configuring AppArmor..."
apt install apparmor-utils -y
if command -v apparmor_status &>/dev/null; then
    systemctl enable apparmor
    systemctl start apparmor

    echo "✅ AppArmor is enabled and running."
else
    echo "⚠️ AppArmor is not available on this system."
fi