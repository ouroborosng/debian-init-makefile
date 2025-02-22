#!/bin/bash
set -e

echo "🎯 Cleaning up temporary files and cache..."
apt autoremove -y
apt clean

echo "✅ Cleanup completed."