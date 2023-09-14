# 1. Unix Scripting
# A company's server contains multiple nested directories within the Documents directory, each containing files and/or subdirectories. As part of an advanced maintenance task, the company needs a shell script that automates several intricate operations on the Documents directory using advanced unix concepts and commands.
# The Documents directory structure is as follows:
# Reports/
# Weekly! Weekly Report.txt
# - Monthly/
# Monthly Report.bet
# -Data/
# Sales/
# Sales Data.csv
# -Customers/
# -Customer List.csv
# -Backup/
# -Old Backup.zip
# The shell sent must accomplish the following tasks:
# 1. Check if the Documents directory exists. If it does not the script should create it with read, write and execute permissions for the owner and group, and read and execute permissions for others.
# 2. Recursively move all files with a .csv extension from the Data directory and its subdirectories to the Documents directory while preserving the nested directory structure
# 3. Change the permissions of the Documents directory to read and write for the owner, read-only for the group, and read-only for others
# 4. Compress the Documents directory (excluding subdirectories) into a tal archive named archive.tar.gz for easy backup using the car command
# 5. Print the number of files in the Documents directory, excluding subdirectories, to keep track of the file count.
# 6. Check if there are any files in the Documents directory older than 30 days. If there are print their names and move them to the Backup directory preserving the nested directory structure. Ensure that the script uses the find command to locate the files
# 7. After completing these tasks, create a log file named script log in the root directory and append a timestamp along with a success message to it. Ensure that the script uses I/O redirection to append the output to the log te


#!/bin/bash
if [ ! -d "Documents" ]; then
    mkdir Documents
    chmod 775 Documents
fi
find Data -type f -name "*.csv" -exec mv --parents {} Documents/ \;
chmod 640 -R Documents
tar -czvf archive.tar.gz --exclude="*/" Documents/
count=$(find Documents -type f -not -path '*/\.*' | wc -l)
echo "Total files in the Documents directory: $count"
find Documents -type f -mtime +30 -print0 | while IFS= read -r -d '' file; do
    mv --parents "$file" Backup/
    echo "Moved file: $file to Backup/"
done
echo "$(date): Script executed successfully." >> /script.log
