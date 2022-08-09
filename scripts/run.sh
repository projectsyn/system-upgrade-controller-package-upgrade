#!/bin/bash
set -e

# get the log function
#shellcheck disable=SC1091
. /scripts/functions.sh

while getopts "ups" opt; do
    case "${opt}" in
        u)
            log warn "The flag '-u' is deprecated. The script does apt-get update by default. Use -p to use the package lists from the image."
            ;;
        p)
          # Use cached apt package list
            aptupdate=0
            ;;
        s)  sourcelist=1
            ;;
        *)
            echo "Usage $0 [-u] [-s] [PUSHGATEWAY]"
            ;;
    esac
done
shift $((OPTIND -1))

# Do apt-get update during maintenance window by default
[ -z "$aptupdate" ] && aptupdate=1

# Override the host source list with the source list of the docker image
[ -z "$sourcelist" ] && sourcelist=0

rm -rf /host/var/lib/apt/lists/*

if [ "$sourcelist" -eq 0 ]; then
	log info "Populating apt source list on host"
	cp /etc/apt/sources.list /host/etc/apt/sources.list
fi

if [ "$aptupdate" -eq 0 ]; then
	log info "Populating apt package list on host"
	cp -r /var/lib/apt/lists/* /host/var/lib/apt/lists
fi

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

if [ "$aptupdate" -eq 1 ]; then
    log info "User requested apt-get update during maintenance window"
fi

log info "Copy update script to host"

cp -r /scripts/. /host/tmp/

log info "Chrooting and update"

chroot /host bash /tmp/update-packages.sh "$pgw" "$aptupdate"
