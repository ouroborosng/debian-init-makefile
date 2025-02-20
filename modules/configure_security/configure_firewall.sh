#!/bin/bash
set -e

echo "Enabling & Starting nftables..."
systemctl enable nftables
systemctl start nftables

echo "Setting up advanced nftables rules..."
modprobe nf_conntrack
nft flush ruleset

cat <<EOF > /etc/nftables.conf
table inet firewall {
    # Define trusted ICMP rules
    chain icmp_trusted {
        ip saddr $ICMP_TRUSTED_IPV4 accept
        ip6 saddr $ICMP_TRUSTED_IPV6 accept
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