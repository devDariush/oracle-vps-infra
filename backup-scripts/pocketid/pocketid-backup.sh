#!/bin/bash
set -e

echo "attempting pocketid backup..."

podman exec pocketid ./pocket-id export --path  /pocketid-backups/pocketid-backup.zip

echo "pocketid backup successful! ^^'"