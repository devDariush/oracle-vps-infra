#!/bin/bash
set -e

echo "attempting to trigger database backup internally..."

systemctl --user kill --signal=SIGUSR2 tuwunel.service

echo "tuwunel database backup successfull! ^^'"