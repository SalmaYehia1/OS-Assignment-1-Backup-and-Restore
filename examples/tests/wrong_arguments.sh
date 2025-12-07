#!/bin/bash

# Setup
chmod +x ./backupd.sh
TEST_BASE_DIR="./backup_test_$(date +%s)"
SOURCE_DIR="$TEST_BASE_DIR/source"
BACKUP_DIR="$TEST_BASE_DIR/backups"
mkdir -p "$SOURCE_DIR" "$BACKUP_DIR"

# Test with wrong number of arguments
./backupd.sh "$SOURCE_DIR" "$BACKUP_DIR"
if [ $? -ne 0 ]; then
  echo "Test Passed: Wrong Arguments"
else
  echo "Test Failed: Wrong Arguments"
  exit 1
fi

# Teardown
rm -rf "$TEST_BASE_DIR"