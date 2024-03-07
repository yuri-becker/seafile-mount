#!/bin/bash
assert_env_exists() {
  if [[ -z ${!1} ]]; then
    echo "Please set $1 as an environment variable. Aborting." 1>&2
    exit 1
  fi
}

get_or_default() {
  if [[ -n ${!1} ]]; then
    echo "${!1}"
  else
    echo "$2"
  fi
}

assert_env_exists SEAFILE_MOUNT_SERVER
assert_env_exists SEAFILE_MOUNT_USERNAME
assert_env_exists SEAFILE_MOUNT_TOKEN

touch seadrive.conf
{
  echo "[account]"``
  echo "server = ${SEAFILE_MOUNT_SERVER}"
  echo "username = ${SEAFILE_MOUNT_USERNAME}"
  echo "token = ${SEAFILE_MOUNT_TOKEN}"
  echo "is_pro = $(get_or_default SEAFILE_MOUNT_IS_PRO "false")"
  echo ""
  echo "[general]"
  echo "client_name = $(get_or_default SEAFILE_MOUNT_CLIENT_NAME "Seafile Docker Mount")"
  echo ""
  echo "[cache]"
  echo "size_limit = $(get_or_default SEAFILE_MOUNT_CACHE_SIZE_LIMIT "10GB")"
  echo "clean_cache_interval = $(get_or_default SEAFILE_MOUNT_CLEAN_CACHE_INTERVAL "10")"
} >> seadrive.conf