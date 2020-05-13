#!/bin/bash

set -e -u

export DEBIAN_FRONTEND=noninteractive
__reboot=${REBOOT:-"true"}
__script_version="0.0.1"
prometheus_push_gateway="${1:-}"

log() {
  echo "$(date -u +"%Y-%m-%d %H:%M:%S UTC") [${1}] SUC - ${2}"
}

list_packages_deb() {
  log info "Listing updated packages and reporting back"
  python3 "$(pwd)/update_exporter_deb.py" "$prometheus_push_gateway"
}

apt_get_upgrade() {
  log info "Doing package upgrade"
  if ! apt-get -qy dist-upgrade --auto-remove --purge; then
    log error "Package upgrade failed"
    exit 1
  fi

  log info "Package upgrade finished"
}

check_do_reboot() {
  # Check if reboot hint exists
  if [ -f /var/run/reboot-required ]; then
    log info "File /var/run/reboot-required exists"

    # Do not reboot when set asked to not reboot
    if [ "${__reboot}" = "false" ]; then
      log info "Skipping reboot as requested"
      return
    fi

    # Now do the reboot
    log info "Rebooting now"
    systemctl --message="Package upgrades need reboot" reboot
    exit 0
  fi
  log info "No reboot needed"
}

log info "Package upgrade version ${__script_version}"

log info "Getting Linux distribution info based on /etc/os-release"
if [ -f /etc/os-release ]; then
  # shellcheck disable=SC1091
  . /etc/os-release
else
  log fatal "/etc/os-release missing!"
  exit 1
fi

case "${ID}" in
  ubuntu)
    log info "Detected Ubuntu ${VERSION}"
    apt_get_upgrade
    list_packages
    check_do_reboot
    ;;
  *)
    log fatal "${ID} is not supported by this script"
    exit 1
    ;;
esac

