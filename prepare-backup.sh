#!/bin/bash
set -e

BACKUP_SCRIPTS_DIR=/mnt/data/infra/backup-scripts

echo "Attempting full backup..."

# Tuwunel
echo "---tuwunel---"
bash $BACKUP_SCRIPTS_DIR/tuwunel/tuwunel-db-backup.sh
bash $BACKUP_SCRIPTS_DIR/tuwunel/tuwunel-cp-media.sh

# Pocket ID
echo "---pocketid---"
bash $BACKUP_SCRIPTS_DIR/pocketid/pocketid-backup.sh

echo "Full backup successful! ^^'"