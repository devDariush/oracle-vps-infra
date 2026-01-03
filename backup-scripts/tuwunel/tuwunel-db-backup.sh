#!/bin/bash
set -e

DEST="/mnt/data/backup-dumps/tuwunel-nomedia"

echo "attempting to trigger database backup internally..."

rm -rf "$DEST"

systemctl --user kill --signal=SIGUSR2 tuwunel.service

echo "tuwunel database backup successfull! ^^'"