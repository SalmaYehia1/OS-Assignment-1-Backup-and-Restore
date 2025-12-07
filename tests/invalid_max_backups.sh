#!/bin/bash

# Setup
chmod +x ./backupd.sh
TEST_BASE_DIR="./backup_test_$(date +%s)"
SOURCE_DIR="$TEST_BASE_DIR/source"
BACKUP_DIR="$TEST_BASE_DIR/backups"
mkdir -p "$SOURCE_DIR" "$BACKUP_DIR"

# Test with invalid max_backups (non-integer)
./backupd.sh "$SOURCE_DIR" "$BACKUP_DIR" 5 "xyz"
if [ $? -ne 0 ]; then
  echo "Test Passed: Invalid Max Backups (non-integer)"
else
  echo "Test Failed: Invalid Max Backups (non-integer)"
  exit 1
fi

# Teardown
rm -rf "$TEST_BASE_DIR"