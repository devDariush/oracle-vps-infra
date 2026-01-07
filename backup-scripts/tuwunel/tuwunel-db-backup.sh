#!/bin/bash
set -e

echo "attempting to trigger database backup internally..."

DEST="/mnt/data/backup-dumps/tuwunel-db"

mkdir -p "$DEST"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${ENV_FILE:-$SCRIPT_DIR/tuwunel-db-backup.env}"

if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
fi

# Variables
: "${HOMESERVER:=https://matrix.dariush.dev}"
: "${ROOM_ID:?ROOM_ID is required (set it in $ENV_FILE or env)}"
: "${TOKEN:?TOKEN is required (set it in $ENV_FILE or env)}"
: "${MESSAGE:=!admin server backup-database}"

# Send the message
curl -X PUT "$HOMESERVER/_matrix/client/r0/rooms/$ROOM_ID/send/m.room.message/$(date +%s)" \
     -H "Authorization: Bearer $TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "msgtype": "m.text",
       "body": "'"$MESSAGE"'"
     }'

echo "Request sent. Waiting 15s for RocksDB checkpoint..."
sleep 15

cp -r /home/opc/tmp/tuwunel-db-backups/* "$DEST/"

echo "tuwunel database backup successfull! ^^'"