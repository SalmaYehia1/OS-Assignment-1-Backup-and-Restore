#!/bin/bash
# Test: restore.sh restores the correct content from backup
set -e

restore_script="$1"
if [ -z "$restore_script" ]; then
  restore_script="../restore.sh"
fi

test_dir="/tmp/test_restore_content_src"
backup_dir="/tmp/test_restore_content_bak"

rm -rf "$test_dir" "$backup_dir"
mkdir -p "$test_dir" "$backup_dir"

echo "original" > "$test_dir/file.txt"

# Create two backups with different content
mkdir -p "$backup_dir/2025-10-03-10-00-00" "$backup_dir/2025-10-03-10-01-00"
echo "original" > "$backup_dir/2025-10-03-10-00-00/file.txt"
echo "changed" > "$backup_dir/2025-10-03-10-01-00/file.txt"

# Set source to match the second backup
cp "$backup_dir/2025-10-03-10-01-00/file.txt" "$test_dir/file.txt"

# Restore to previous version (should restore 'original')
printf "1\n3\n" | bash "$restore_script" "$test_dir" "$backup_dir" > /dev/null

if grep -q '^original$' "$test_dir/file.txt"; then
  echo "Restore content verification test passed."
else
  echo "Restore content verification test failed."
  exit 1
fi
