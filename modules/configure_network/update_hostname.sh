#!/bin/bash

# Input arguments
NEW_HOSTNAME="$1"
NEW_DOMAIN="$2"

# Validate inputs
if [ -z "$NEW_HOSTNAME" ] && [ -z "$NEW_DOMAIN" ]; then
    echo "⚠️  Warning: No hostname or domain provided. Nothing to update."
    exit 1
fi

echo "Applying changes..."

# Update hostname if provided
if [ -n "$NEW_HOSTNAME" ]; then
    echo "🎯 Updating hostname to $NEW_HOSTNAME..."
    hostnamectl set-hostname "$NEW_HOSTNAME"
    echo "$NEW_HOSTNAME" > /etc/hostname
    sed -i "s/^\(127.0.1.1\s\+\S*\s\+\)\S*$/\1$NEW_HOSTNAME/" /etc/hosts
fi

# Update domain if provided
if [ -n "$NEW_DOMAIN" ]; then
    echo "🎯 Updating domain to $NEW_DOMAIN..."
    if [ -z "$NEW_HOSTNAME" ]; then
        NEW_HOSTNAME=$(hostnamectl --static)
        echo "ℹ️ No NEW_HOSTNAME provided. Using current hostname: $NEW_HOSTNAME"
    fi
    sed -i "s/^\(127.0.1.1\s\+\)\S*/\1$NEW_HOSTNAME.$NEW_DOMAIN/" /etc/hosts
fi

echo "✅ Update complete!"