backup-workflows.md
 # Backup Workflows

## Daily System Backup
 
#!/bin/bash
# Create timestamped backup
DATE=$(date +%Y%m%d_%H%M%S)
tar -czf /backup/system_backup_$DATE.tar.gz /home /etc /var/log
echo "Backup completed: system_backup_$DATE.tar.gz"
Database Backup with Rotation
bash# MySQL backup with 7-day rotation
mysqldump -u root -p database_name > /backup/db_$(date +%Y%m%d).sql
find /backup -name "db_*.sql" -mtime +7 -delete
Rsync Incremental Backup
bash# Sync home directory to remote server
rsync -avz --delete /home/user/ user@backup-server:/backups/user/