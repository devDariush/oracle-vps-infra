#!/bin/bash
set -e

echo "Attempting full backup..."

# Tuwunel
echo "---tuwunel---"
bash ./backup-scripts/tuwunel/tuwunel-db-backup.sh
bash ./backup-scripts/tuwunel/tuwunel-cp-media.sh

echo "Full backup successful! ^^'"