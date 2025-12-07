#!/bin/bash

dir="$1"
backup_dir="$2"

#checking if no 2 arguments 
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_dir> <backup_dir>"
    exit 1
fi

#checking if either src dir or backupdir not exists 
if [ ! -d "$dir" ] || [ ! -d "$backup_dir" ]; then
    echo "Either source directory or backup directory does not exist."
    exit 1
fi

# sort backups by timestamp by getting all inside backupdir 
backups=("$backup_dir"/*)
backups=($(printf "%s\n" "${backups[@]}" | sort -V))

#get the number of backups in arr and if = 0 exit 
if [ ${#backups[@]} -eq 0 ]; then   
    echo "No backups found in the backup directory."
    exit 1
fi

# Find current backup index
#by looping through indices of backup arr and if not equal hide the differences found 
#but if equal then this is the current 
current_index=-1
for i in "${!backups[@]}"; do
    # Compare all files in backup vs source
    diff -r "${backups[$i]}" "$dir" &>/dev/null
    if [ $? -eq 0 ]; then
        current_index=$i
        break
    fi
done

#if =-1 so , not found 
if [ "$current_index" -eq -1 ]; then
    echo "No matching backup found for current state."
    exit 1
fi

while true; do
    echo ""
    echo "Choose an option:"
    echo "1 - Restore to previous version"
    echo "2 - Restore to next version"
    echo "3 - Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            if [ $current_index -le 0 ]; then
                echo "No older backup available to restore."
            else
                ((current_index--))
                rsync -a --delete "${backups[$current_index]}/" "$dir/"
                echo "Restored to a previous version : $(basename "${backups[$current_index]}")"
            fi
            ;;
        2)
            if [ $current_index -ge $((${#backups[@]} - 1)) ]; then
                echo "No newer backup available to restore."
            else
                ((current_index++))
                rsync -a --delete "${backups[$current_index]}/" "$dir/"
                echo "Restored to a next version : $(basename "${backups[$current_index]}")"
            fi
            ;;
        3)
            echo "Exiting restore script."
            break
            ;;
        *)
            echo "Invalid choice. Please enter 1, 2, or 3."
            ;;
    esac
done
