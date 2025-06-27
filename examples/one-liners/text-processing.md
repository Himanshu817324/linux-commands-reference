
# Text Processing One-Liners

## Data Extraction and Analysis
 
# Extract unique values from CSV column
cut -d',' -f2 data.csv | sort | uniq

# Count occurrences of each word
tr ' ' '\n' < file.txt | sort | uniq -c | sort -nr

# Get lines between two patterns
sed -n '/START/,/END/p' file.txt

# Remove duplicate lines while preserving order
awk '!seen[$0]++' file.txt
Log File Analysis
bash# Extract IP addresses from log file
grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' access.log | sort | uniq -c

# Count HTTP status codes
awk '{print $9}' access.log | sort | uniq -c | sort -nr

# Find lines with specific timestamp range
awk '/2023-01-01 10:00/,/2023-01-01 11:00/' logfile.log

# Extract URLs with parameters
grep -oP 'GET \K[^?" ]+(\?[^" ]*)?' access.log | sort | uniq -c



## Configuration File Processing

# Remove comments and empty lines
grep -v '^#' config.file | grep -v '^$'

# Extract configuration values
grep -E '^[a-zA-Z]' config.file | cut -d'=' -f2

# Validate JSON files in directory
for file in *.json; do python -m json.tool "$file" >/dev/null && echo "$file: Valid" || echo "$file: Invalid"; done

# Convert CSV to JSON
awk -F',' 'NR==1{for(i=1;i<=NF;i++)h[i]=$i;next}{for(i=1;i<=NF;i++)printf "\"%s\":\"%s\",",h[i],$i;print ""}' data.csv