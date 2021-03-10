#!/bin/bash
set -e

# get the log function
#shellcheck disable=SC1091
. /scripts/functions.sh

log info "Populating apt package list on host"

rm -rf /host/var/lib/apt/lists/*
cp -r /var/lib/apt/lists/* /host/var/lib/apt/lists

cp /etc/apt/sources.list /host/etc/apt/sources.list

while getopts "u" opt; do
    case "${opt}" in
        u)
            aptupdate=1
            ;;
        *)
            echo "Usage $0 [-u] [PUSHGATEWAY]"
            ;;
    esac
done
shift $((OPTIND -1))

log info "Get IP address of the push gateway"

host=$(echo "$1" | cut -d ':' -f 1)
port=$(echo "$1" | cut -d ':' -f 2 -s)
[ -n "$1" ] && pgw=$(dig +short "$host" | tail -1)
# If it's still empty it was either:
# empty to begin with
# an IP address
# not resolvable
# either way, setting pgw to the original value should be okay
[ -n "$pgw" ] && pgw="$pgw:$port"
[ -z "$pgw" ] && pgw="$1"

log info "Found: $pgw"

# Don't do apt-get update during maintenance window by default
[ -z "$aptupdate" ] && aptupdate=0

if [ "$aptupdate" -eq 1 ]; then
    log info "User requested apt-get update during maintenance window"
fi

log info "Copy update script to host"

cp -r /scripts/. /host/tmp/

log info "Chrooting and update"

chroot /host bash /tmp/update-packages.sh "$pgw" "$aptupdate"
