#!/bin/bash
set -e

systemctl --user enable caddy
systemctl --user enable kuma
systemctl --user enable pocketid
systemctl --user enable tuwunel
systemctl --user enable restic-backup.timer
systemctl --user enable restic-backup

echo "Containers/timers/services successfully enabled! ^^'"