#!/bin/bash
set -e

systemctl --user stop caddy.service
systemctl --user stop kuma.service
systemctl --user stop pocketid.service
systemctl --user stop tuwunel.service
systemctl --user stop postgres.service
systemctl --user stop gotosocial.service

echo "Containers successfully stopped! ^^'"
