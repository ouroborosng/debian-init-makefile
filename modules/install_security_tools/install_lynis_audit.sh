#!/bin/bash
set -e

echo "Installing and running Lynis for security auditing..."
apt install -y lynis
dpkg -L lynis | grep '/sbin/lynis' | sed 's:/lynis::' | xargs -I {} sh -c 'grep -qxF "export PATH=\$PATH:{}" ~/.bashrc || echo export PATH=\$PATH:{} >> ~/.bashrc' && source ~/.bashrc
lynis audit system --quiet --logfile /var/log/lynis-security.log

echo "Lynis security audit completed. Report saved in /var/log/lynis-security.log."