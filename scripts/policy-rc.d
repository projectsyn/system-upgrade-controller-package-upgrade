#!/bin/bash
#
# Intended to be used as /usr/sbin/policy-rc.d on Debian and derivatives
# Prohibits restarts of Docker and containerd services during package upgrades
#

readonly service="$1"
readonly action="$2"

case "$action" in
  stop|restart)
    case "$service" in
      # prohibit docker/containerd stops or restarts.
      #
      # For packages which use deb-systemd-invoke, the full systemd unit name
      # (including the service suffix) is passed to this script as the value
      # for $service. Therefore we match on any value for service which
      # *starts with* docker or containerd.
      docker*|containerd*)
        echo "*** System restart required for ${service} upgrade ***" >> /var/run/reboot-required
        exit 101
        ;;
    esac
    ;;
esac

# Allow actions other than stop/restart
exit 0
