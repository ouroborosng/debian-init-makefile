#!/bin/bash
set -e

echo "🎯 Setting up automated vulnerability remediation and security scans..."

cat <<EOF > /etc/cron.daily/vulnerability-scan
#!/bin/bash
set -e
echo "🎯 Running debsecan to check for known vulnerabilities..."
debsecan --suite=\$(lsb_release -sc) --only-fixed > /var/log/debsecan-report.txt

if grep -q "CVE" /var/log/debsecan-report.txt; then
    echo "⚠️ Vulnerabilities detected! Running unattended-upgrades to fix known issues..."
    unattended-upgrades -d
else
    echo "ℹ️ No vulnerabilities detected."
fi
EOF

chmod +x /etc/cron.daily/vulnerability-scan

cat <<EOF > /etc/cron.daily/system-update
#!/bin/bash
set -e
echo "🎯 Running apt update..."
apt update >> /var/log/system-update.log 2>&1
EOF

chmod +x /etc/cron.daily/system-update

cat <<EOF > /etc/cron.daily/security-scan
#!/bin/bash
clamscan -r --bell -i / >> /var/log/clamav-daily-scan.log
logwatch --output file --filename /var/log/logwatch-daily-report.txt --detail high
EOF

chmod +x /etc/cron.daily/security-scan

echo "✅ Cron jobs for automated security scans and vulnerability remediation have been set up."