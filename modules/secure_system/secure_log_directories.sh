#!/bin/bash
set -e

echo "🎯 Securing log directories..."
SENSITIVE_LOGS=(
    "/var/log/secure"
    "/var/log/auth.log"
    "/var/log/audit"
    "/var/log/messages"
)

for LOG in "${SENSITIVE_LOGS[@]}"; do
    if [ -e "$LOG" ]; then
        echo "Setting permissions for $LOG"
        chmod 600 "$LOG"
        chown root:root "$LOG"
    fi
done

echo "✅ Log directory permissions have been secured."