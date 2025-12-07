#!/bin/bash
# Test: restore.sh argument validation
set -e

restore_script="$1"
if [ -z "$restore_script" ]; then
  restore_script="../restore.sh"
fi

output=$(bash $restore_script 2>&1 || true)
if [[ "$output" == *"Usage:"* ]]; then
  echo "Argument count test passed."
else
  echo "Argument count test failed."
  exit 1
fi

output=$(bash $restore_script /notexist /notexist 2>&1 || true)
if [[ "$output" == *"does not exist"* ]]; then
  echo "Nonexistent dir/backupdir test passed."
else
  echo "Nonexistent dir/backupdir test failed."
  exit 1
fi
