#!/bin/bash

# Setup
chmod +x ./backupd.sh
TEST_BASE_DIR="./backup_test_$(date +%s)"
BACKUP_DIR="$TEST_BASE_DIR/backups"
mkdir -p "$BACKUP_DIR"

# Test with non-existent source directory
./backupd.sh "/nonexistent/dir" "$BACKUP_DIR" 5 3
if [ $? -ne 0 ]; then
  echo "Test Passed: Non-existent Source"
else
  echo "Test Failed: Non-existent Source"
  exit 1
fi

# Teardown
rm -rf "$TEST_BASE_DIR"