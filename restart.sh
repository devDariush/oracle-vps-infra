#!/bin/bash
set -e

systemctl --user restart caddy.service
systemctl --user restart kuma.service
systemctl --user restart pocketid.service
systemctl --user restart tuwunel.service

echo "Containers successfully restarted! ^^'"