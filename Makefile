SHELL := /bin/bash
STAMP_DIR := /tmp/debian-init

# Main target
all: init system_update configure_security install_security_tools secure_system

## Initialization
init:
	@echo "Initializing temporary directories..."
	mkdir -p $(STAMP_DIR)

## System Update
system_update:
	@if [ ! -f $(STAMP_DIR)/system_update ]; then echo "Executing system_update.sh..."; bash ./modules/system_update.sh; touch $(STAMP_DIR)/system_update; \
	else echo "ℹ️ system_update.sh has already been executed. Skipping..."; fi

## Network Configuration
update_hostname:
	@echo "Executing update_hostname.sh..."
	bash ./modules/configure_network/update_hostname.sh "$(NEW_HOSTNAME)" "$(NEW_DOMAIN)"

## Security Configuration
configure_security: configure_apparmor configure_fail2ban configure_firewall configure_system_hardening configure_unattended_upgrades disable_services

configure_apparmor:
	@if [ ! -f $(STAMP_DIR)/configure_apparmor ]; then echo "Executing configure_apparmor.sh..."; bash ./modules/configure_security/configure_apparmor.sh; touch $(STAMP_DIR)/configure_apparmor; \
	else echo "ℹ️ configure_apparmor.sh has already been executed. Skipping..."; fi

configure_fail2ban:
	@if [ ! -f $(STAMP_DIR)/configure_fail2ban ]; then echo "Executing configure_fail2ban.sh..."; bash ./modules/configure_security/configure_fail2ban.sh; touch $(STAMP_DIR)/configure_fail2ban; \
	else echo "ℹ️ configure_fail2ban.sh has already been executed. Skipping..."; fi

configure_firewall:
	@if [ -z "$(TRUSTED_IPV4_CIDR)" ]; then echo "Error: TRUSTED_IPV4_CIDR is not set. Please provide a valid subnet (e.g., make configure_firewall TRUSTED_IPV4_CIDR=192.168.1.0/24)"; exit 1; fi
	@if [ -z "$(TRUSTED_IPV6_CIDR)" ]; then echo "Error: TRUSTED_IPV6_CIDR is not set. Please provide a valid subnet (e.g., make configure_firewall TRUSTED_IPV6_CIDR=fc00::/7)"; exit 1; fi
	@if [ ! -f $(STAMP_DIR)/configure_firewall ]; then echo "Executing configure_firewall.sh..."; bash ./modules/configure_security/configure_firewall.sh; touch $(STAMP_DIR)/configure_firewall; \
	else echo "ℹ️ configure_firewall.sh has already been executed. Skipping..."; fi

configure_system_hardening:
	@if [ ! -f $(STAMP_DIR)/configure_system_hardening ]; then echo "Executing configure_system_hardening.sh..."; bash ./modules/configure_security/configure_system_hardening.sh; touch $(STAMP_DIR)/configure_system_hardening; \
	else echo "ℹ️ configure_system_hardening.sh has already been executed. Skipping..."; fi

configure_unattended_upgrades:
	@if [ ! -f $(STAMP_DIR)/configure_unattended_upgrades ]; then echo "Executing configure_unattended_upgrades.sh..."; bash ./modules/configure_security/configure_unattended_upgrades.sh; touch $(STAMP_DIR)/configure_unattended_upgrades; \
	else echo "ℹ️ configure_unattended_upgrades.sh has already been executed. Skipping..."; fi

## Security Configuration Manually
configure_compiler_restrictions:
	@if [ ! -f $(STAMP_DIR)/configure_compiler_restrictions ]; then echo "Executing configure_compiler_restrictions.sh..."; bash ./modules/configure_security/configure_compiler_restrictions.sh; touch $(STAMP_DIR)/configure_compiler_restrictions; \
	else echo "ℹ️ configure_compiler_restrictions.sh has already been executed. Skipping..."; fi

## Disable Unnecessary Services
disable_services: disable_root_ssh disable_unnecessary_services

disable_root_ssh:
	@if [ ! -f $(STAMP_DIR)/disable_root_ssh ]; then echo "Executing disable_root_ssh.sh..."; bash ./modules/configure_security/disable_root_ssh.sh; touch $(STAMP_DIR)/disable_root_ssh; \
	else echo "ℹ️ disable_root_ssh.sh has already been executed. Skipping..."; fi

disable_unnecessary_services:
	@if [ ! -f $(STAMP_DIR)/disable_unnecessary_services ]; then echo "Executing disable_unnecessary_services.sh..."; bash ./modules/configure_security/disable_unnecessary_services.sh; touch $(STAMP_DIR)/disable_unnecessary_services; \
	else echo "ℹ️ disable_unnecessary_services.sh has already been executed. Skipping..."; fi

## Install Security Tools
install_security_tools: install_clamav install_debsecan install_logwatch install_lynis_audit install_net_tools

install_clamav:
	@if [ ! -f $(STAMP_DIR)/install_clamav ]; then echo "Executing install_clamav.sh..."; bash ./modules/install_security_tools/install_clamav.sh; touch $(STAMP_DIR)/install_clamav; \
	else echo "ℹ️ install_clamav.sh has already been executed. Skipping..."; fi

install_debsecan:
	@if [ ! -f $(STAMP_DIR)/install_debsecan ]; then echo "Executing install_debsecan.sh..."; bash ./modules/install_security_tools/install_debsecan.sh; touch $(STAMP_DIR)/install_debsecan; \
	else echo "ℹ️ install_debsecan.sh has already been executed. Skipping..."; fi

install_logwatch:
	@if [ ! -f $(STAMP_DIR)/install_logwatch ]; then echo "Executing install_logwatch.sh..."; bash ./modules/install_security_tools/install_logwatch.sh; touch $(STAMP_DIR)/install_logwatch; \
	else echo "ℹ️ install_logwatch.sh has already been executed. Skipping..."; fi

install_lynis_audit:
	@if [ ! -f $(STAMP_DIR)/install_lynis_audit ]; then echo "Executing install_lynis_audit.sh..."; bash ./modules/install_security_tools/install_lynis_audit.sh; touch $(STAMP_DIR)/install_lynis_audit; \
	else echo "ℹ️ install_lynis_audit.sh has already been executed. Skipping..."; fi

install_net_tools:
	@if [ ! -f $(STAMP_DIR)/install_net_tools ]; then echo "Executing install_net_tools.sh..."; bash ./modules/install_security_tools/install_net_tools.sh; touch $(STAMP_DIR)/install_net_tools; \
	else echo "ℹ️ install_net_tools.sh has already been executed. Skipping..."; fi

## Secure System
secure_system: secure_log_directories setup_cron_jobs

secure_log_directories:
	@if [ ! -f $(STAMP_DIR)/secure_log_directories ]; then echo "Executing secure_log_directories.sh..."; bash ./modules/secure_system/secure_log_directories.sh; touch $(STAMP_DIR)/secure_log_directories; \
	else echo "ℹ️ secure_log_directories.sh has already been executed. Skipping..."; fi

setup_cron_jobs:
	@if [ ! -f $(STAMP_DIR)/setup_cron_jobs ]; then echo "Executing setup_cron_jobs.sh..."; bash ./modules/secure_system/setup_cron_jobs.sh; touch $(STAMP_DIR)/setup_cron_jobs; \
	else echo "ℹ️ setup_cron_jobs.sh has already been executed. Skipping..."; fi

## Cleanup
clean:
	@echo "Cleaning temporary files..."
	rm -rf $(STAMP_DIR)

.PHONY: all init system_update clean update_hostname configure_security install_security_tools secure_system disable_services