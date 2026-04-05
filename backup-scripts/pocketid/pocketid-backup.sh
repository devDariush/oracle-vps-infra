#!/bin/bash
set -e

echo "attempting pocketid backup..."

BACKUP_DIR=/mnt/data/backup-dump/pocketid

podman exec pocketid ./pocket-id export --path /tmp/pocketid-backup.zip
mkdir -p $BACKUP_DIR
podman cp pocketid:/tmp/pocketid-backup.zip $BACKUP_DIR/pocketid-backup.zip
podman exec pocketid rm /tmp/pocketid-backup.zip

echo "pocketid backup successful! ^^'"