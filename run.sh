#!/bin/sh
set -e

# get the log function
#shellcheck disable=SC1091
. /update-packages.sh

log info "Populating apt package list on host"

rm -rf /host/var/lib/apt/lists/*
cp -r /var/lib/apt/lists/* /host/var/lib/apt/lists

log info "Copy update script to host"

cp /update-packages.sh /host/tmp/update-packages.sh

log info "Chrooting and update"

chroot /host sh /tmp/update-packages.sh
