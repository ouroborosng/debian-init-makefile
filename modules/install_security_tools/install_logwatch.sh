#!/bin/bash
set -e
echo "Installing and configuring Logwatch for log monitoring..."
apt install -y logwatch
logwatch --output file --filename /var/log/logwatch-report.txt --detail high

echo "Logwatch installed and initial report generated in /var/log/logwatch-report.txt."