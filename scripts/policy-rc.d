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
      # prohibit docker/containerd stops or restarts
      docker|containerd)
        echo "*** System restart required for ${service} upgrade ***" >> /var/run/reboot-required
        exit 101
        ;;
    esac
    ;;
esac

# Allow actions other than stop/restart
exit 0
