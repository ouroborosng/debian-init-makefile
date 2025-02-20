#!/bin/bash
set -e

echo "Enabling & Starting nftables..."
systemctl enable nftables
systemctl start nftables

echo "Setting up advanced nftables rules..."

# Check if /usr/sbin is already in $PATH
if ! echo "$PATH" | grep -q "/usr/sbin"; then
    # Check if ~/.bashrc already contains the export line
    if ! grep -qxF 'export PATH=$PATH:/usr/sbin' ~/.bashrc; then
        echo 'export PATH=$PATH:/usr/sbin' >> ~/.bashrc
        echo "Added /usr/sbin to PATH in ~/.bashrc"
    else
        echo "/usr/sbin is already defined in ~/.bashrc"
    fi
    source ~/.bashrc
else
    echo "/usr/sbin is already in \$PATH"
fi
modprobe nf_conntrack
nft flush ruleset

cat <<EOF > /etc/nftables.conf
table inet firewall {
    # Define trusted CIDRs for both IPv4 and IPv6
    chain trusted_ips {
        ip saddr $TRUSTED_IPV4_CIDR accept
        ip6 saddr $TRUSTED_IPV6_CIDR accept
    }

    # Define ICMP rules
    chain icmp_trusted {
        ip protocol icmp jump trusted_ips
        ip6 nexthdr icmpv6 jump trusted_ips
    }

    # Define DHCP client requests only from LAN subnet
    chain dhcp_trusted {
        # Outbound DHCP traffic (client requests):
        # DHCP clients initiate requests with a source IP of 0.0.0.0 (or ::0 for IPv6).
        $ These packets are inherently trusted and can be accepted directly.

        ip protocol udp udp sport 68 udp dport 67 jump accept
        ip6 nexthdr udp udp sport 546 udp dport 547 jump accept
        
        # Inbound DHCP traffic (server responses):
        # DHCP servers reply with packets using a valid source IP (e.g., from port 67 for IPv4,
        # from port 547 for IPv6).  Since these responses could potentially be spoofed,
        # they are routed to the "trusted_ips" chain to verify that the source IP falls within the allowed CIDR(s).
        
        ip protocol udp udp sport 67 udp dport 68 jump trusted_ips
        ip6 nexthdr udp udp sport 547 udp dport 546 jump trusted_ips
    }

    # Define allowed public services
    chain services_public {
        tcp dport ssh accept
        tcp dport { 80, 443 } accept
    }

    # Input chain: Manage inbound traffic
    chain input {
        type filter hook input priority 0; policy drop;

        iif lo accept 

        ct state established,related accept

        # Allow ICMP only within the trusted range
        ip protocol icmp jump icmp_trusted
        ip6 nexthdr icmpv6 jump icmp_trusted

        # Apply DHCP rules using jump
        ip protocol udp jump dhcp_trusted
        ip6 nexthdr udp jump dhcp_trusted

        # Allow specified public services
        jump services_public
        
        # Log all dropped packets
        log prefix "Unauthorized_Access" flags all;
    }

    # Forward chain: Block all forwarded traffic by default
    chain forward {
        type filter hook forward priority 0; policy drop;
    }

    # Output chain: Allow all outgoing traffic
    chain output {
        type filter hook output priority 0; policy accept;
    }
}
EOF

systemctl restart nftables

echo "nftables configuration applied successfully."