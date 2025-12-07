#!/bin/bash

# Setup
TEST_BASE_DIR="./backup_test_$(date +%s)"
SOURCE_DIR="$TEST_BASE_DIR/source"
BACKUP_DIR="$TEST_BASE_DIR/backups"
mkdir -p "$SOURCE_DIR" "$BACKUP_DIR"

echo "File 1" > "$SOURCE_DIR/file1.txt"
echo "File 2" > "$SOURCE_DIR/file2.txt"

# Test change detection and automatic backup
./backupd.sh "$SOURCE_DIR" "$BACKUP_DIR" 3 5 &
PID=$!
sleep 4
initial_count=$(ls -1d "$BACKUP_DIR"/* | wc -l)

echo "Modified content" >> "$SOURCE_DIR/file1.txt"
sleep 5
new_count=$(ls -1d "$BACKUP_DIR"/* | wc -l)
kill "$PID"
if [ "$new_count" -gt "$initial_count" ]; then
  echo "Test Passed: Change Detection and Automatic Backup"
  echo "SCORE: 3"
else
  echo "Test Failed: Change Detection and Automatic Backup"
  echo "SCORE: 0"
  exit 1
fi

# Teardown
rm -rf "$TEST_BASE_DIR"