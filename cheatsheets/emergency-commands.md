## System Recovery

# Boot into single-user mode (add to kernel parameters)
single
init=/bin/bash

# Reset root password (single-user mode)
passwd root

# Remount root filesystem as read-write
mount -o remount,rw /

# Check and repair filesystem
fsck /dev/sda1
fsck -y /dev/sda1  # Auto-yes to all prompts

# Emergency filesystem repair (unmount first)
umount /dev/sda1
e2fsck -f -y /dev/sda1


## Process Management Emergencies
bash# Kill all processes for a user
pkill -u username
killall -u username

# Kill process using specific port
lsof -ti:8080 | xargs kill -9
fuser -k 8080/tcp

# Kill all processes by name
killall -9 firefox
pkill -f "java.*tomcat"

# Find and kill memory-intensive processes
ps aux --sort=-%mem | head -10
kill -9 $(ps aux --sort=-%mem | awk 'NR==2{print $2}')

# Kill all zombie processes
kill -HUP $(ps -A -ostat,ppid | grep -e '^[Zz]' | awk '{print $2}')


## Disk Space Emergencies
bash# Find largest files/directories
du -ah / | sort -rh | head -20
find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null

# Clean up common space wasters
# Clean package cache
apt clean            # Ubuntu/Debian
yum clean all       # CentOS/RHEL

# Clean journal logs
journalctl --vacuum-time=7d
journalctl --vacuum-size=500M

# Find and delete core dumps
find / -name "core.*" -type f -delete 2>/dev/null

