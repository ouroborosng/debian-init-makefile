#!/bin/bash
set -e

echo "🎯 Installing net-tools..."
apt install -y net-tools mtr 

echo "✅ net-tools installed successfully."

echo "🎯 Checking open ports and active services..."
netstat -tuln