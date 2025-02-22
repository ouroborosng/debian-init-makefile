#!/bin/bash
set -e

echo "🎯 Updating package lists and upgrading installed packages..."
apt update -y
apt upgrade -y
apt dist-upgrade -y

echo "Installing necessary packages..."
apt install -y software-properties-common apt-transport-https ca-certificates curl gnupg2 lsb-release

echo "✅ System update completed."