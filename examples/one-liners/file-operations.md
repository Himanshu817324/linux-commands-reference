### file-operations.md
  
# File Operations One-Liners

## Find and Replace
 
# Replace text in all files recursively
find . -type f -exec sed -i 's/old_text/new_text/g' {} +

# Find files larger than 100MB
find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null

# Find and delete empty directories
find . -type d -empty -delete

# Copy files modified in last 7 days
find /source -mtime -7 -type f -exec cp {} /destination/ \;
File Content Analysis
bash# Count lines in all Python files
find . -name "*.py" -exec wc -l {} + | tail -1

# Find duplicate files by MD5
find . -type f -exec md5sum {} + | sort | uniq -w32 -dD

# Extract unique email addresses from files
grep -Eho '\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b' * | sort -u

# Find files containing specific text
grep -r "pattern" . --include="*.txt" --exclude-dir=".git"
Archive Operations
bash# Extract all archives in current directory
for file in *.{tar.gz,tar.bz2,zip}; do 
  [[ -f "$file" ]] && case "$file" in
    *.tar.gz) tar -xzf "$file" ;;
    *.tar.bz2) tar -xjf "$file" ;;
    *.zip) unzip "$file" ;;
  esac
done

# Create dated backup of directory
tar -czf "backup_$(date +%Y%m%d_%H%M%S).tar.gz" /path/to/directory