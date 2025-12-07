#!/bin/bash

SRC_DIR="/home/salmay/Desktop/compu/TERMS/term7/OS/LABS/lab1/SRC_TRIAL_CRON"
BACKUP_DIR="/home/salmay/Desktop/compu/TERMS/term7/OS/LABS/lab1/BACKUP_TRIAL_CRON"
MAX_BACKUPS=5

mkdir -p "$BACKUP_DIR"

STATE_FILE="$BACKUP_DIR/directory-info-cron.last"

if [ ! -f "$STATE_FILE" ]; then
    BACKUP_NAME="$(date +%Y-%m-%d-%H-%M-%S)"
    cp -r "$SRC_DIR/" "$BACKUP_DIR/$BACKUP_NAME/"
    ls -lR "$SRC_DIR" > "$STATE_FILE"
    exit 0
fi

ls -lR "$SRC_DIR" > "$BACKUP_DIR/directory-info-cron.new"

if ! diff "$STATE_FILE" "$BACKUP_DIR/directory-info-cron.new" > /dev/null; then
    BACKUP_NAME="$(date +%Y-%m-%d-%H-%M-%S)"
    cp -r "$SRC_DIR/" "$BACKUP_DIR/$BACKUP_NAME/"
    mv "$BACKUP_DIR/directory-info-cron.new" "$STATE_FILE"

    backups=($(ls -dt "$BACKUP_DIR"/*/))  #in order not to count directory-info-cron.last

    if [ "${#backups[@]}" -gt "$MAX_BACKUPS" ]; then
        for old in "${backups[@]:$MAX_BACKUPS}"; do
            rm -rf "$old"
        done
    fi
else
    rm "$BACKUP_DIR/directory-info-cron.new"
fi
