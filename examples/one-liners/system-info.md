# System Information One-Liners

## Hardware Information
 
# Get CPU information
lscpu | grep -E '^Thread|^Core|^Socket|^CPU\('

# Memory information with usage
free -h && echo "Swap usage:" && swapon --show

# Disk information with mount points
lsblk -f && echo -e "\nDisk usage:" && df -h

# Network interfaces and IPs
ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
Process and Performance
bash# Top 10 memory consuming processes
ps aux --sort=-%mem | head -11

# Top 10 CPU consuming processes
ps aux --sort=-%cpu | head -11

# Network connections by state
ss -tuln | awk 'NR>1 {print $1}' | sort | uniq -c

# Load average and uptime
uptime && echo "CPU cores: $(nproc)"
User and Security
bash# Last 10 successful logins
last -10 | grep -v "reboot\|shutdown"

# Users currently logged in
who && echo -e "\nActive sessions:" && w

# Failed login attempts today
grep "Failed password" /var/log/auth.log | grep "$(date '+%b %d')" | wc -l

# Check for users with UID 0 (potential security risk)
awk -F: '$3==0 {print $1}' /etc/passwd