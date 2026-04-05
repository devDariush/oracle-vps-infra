#!/bin/bash
# Configuration
set -e
BACKUP_DIR="/mnt/data/backup-dump/gotosocial"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CONTAINER_NAME="postgres"
DB_USER="gotosocial"
DB_NAME="gotosocial"
GTS_STORAGE_DIR="/mnt/data/infra/gotosocial/storage"

mkdir -p $BACKUP_DIR

echo "attempting pocketid backup..."

# 1. Backup the Database
podman exec -t $CONTAINER_NAME pg_dump -U $DB_USER $DB_NAME | gzip > $BACKUP_DIR/gts_db_$TIMESTAMP.sql.gz

# 2. Backup the Media
cp -r $GTS_STORAGE_DIR  $BACKUP_DIR/storage

echo "Backup complete: $BACKUP_DIR"