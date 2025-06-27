
# System Maintenance Workflows

## Weekly System Cleanup
#!/bin/bash
# Clean package cache
apt autoclean
apt autoremove

# Clean log files older than 30 days
journalctl --vacuum-time=30d

# Clean temp files
find /tmp -type f -atime +7 -delete

# Update system
apt update && apt upgrade -y
Security Audit Workflow
bash# Run security checks
lynis audit system
rkhunter --check
chkrootkit

# Check for failed login attempts
grep "Failed password" /var/log/auth.log | tail -20

# Review sudo usage
grep sudo /var/log/auth.log | tail -10
Performance Monitoring Setup
bash# Install monitoring tools
apt install htop iotop iftop sysstat

# Enable system statistics collection
systemctl enable sysstat
systemctl start sysstat

# Create performance monitoring script
cat > /usr/local/bin/perf-check.sh << 'EOF'
#!/bin/bash
echo "=== CPU Usage ==="
top -bn1 | head -20

echo "=== Memory Usage ==="
free -h

echo "=== Disk Usage ==="
df -h

echo "=== Network Activity ==="
ss -tuln
EOF
chmod +x /usr/local/bin/perf-check.sh