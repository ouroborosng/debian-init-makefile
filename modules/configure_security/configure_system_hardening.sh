#!/bin/bash
set -e

echo "Starting system hardening configuration..."

# Ensure sysctl configuration is properly updated without overwriting entire files

# Enable Address Space Layout Randomization (ASLR)
echo "Enabling ASLR..."
if [ -f /proc/sys/kernel/randomize_va_space ]; then
    sysctl -w kernel.randomize_va_space=2
    if grep -q "^kernel.randomize_va_space" /etc/sysctl.conf; then
        sed -i 's/^kernel.randomize_va_space=.*/kernel.randomize_va_space=2/' /etc/sysctl.conf
    else
        echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf
    fi
else
    echo "ASLR is not supported on this system."
fi

# Disable core dumps for setuid programs
echo "Disabling core dumps for setuid programs..."
sysctl -w fs.suid_dumpable=0
if grep -q "^fs.suid_dumpable" /etc/sysctl.conf; then
    sed -i 's/^fs.suid_dumpable=.*/fs.suid_dumpable=0/' /etc/sysctl.conf
else
    echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf
fi

# Restrict ptrace to the same user (prevents unauthorized process memory access)
echo "Restricting ptrace scope..."
sysctl -w kernel.yama.ptrace_scope=1
if grep -q "^kernel.yama.ptrace_scope" /etc/sysctl.conf; then
    sed -i 's/^kernel.yama.ptrace_scope=.*/kernel.yama.ptrace_scope=1/' /etc/sysctl.conf
else
    echo "kernel.yama.ptrace_scope = 1" >> /etc/sysctl.conf
fi

# Restrict access to kernel logs
echo "Restricting access to dmesg logs..."
sysctl -w kernel.dmesg_restrict=1
if grep -q "^kernel.dmesg_restrict" /etc/sysctl.conf; then
    sed -i 's/^kernel.dmesg_restrict=.*/kernel.dmesg_restrict=1/' /etc/sysctl.conf
else
    echo "kernel.dmesg_restrict = 1" >> /etc/sysctl.conf
fi

# Disable kernel module loading if system is fully configured
echo "Checking if kernel module loading should be disabled..."
if ! lsmod | grep -q "nvidia\|vboxdrv"; then
    sysctl -w kernel.modules_disabled=1
    if grep -q "^kernel.modules_disabled" /etc/sysctl.conf; then
        sed -i 's/^kernel.modules_disabled=.*/kernel.modules_disabled=1/' /etc/sysctl.conf
    else
        echo "kernel.modules_disabled = 1" >> /etc/sysctl.conf
    fi
    echo "Kernel module loading has been disabled."
else
    echo "Kernel module loading is not disabled due to detected external drivers."
fi

# Disable Ctrl+Alt+Del reboot
echo "Disabling Ctrl+Alt+Del reboot..."
systemctl mask ctrl-alt-del.target

# Apply all sysctl changes immediately
sysctl -p

echo "System hardening configuration completed successfully."