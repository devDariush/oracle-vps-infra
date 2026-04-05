#!/bin/bash
set -e

systemctl --user restart caddy.service
systemctl --user restart kuma.service
systemctl --user restart pocketid.service
systemctl --user restart tuwunel.service
systemctl --user restart postgres.service
systemctl --user restart gotosocial.service

echo "Containers successfully restarted! ^^'"
