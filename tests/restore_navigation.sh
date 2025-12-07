#!/bin/bash
# Test: initial restore navigation and logging
# Usage: restore_navigation.sh /path/to/restore.sh

set -e

restore_script="$1"
if [ -z "$restore_script" ]; then
  restore_script="../restore.sh"
fi

test_dir="/tmp/test_restore_src"
backup_dir="/tmp/test_restore_bak"

rm -rf "$test_dir" "$backup_dir"
mkdir -p "$test_dir" "$backup_dir"

echo "file1" > "$test_dir/file1.txt"

# Simulate 3 backups
mkdir -p "$backup_dir/2025-10-03-10-00-00" "$backup_dir/2025-10-03-10-01-00" "$backup_dir/2025-10-03-10-02-00"
echo "file1" > "$backup_dir/2025-10-03-10-00-00/file1.txt"
echo "file1_mod" > "$backup_dir/2025-10-03-10-01-00/file1.txt"
echo "file1_mod2" > "$backup_dir/2025-10-03-10-02-00/file1.txt"

# Set source to match 2nd backup
cp "$backup_dir/2025-10-03-10-01-00/file1.txt" "$test_dir/file1.txt"

# Use expect to automate restore.sh navigation
expect <<EOF
spawn bash $restore_script "$test_dir" "$backup_dir"
expect "Choose an option:"
send "1\r"
expect "Restored to a previous version : 2025-10-03-10-00-00"
send "2\r"
expect "Restored to a next version : 2025-10-03-10-01-00"
send "2\r"
expect "Restored to a next version : 2025-10-03-10-02-00"
send "2\r"
expect "No newer backup available to restore."
send "1\r"
expect "Restored to a previous version : 2025-10-03-10-01-00"
send "1\r"
expect "Restored to a previous version : 2025-10-03-10-00-00"
send "1\r"
expect "No older backup available to restore."
send "3\r"
expect eof
EOF

echo "Restore navigation test passed."
