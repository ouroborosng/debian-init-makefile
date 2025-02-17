# Debian Init Makefile Project


![Automation](https://img.shields.io/badge/Automation-100%25-brightgreen)
![GitHub repo size](https://img.shields.io/github/repo-size/ouroborosng/debian-init-makefile)
![GitHub issues](https://img.shields.io/github/issues/ouroborosng/debian-init-makefile)
![Debian Supported](https://img.shields.io/badge/OS-Debian-blue?logo=debian)
![Shell Script](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash&logoColor=white)
![Makefile](https://img.shields.io/badge/Build-Makefile-brightgreen)

This project provides an automated setup for configuring a Debian-based system using a `Makefile` and modular shell scripts. It includes tasks such as system updates, security hardening, and application installation.

## Installation and Usage

### Prerequisites
Ensure the following environment variables are set before running `make all`:
- `ICMP_TRUSTED_IPV4`: Define a trusted IPv4 subnet (e.g., `192.168.1.0/24`)
- `ICMP_TRUSTED_IPV6`: Define a trusted IPv6 subnet (e.g., `fc00::/7`)

If these variables are not set, the Makefile execution will halt with an error message.

### Available Targets

- `all` - Executes system initialization, updates, security configuration, and tool installations.
- `init` - Initializes necessary directories.
- `system_update` - Updates the system packages.
- `configure_security` - Configures security features including AppArmor, Fail2Ban, firewall, system hardening, and unattended upgrades.
- `configure_security_manually` - Configures additional security settings that require user discretion.
- `disable_services` - Disables unnecessary services, including root SSH access.
- `install_security_tools` - Installs security-related tools such as ClamAV, debsecan, Logwatch, and Lynis.
- `secure_system` - Secures system logs and sets up scheduled security checks.
- `clean` - Removes temporary files created during execution.

### Running the Makefile

To execute the full setup, run the following command with the required variables:

```sh
make all ICMP_TRUSTED_IPV4=192.168.1.0/24 ICMP_TRUSTED_IPV6=fc00::/7
```

### Cleaning Up

``` sh
make clean
```

Removes any temporary or cache files created during execution.
