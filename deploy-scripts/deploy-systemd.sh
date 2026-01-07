#!/bin/bash
set -e

# Source and Destination
SOURCE="/mnt/data/infra/systemd"
DEST="$HOME/.config/systemd/user"

echo "deploying timers/systemd services from $SOURCE to $DEST..."

# Ensure destination exists
mkdir -p "$DEST"

# Copy files (Overwriting old ones)
# We use copy (-cp) instead of symlink (-ln) to avoid boot race conditions
cp -r "$SOURCE"/* "$DEST"/

# Reload Systemd to pick up changes
systemctl --user daemon-reload

echo "success! systemd has been reloaded."
