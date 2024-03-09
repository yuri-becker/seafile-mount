#!/bin/bash
set -e
./scripts/write-config.sh
mkdir -p /seafile/files || true

if [[ ${SEAFILE_MOUNT_ALLOW_OTHER} = "yes" ]]; then
  seadrive -c seadrive.conf -f -o allow_other -d /seafile/data /seafile/files
else
  seadrive -c seadrive.conf -f -o allow_root -d /seafile/data /seafile/files
fi

