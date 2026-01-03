#!/bin/bash
set -e

systemctl --user stop caddy.service
systemctl --user stop kuma.service
systemctl --user stop pocketid.service
systemctl --user stop tuwunel.service

echo "Containers successfully stopped! ^^'"