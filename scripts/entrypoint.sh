#!/bin/bash
set -e
./scripts/write-config.sh
mkdir -p /seafile/files
seadrive -c seadrive.conf -f -o allow_root -d /seafile/data /seafile/files
