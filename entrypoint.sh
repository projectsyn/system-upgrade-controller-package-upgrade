#!/bin/sh

set -e

__script_version="VERSION"

log() {
  echo "$(date -u +"%Y-%m-%d %H:%M:%S UTC") [${1}] - ${2}" 
}

log info "Package upgrade entrypoint ${__script_version}"

log info "Copy upgrade script to host filesystem"
cp /update-packages.sh /host/tmp/update-packages.sh

log info "Executing package update script in chroot"
chroot /host /tmp/update-packages.sh
