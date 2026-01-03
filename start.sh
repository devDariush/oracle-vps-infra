#!/bin/bash
set -e

systemctl --user start caddy.service
systemctl --user start kuma.service
systemctl --user start pocketid.service
systemctl --user start tuwunel.service

echo "Containers successfully started! ^^'"