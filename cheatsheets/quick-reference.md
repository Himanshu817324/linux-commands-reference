# Linux Commands Quick Reference

## File Operations

ls -la              # List files with details
cd /path            # Change directory
pwd                 # Show current directory
cp src dest         # Copy file/directory
mv old new          # Move/rename file
rm file             # Delete file
rm -rf dir          # Delete directory recursively
mkdir dir           # Create directory
find . -name "*.txt" # Find files by name
locate filename     # Find files in database
which command       # Show command location

## File Permissions
bashchmod 755 file      # rwxr-xr-x
chmod u+x file      # Add execute for user
chown user:group file # Change ownership
umask 022           # Set default permissions


## Text Processing
bashcat file            # Display file content
less file           # View file page by page
head -n 10 file     # First 10 lines
tail -f file        # Follow file changes
grep "pattern" file # Search in file
sed 's/old/new/g' file # Replace text
awk '{print $1}' file  # Print first column
sort file           # Sort lines
uniq file           # Remove duplicates
wc -l file          # Count lines



## System Information
bashps aux              # Show all processes
top                 # Real-time processes
htop                # Better process viewer
free -h             # Memory usage
df -h               # Disk usage
du -sh dir          # Directory size
uptime              # System uptime
who                 # Logged in users
id                  # Current user info
uname -a            # System information



## Network Commands
bashping host           # Test connectivity
wget url            # Download file
curl url            # Transfer data
ssh user@host       # Remote login
scp file user@host:path # Copy over SSH
netstat -tuln       # Network connections
ss -tuln            # Socket statistics
iftop               # Network traffic


## Archive Operations
bashtar -czf archive.tar.gz dir    # Create compressed archive
tar -xzf archive.tar.gz        # Extract archive
zip -r archive.zip dir         # Create zip archive
unzip archive.zip              # Extract zip


## Process Management
bashkill PID            # Terminate process
killall name        # Kill by name
jobs                # Show background jobs
bg %1               # Resume job in background
fg %1               # Bring job to foreground
nohup command &     # Run command after logout