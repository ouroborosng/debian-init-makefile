#!/bin/bash
set -e

echo "🎯 Installing and configuring Fail2Ban..."
apt install -y fail2ban

cat <<EOF > /etc/fail2ban/jail.local
[DEFAULT]
bantime  = 3600
findtime  = 600
maxretry = 5
destemail = root@localhost
sender = fail2ban@localhost
action = %(action_mwl)s
[sshd]
enabled = true
EOF

systemctl restart fail2ban
systemctl enable fail2ban

echo "✅ Fail2Ban configuration completed."