#!/bin/bash
set -e

echo "attempting pocketid backup..."

podman exec pocketid ./pocket-id export --path /tmp/pocketid-backup.zip
podman cp pocketid:/tmp/pocketid-backup.zip /mnt/data/backup-dump/pocketid/pocketid-backup.zip
podman exec pocketid rm /tmp/pocketid-backup.zip

echo "pocketid backup successful! ^^'"