
# Log Analysis Workflows

## Apache/Nginx Log Analysis
 
# Top 10 IP addresses by request count
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -nr | head -10

# Top 10 requested pages
awk '{print $7}' /var/log/nginx/access.log | sort | uniq -c | sort -nr | head -10

# 404 errors analysis
grep "404" /var/log/nginx/access.log | awk '{print $7}' | sort | uniq -c | sort -nr
System Log Monitoring
bash# Monitor real-time logs
tail -f /var/log/syslog | grep -E "(error|fail|critical)"

# Search for specific errors in last 24 hours
journalctl --since "24 hours ago" --priority=3

# Analyze authentication logs
grep "authentication failure" /var/log/auth.log | awk '{print $9}' | sort | uniq -c
Application Error Analysis
bash# Find most common errors in application logs
grep -i "error" /var/log/application.log | \
  sed 's/.*ERROR/ERROR/' | \
  sort | uniq -c | sort -nr | head -20

# Memory leak detection
grep -i "out of memory\|memory allocation failed" /var/log/kern.log