#!/bin/bash
# Test: restore.sh handles no matching backup for current state
set -e

restore_script="$1"
if [ -z "$restore_script" ]; then
  restore_script="../restore.sh"
fi

test_dir="/tmp/test_restore_src2"
backup_dir="/tmp/test_restore_bak2"

rm -rf "$test_dir" "$backup_dir"
mkdir -p "$test_dir" "$backup_dir"

echo "file1" > "$test_dir/file1.txt"

# Simulate 1 backup with different content
mkdir -p "$backup_dir/2025-10-03-10-00-00"
echo "DIFFERENT" > "$backup_dir/2025-10-03-10-00-00/file1.txt"

output=$(bash $restore_script "$test_dir" "$backup_dir" 2>&1 || true)
if [[ "$output" == *"No matching backup found for current state"* ]]; then
  echo "No matching backup test passed."
else
  echo "No matching backup test failed."
  exit 1
fi
