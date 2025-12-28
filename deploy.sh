#!/bin/bash
set -e

# Source and Destination
SOURCE="/mnt/data/infra/quadlets"
DEST="$HOME/.config/containers/systemd"

echo "deploying quadlets from $SOURCE to $DEST..."

# Ensure destination exists
mkdir -p "$DEST"

# Copy files (Overwriting old ones)
# We use copy (-cp) instead of symlink (-ln) to avoid boot race conditions
cp -r "$SOURCE"/* "$DEST"/

# Reload Systemd to pick up changes
systemctl --user daemon-reload

echo "success! systemd has been reloaded."
echo "if you changed configurations, run: systemctl --user restart <service_name>"
