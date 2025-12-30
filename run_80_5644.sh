#!/bin/bash
# Base58Labs API Rate Limiter Setup
# Configures iptables rules for DDoS protection on Layer 4

LIMIT=100
BURST=20
PORT=8080

echo "[INFO] Initializing Rate Limiter..."
echo "[CONF] Limit: $LIMIT req/s | Burst: $BURST"

# Create custom chain
iptables -N API_LIMIT 2>/dev/null
iptables -F API_LIMIT

# Allow established connections
iptables -A API_LIMIT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Apply Rate Limiting
iptables -A API_LIMIT -p tcp --dport $PORT -m state --state NEW -m limit --limit $LIMIT/second --limit-burst $BURST -j ACCEPT
iptables -A API_LIMIT -p tcp --dport $PORT -j DROP

echo "[SUCCESS] Firewall rules applied."
