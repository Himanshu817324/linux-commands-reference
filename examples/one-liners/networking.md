
# Networking One-Liners

## Network Diagnostics
 
# Test connectivity to multiple hosts
for host in google.com github.com stackoverflow.com; do 
  ping -c 1 $host >/dev/null 2>&1 && echo "$host: UP" || echo "$host: DOWN"
done

# Port scan on local network
nmap -sn 192.168.1.0/24 | grep -E "Nmap scan report|MAC Address"

# Check which process is using a specific port
lsof -i :80 || ss -tulpn | grep :80

# Get external IP address
curl -s ifconfig.me || curl -s icanhazip.com
Network Monitoring
bash# Monitor network traffic by interface
watch -n 1 'cat /proc/net/dev | grep -E "(eth0|wlan0|enp)" | column -t'

# Active network connections
netstat -tulpn | grep LISTEN | sort -k4

# Bandwidth usage by process
nethogs -d 1

# DNS lookup for multiple domains
for domain in google.com github.com; do echo "$domain: $(dig +short $domain)"; done
SSH and Remote Operations
bash# Copy SSH key to multiple servers
for server in server1 server2 server3; do ssh-copy-id user@$server; done

# Execute command on multiple servers
for server in server1 server2 server3; do 
  echo "=== $server ===" 
  ssh user@$server 'uptime'
done

# Backup files from remote server
rsync -avz --progress user@remote:/path/to/files/ ./local-backup/

# Tunnel through SSH
ssh -L 8080:localhost:80 user@remote-server