#!/bin/bash
set -e

systemctl --user enable caddy
systemctl --user enable kuma
systemctl --user enable pocketid
systemctl --user enable tuwunel

echo "Containers successfully enabled! ^^'"