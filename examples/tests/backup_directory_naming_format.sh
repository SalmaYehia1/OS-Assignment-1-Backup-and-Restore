#!/bin/bash

# Setup
chmod +x ./backupd.sh
TEST_BASE_DIR="./backup_test_$(date +%s)"
SOURCE_DIR="$TEST_BASE_DIR/source"
BACKUP_DIR="$TEST_BASE_DIR/backups"
mkdir -p "$SOURCE_DIR" "$BACKUP_DIR"

echo "File 1" > "$SOURCE_DIR/file1.txt"
echo "File 2" > "$SOURCE_DIR/file2.txt"

# Start the backup script in the background
./backupd.sh "$SOURCE_DIR" "$BACKUP_DIR" 5 3 &
PID=$!

# Allow the script to run for a short duration
sleep 10

# Kill the backup script
kill "$PID"
wait "$PID" 2>/dev/null

# Test backup directory naming format
backup_name=$(ls -1d "$BACKUP_DIR"/* | head -1 | xargs basename)
if [[ "$backup_name" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "Test Passed: Backup Directory Naming Format"
  echo "SCORE: 1"
else
  echo "Test Failed: Backup Directory Naming Format"
  echo "SCORE: 0"
  exit 1
fi

# Teardown
rm -rf "$TEST_BASE_DIR"