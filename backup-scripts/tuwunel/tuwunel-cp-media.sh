#!/bin/bash
set -e

# Source and Destination
SOURCE="/mnt/data/infra/tuwunel/media"
DEST="/mnt/data/backup-dump/tuwunel-media"

echo "attempting to copy items in media/ directory from $SOURCE to $DEST..."

mkdir -p "$DEST"

# Copy files (Overwriting old ones)
# We use copy (-cp) instead of symlink (-ln) to avoid boot race conditions
cp -r "$SOURCE"/* "$DEST"/

echo "media backup successful! ^^'"