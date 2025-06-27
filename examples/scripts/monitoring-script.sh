
#!/bin/bash
# System Monitoring Script
# Usage: ./monitoring-script.sh [email@domain.com]

EMAIL=${1:-admin@localhost}
HOSTNAME=$(hostname)
LOG_FILE="/var/log/system-monitor.log"
ALERT_THRESHOLD_CPU=80
ALERT_THRESHOLD_MEM=85
ALERT_THRESHOLD_DISK=90

# Function to log with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Check CPU usage
check_cpu() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    CPU_USAGE=${CPU_USAGE%.*}  # Remove decimal part
    
    if [ "$CPU_USAGE" -gt "$ALERT_THRESHOLD_CPU" ]; then
        ALERT="HIGH CPU USAGE: ${CPU_USAGE}% on $HOSTNAME"
        log_message "$ALERT"
        echo "$ALERT" | mail -s "CPU Alert - $HOSTNAME" "$EMAIL"
    fi
}

# Check Memory usage
check_memory() {
    MEM_USAGE=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')
    
    if [ "$MEM_USAGE" -gt "$ALERT_THRESHOLD_MEM" ]; then
        ALERT="HIGH MEMORY USAGE: ${MEM_USAGE}% on $HOSTNAME"
        log_message "$ALERT"
        echo "$ALERT" | mail -s "Memory Alert - $HOSTNAME" "$EMAIL"
    fi
}

# Check Disk usage
check_disk() {
    df -h | awk 'NR>1 {print $5 " " $6}' | while read OUTPUT; do
        USAGE=$(echo "$OUTPUT" | awk '{print $1}' | sed 's/%//')
        PARTITION=$(echo "$OUTPUT" | awk '{print $2}')
        
        if [ "$USAGE" -gt "$ALERT_THRESHOLD_DISK" ]; then
            ALERT="HIGH DISK USAGE: ${USAGE}% on partition $PARTITION ($HOSTNAME)"
            log_message "$ALERT"
            echo "$ALERT" | mail -s "Disk Alert - $HOSTNAME" "$EMAIL"
        fi
    done
}

# Check system services
check_services() {
    SERVICES=("ssh" "nginx" "mysql" "apache2")
    
    for service in "${SERVICES[@]}"; do
        if systemctl is-active --quiet "$service"; then
            log_message "Service $service is running"
        else
            ALERT="Service $service is not running on $HOSTNAME"
            log_message "$ALERT"
            echo "$ALERT" | mail -s "Service Alert - $HOSTNAME" "$EMAIL"
        fi
    done
}

# Main execution
log_message "Starting system monitoring check"
check_cpu
check_memory
check_disk
check_services
log_message "System monitoring check completed"