# Clean temporary files
rm -rf /tmp/*
rm -rf /var/tmp/*

# Empty trash (if GUI)
rm -rf ~/.local/share/Trash/*


## Network Emergencies
bash# Reset network interface
ip link set eth0 down
ip link set eth0 up
# OR
ifdown eth0 && ifup eth0

# Restart network service
systemctl restart networking     # Debian/Ubuntu
systemctl restart NetworkManager # Most modern distros
service network restart         # Older systems

# Flush DNS cache
systemctl restart systemd-resolved  # systemd
/etc/init.d/nscd restart            # nscd
resolvectl flush-caches             # systemd-resolved

# Emergency network configuration
ip addr add 192.168.1.100/24 dev eth0
ip route add default via 192.168.1.1
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# Check network connectivity
ping -c 4 8.8.8.8              # Test internet
ping -c 4 192.168.1.1          # Test gateway
traceroute 8.8.8.8             # Trace route
mtr google.com                  # Real-time traceroute

# Kill network-hogging processes
nethogs                         # Show bandwidth by process
ss -tuln | grep :80            # Check what's using port 80

## Memory Emergencies
bash# Free up memory immediately
echo 3 > /proc/sys/vm/drop_caches  # Clear page cache
sync && echo 1 > /proc/sys/vm/drop_caches  # Clear dentries/inodes

# Find memory-hungry processes
ps aux --sort=-%mem | head -10
top -o %MEM
smem -r  # If smem is installed

# Enable swap if disabled
swapon -a
# Create emergency swap file
dd if=/dev/zero of=/swapfile bs=1M count=1024
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Kill OOM (Out of Memory) processes
dmesg | grep -i "killed process"  # See what was killed
echo f > /proc/sysrq-trigger     # Trigger OOM killer manually

# Monitor memory usage
watch -n 1 'free -h'
watch -n 1 'cat /proc/meminfo | head -20'


## Boot Problems
bash# Check boot logs
journalctl -b                   # Current boot
journalctl -b -1               # Previous boot
dmesg | less                   # Kernel messages

# Fix GRUB bootloader
# From live USB/rescue mode:
mount /dev/sda1 /mnt           # Mount root partition
mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys
chroot /mnt
grub-install /dev/sda
update-grub
exit

# Reset file permissions for system directories
chmod 755 /
chmod 755 /usr
chmod 755 /usr/bin
chmod 1777 /tmp
chmod 755 /var

# Check for filesystem corruption
dmesg | grep -i error
cat /var/log/kern.log | grep -i error


## Service Failures
bash# Check failed services
systemctl --failed
systemctl list-units --failed

# Restart critical services
systemctl restart ssh
systemctl restart network
systemctl restart cron

# Check service status and logs
systemctl status service-name
journalctl -u service-name -f   # Follow logs
journalctl -u service-name --since "1 hour ago"

# Emergency service management
systemctl stop service-name
systemctl disable service-name
systemctl mask service-name     # Prevent starting

# Check what's preventing shutdown
systemctl list-jobs
lsof | grep deleted            # Find processes using deleted files


## File System Emergencies
bash# Check filesystem usage
df -h                          # Disk space
df -i                          # Inode usage
lsof | grep deleted           # Files deleted but still open

# Fix corrupted filesystem (DANGEROUS - backup first!)
umount /dev/sda1
fsck -f /dev/sda1             # Force check
fsck -f -y /dev/sda1          # Auto-fix
e2fsck -p /dev/sda1           # Automatic repair

# Recover deleted files
testdisk                      # Partition recovery tool
photorec                      # File recovery tool
extundelete /dev/sda1 --restore-all  # ext3/4 recovery

# Emergency mount options
mount -o ro,noexec,nosuid /dev/sda1 /mnt  # Read-only, secure
mount -o remount,rw /                      # Remount as read-write


## Security Emergencies
bash# Lock user account immediately
passwd -l username
usermod -L username

# Find suspicious processes
ps aux | grep -v "\[.*\]" | sort -k3 -rn  # High CPU usage
lsof -i                                    # Network connections
netstat -tulpn                            # Listening ports

# Check for rootkits and malware
chkrootkit
rkhunter --check
lynis audit system

# Monitor file changes
find /etc -type f -mtime -1               # Files modified in last day
find /bin /sbin /usr/bin -type f -mtime -1  # System binaries

# Emergency firewall rules
iptables -A INPUT -j DROP                 # Block all incoming
iptables -I INPUT -s trusted_ip -j ACCEPT # Allow trusted IP
ufw deny in                               # UFW block all

# Check authentication logs
grep "Failed password" /var/log/auth.log
grep "authentication failure" /var/log/auth.log
last -f /var/log/wtmp                     # Successful logins


## System Information for Troubleshooting
bash# Hardware information
lscpu                          # CPU info
lsblk                          # Block devices
lsusb                          # USB devices
lspci                          # PCI devices
dmidecode                      # Hardware details
hdparm -I /dev/sda            # Hard drive info

# System state
uptime                         # System uptime and load
w                             # Who is logged in
ps auxf                       # Process tree
lsof                          # Open files
ss -tuln                      # Network sockets

# Kernel and modules
uname -a                      # Kernel info
lsmod                         # Loaded modules
dmesg | tail -50             # Recent kernel messages
cat /proc/version            # Kernel version
cat /proc/cmdline            # Boot parameters


## Emergency Contact Information Template
bash# Create emergency contact file
cat > /root/emergency-contacts.txt << 'EOF'
=== EMERGENCY CONTACTS ===
System Administrator: admin@company.com
Network Team: network@company.com
Security Team: security@company.com

=== CRITICAL SYSTEM INFO ===
Hostname: $(hostname)
IP Address: $(ip route get 1 | awk '{print $7; exit}')
Last Boot: $(uptime -s)

=== BACKUP LOCATIONS ===
Config Backups: /backup/configs/
Database Backups: /backup/databases/
Application Backups: /backup/applications/

=== EMERGENCY PROCEDURES ===
1. Contact system administrator
2. Document the issue
3. Take screenshots/logs
4. Do not reboot unless authorized
EOF



## Quick System Recovery Checklist
 □ Document the problem (screenshots, error messages)
□ Check system logs (/var/log/syslog, journalctl)
□ Verify disk space (df -h)
□ Check memory usage (free -h)
□ Review running processes (ps aux, top)
□ Test network connectivity (ping, nslookup)
□ Check service status (systemctl --failed)
□ Backup critical data before making changes
□ Test fixes in safe mode or test environment first
□ Have recovery plan ready before attempting fixes
