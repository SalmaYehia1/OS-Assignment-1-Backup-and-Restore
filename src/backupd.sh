#!/bin/bash
dir="$1"
backupdir="$2"
interval_secs="$3"
max_backups="$4"

if [ "$#" -ne 4 ]; then
    exit 1 #ne=not exactly 
fi

if ! [[ "$interval_secs" =~ ^[0-9]+$ ]]; then
    exit 1 # regex valiadation for only numeric
fi

if ! [[ "$max_backups" =~ ^[0-9]+$ ]]; then
    exit 1 # regex valiadation for only numeric
fi

if [ ! -d "$dir" ]; then
    exit 1
fi

# if backup dir not exist make one
mkdir -p "$backupdir"
echo "Backup directory is ready: $backupdir"

# Create first backup if backup directory is empty
if [ -z "$(ls -A "$backupdir" 2>/dev/null)" ]; then
    backup_name="$(date +%Y-%m-%d-%H-%M-%S)"
    cp -r "$dir/" "$backupdir/$backup_name/"
    echo "Backup created at $backupdir with name $backup_name"
fi

# why -p as no error if the dir doesnt exist 
# as -p creates parent folder 
# if already found: it wont recreate it 

ls -lR "$dir" > directory-info.last

while true; do
    sleep "$interval_secs"
    ls -lR "$dir" > directory-info.new
    if ! diff directory-info.last directory-info.new > /dev/null; then
  
        backup_name="$(date +%Y-%m-%d-%H-%M-%S)"
        dest="$backupdir/$backup_name"
        cp -r "$dir/" "$dest/"
        echo "Backup created at $backupdir with name $backup_name"

        mv directory-info.new directory-info.last

        backups=($(ls -dt "$backupdir"/*))
        if [ "${#backups[@]}" -gt "$max_backups" ]; then
            for old in "${backups[@]:$max_backups}"; do
                rm -rf "$old"
            done
        fi
    fi
done
