#!/bin/sh
set -e

# get the log function
#shellcheck disable=SC1091
. /scripts/update-packages.sh

log info "Populating apt package list on host"

rm -rf /host/var/lib/apt/lists/*
cp -r /var/lib/apt/lists/* /host/var/lib/apt/lists

cp /etc/apt/sources.list /host/etc/apt/sources.list

log info "Copy update script to host"

cp -r /scripts/. /host/tmp/

log info "Chrooting and update"

chroot /host bash /tmp/update-packages.sh "$1"
