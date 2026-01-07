#!/bin/bash
set -e

DIR="./deploy-scripts"

bash $DIR/deploy-systemd.sh
bash $DIR/deploy-quadlets.sh