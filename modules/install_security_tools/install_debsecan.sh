#!/bin/bash
set -e

echo "🎯 Installing and running debsecan for known vulnerabilities detection..."
apt install -y debsecan
debsecan --suite=$(lsb_release -sc) --only-fixed > /var/log/debsecan-report.txt

echo "✅ Vulnerability scan results saved to /var/log/debsecan-report.txt."