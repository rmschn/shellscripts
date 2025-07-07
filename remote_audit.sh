#!/bin/bash

# List of hosts (edit this with your servers)
HOSTS=(
    "user1@host1.example.com"
    "user2@host2.example.com"
    "user3@host3.example.com"
)

# Output file
REPORT="remote_audit_report.txt"
echo "Remote Audit Report - $(date)" > "$REPORT"
echo "==================================" >> "$REPORT"

for HOST in "${HOSTS[@]}"; do
    echo "Auditing $HOST..."
    {
        echo ""
        echo "===== $HOST ====="
        echo "Uptime:"
        ssh -o BatchMode=yes -o ConnectTimeout=5 "$HOST" "uptime" 2>/dev/null

        echo ""
        echo "Last Logins:"
        ssh "$HOST" "last -n 3" 2>/dev/null

        echo ""
        echo "Netstat (listening ports):"
        ssh "$HOST" "netstat -tuln | grep LISTEN" 2>/dev/null

        echo ""
        echo "Running Processes (top 5 by CPU):"
        ssh "$HOST" "ps aux --sort=-%cpu | head -n 6" 2>/dev/null

        echo "-----------------------------"
    } >> "$REPORT"
done

echo "Audit complete. See $REPORT for details."