#!/bin/bash

set -e -u

export DEBIAN_FRONTEND=noninteractive
__reboot=${REBOOT:-"true"}
__script_version="0.0.1"
prometheus_push_gateway="${1:-}"

#shellcheck disable=SC1090
. "$(dirname "$0")/functions.sh"

list_packages_deb() {
  log info "Listing updated packages and reporting back"
  log info "Push gateway: $prometheus_push_gateway"
  cd "$(dirname "$0")"
  # shellcheck disable=SC1091
  . .venv/bin/activate
  # We want to ignore error return codes from `update_exporter_deb.py` since
  # failing to push an update to Prometheus shouldn't fail the maintenance for
  # a node.
  .venv/bin/python3 "./update_exporter_deb.py" "$prometheus_push_gateway" || true
}

install_policy_rc_d() {
  log info "Installing /usr/sbin/policy-rc.d"
  cp "$(dirname "$0")/policy-rc.d" /usr/sbin/policy-rc.d
}

apt_get_update() {
  log info "Updating package lists"
  if ! apt-get update; then
    log error "Updating package lists failed"
    exit 1
  fi

  log info "Package lists updated"
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
    install_policy_rc_d
    if [ "$2" -eq 1 ]; then
      apt_get_update
    fi
    apt_get_upgrade
    list_packages_deb
    check_do_reboot
    ;;
  *)
    log fatal "${ID} is not supported by this script"
    exit 1
    ;;
esac

