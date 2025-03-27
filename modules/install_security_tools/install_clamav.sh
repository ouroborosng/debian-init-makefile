#!/bin/bash
set -e

echo "🎯 Installing ClamAV for antivirus protection..."
apt install -y clamav clamav-daemon
systemctl stop clamav-freshclam
freshclam
systemctl start clamav-freshclam
systemctl enable clamav-freshclam
systemctl start clamav-daemon
systemctl enable clamav-daemon

echo "✅ ClamAV installed and initial virus scan is running in the background..."
clamscan -r --bell -i / > /var/log/clamav-daily-scan.log 2>&1 &