#!/bin/bash

# Setup
chmod +x ./backupd.sh
TEST_BASE_DIR="./backup_test_$(date +%s)"
SOURCE_DIR="$TEST_BASE_DIR/source"
BACKUP_DIR="$TEST_BASE_DIR/backups"
mkdir -p "$SOURCE_DIR" "$BACKUP_DIR"

echo "File 1" > "$SOURCE_DIR/file1.txt"
echo "File 2" > "$SOURCE_DIR/file2.txt"

# Test initial backup creation
./backupd.sh "$SOURCE_DIR" "$BACKUP_DIR" 5 3 &
DAEMON_PID=$!
sleep 3
backup_count=$(ls -1d "$BACKUP_DIR"/* | wc -l)
if [ "$backup_count" -eq 1 ]; then
  echo "Test Passed: Initial Backup Creation"
  echo "SCORE: 1"
else
  echo "Test Failed: Initial Backup Creation"
  echo "SCORE: 0"
  kill $DAEMON_PID 2>/dev/null
  exit 1
fi

# Kill the daemon before teardown
kill $DAEMON_PID 2>/dev/null
# Teardown
rm -rf "$TEST_BASE_DIR"