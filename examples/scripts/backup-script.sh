#!/bin/bash
# Automated Backup Script
# Usage: ./backup-script.sh [config-file]

CONFIG_FILE=${1:-"/etc/backup.conf"}
DATE=$(date +%Y%m%d_%H%M%S)
LOG_FILE="/var/log/backup.log"

# Default configuration
BACKUP_SOURCE="/home /etc /var/www"
BACKUP_DEST="/backup"
RETENTION_DAYS=30
COMPRESS=true
REMOTE_BACKUP=false
REMOTE_HOST=""
REMOTE_USER=""
REMOTE_PATH=""

# Load configuration if exists
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to send notification
send_notification() {
    if [ -n "$EMAIL" ]; then
        echo "$1" | mail -s "Backup Notification - $(hostname)" "$EMAIL"
    fi
}

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DEST"

# Perform backup
log_message "Starting backup process"

if [ "$COMPRESS" = true ]; then
    BACKUP_FILE="$BACKUP_DEST/backup_$DATE.tar.gz"
    if tar -czf "$BACKUP_FILE" $BACKUP_SOURCE 2>>"$LOG_FILE"; then
        log_message "Backup created successfully: $BACKUP_FILE"
        BACKUP_SUCCESS=true
    else
        log_message "Backup creation failed"
        BACKUP_SUCCESS=false
    fi
else
    BACKUP_DIR="$BACKUP_DEST/backup_$DATE"
    if cp -r $BACKUP_SOURCE "$BACKUP_DIR" 2>>"$LOG_FILE"; then
        log_message "Backup created successfully: $BACKUP_DIR"
        BACKUP_SUCCESS=true
    else
        log_message "Backup creation failed"
        BACKUP_SUCCESS=false
    fi
fi

# Remote backup if enabled
if [ "$REMOTE_BACKUP" = true ] && [ "$BACKUP_SUCCESS" = true ]; then
    log_message "Starting remote backup"
    if [ "$COMPRESS" = true ]; then
        if scp "$BACKUP_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/" 2>>"$LOG_FILE"; then
            log_message "Remote backup completed successfully"
        else
            log_message "Remote backup failed"
        fi
    else
        if rsync -avz "$BACKUP_DIR/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/backup_$DATE/" 2>>"$LOG_FILE"; then
            log_message "Remote backup completed successfully"
        else
            log_message "Remote backup failed"
        fi
    fi
fi

# Cleanup old backups
log_message "Cleaning up old backups (older than $RETENTION_DAYS days)"
find "$BACKUP_DEST" -name "backup_*" -type f -mtime +$RETENTION_DAYS -delete 2>>"$LOG_FILE"
find "$BACKUP_DEST" -name "backup_*" -type d -mtime +$RETENTION_DAYS -exec rm -rf {} + 2>>"$LOG_FILE"

# Calculate backup size
if [ "$BACKUP_SUCCESS" = true ]; then
    if [ "$COMPRESS" = true ]; then
        BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
        log_message "Backup size: $BACKUP_SIZE"
    else
        BACKUP_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
        log_message "Backup size: $BACKUP_SIZE"
    fi
fi

log_message "Backup process completed"

# Send notification
if [ "$BACKUP_SUCCESS" = true ]; then
    send_notification "Backup completed successfully on $(hostname). Size: $BACKUP_SIZE"
else
    send_notification "Backup failed on $(hostname). Check logs for details."
fi