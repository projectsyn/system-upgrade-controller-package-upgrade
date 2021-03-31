# Project Syn: System Upgrade Controller OS Package Upgrade Script

Script for running OS upgrades. Companion to [System Upgrade Controller](https://github.com/rancher/system-upgrade-controller/).

Also contains a sample Grafana Dashboard and some bootstrapping scripts to setup a k3s cluster and a plan to invoke for Ubuntu.

The Grafana folder contains an example dashboard for SUC monitoring. Requires a working Prometheus/Grafana setup.

testing contains some scripts and test objects useful for development and, you guessed it, testing.

## Usage

```bash
/scripts/run.sh [-u] [pushgateway_url]
```

Arguments:
* `-u`: Run `apt-get upgrade` during maintenance window, otherwise use cached package lists from Docker image.
* `pushgateway_url`: URL of Prometheus pushgateway. Used to push detailed upgrade job metrics into Prometheus.
