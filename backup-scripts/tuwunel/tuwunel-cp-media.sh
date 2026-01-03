#!/bin/bash
set -e

# Source and Destination
SOURCE="/mnt/data/infra/tuwunel/media"
DEST="/mnt/data/backup-dumps/tuwunel-media"

echo "attempting to copy items in media/ directory from $SOURCE to $DEST..."

# Delete and remake media dump folder (fresh backup)
rm -rf "$DEST"
mkdir "$DEST"

# Copy files (Overwriting old ones)
# We use copy (-cp) instead of symlink (-ln) to avoid boot race conditions
cp -r "$SOURCE"/* "$DEST"/

echo "media backup successful! ^^'"