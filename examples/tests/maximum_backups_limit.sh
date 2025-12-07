#!/bin/bash

# Setup
chmod +x ./backupd.sh
TEST_BASE_DIR="./backup_test_$(date +%s)"
SOURCE_DIR="$TEST_BASE_DIR/source"
BACKUP_DIR="$TEST_BASE_DIR/backups"
mkdir -p "$SOURCE_DIR" "$BACKUP_DIR"

echo "File 1" > "$SOURCE_DIR/file1.txt"

# Test maximum backups limit
./backupd.sh "$SOURCE_DIR" "$BACKUP_DIR" 2 3 &
PID=$!
sleep 3
for i in {1..5}; do
  echo "Change $i" >> "$SOURCE_DIR/file1.txt"
  sleep 3
  done
backup_count=$(ls -1d "$BACKUP_DIR"/* | wc -l)
kill "$PID"
if [ "$backup_count" -le 3 ]; then
  echo "Test Passed: Maximum Backups Limit"
  echo "SCORE: 4"
else
  echo "Test Failed: Maximum Backups Limit"
  echo "SCORE: 0"
  exit 1
fi

# Teardown
rm -rf "$TEST_BASE_DIR"