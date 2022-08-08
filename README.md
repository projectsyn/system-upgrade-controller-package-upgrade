# Project Syn: System Upgrade Controller OS Package Upgrade Script

Script for running OS upgrades. Companion to [System Upgrade Controller](https://github.com/rancher/system-upgrade-controller/).

Also contains a sample Grafana Dashboard and some bootstrapping scripts to setup a k3s cluster and a plan to invoke for Ubuntu.

The Grafana folder contains an example dashboard for SUC monitoring. Requires a working Prometheus/Grafana setup.

testing contains some scripts and test objects useful for development and, you guessed it, testing.

## Usage

```bash
/scripts/run.sh [-u] [-s] [pushgateway_url]
```

Arguments:
* `-p`: Don't run `apt-get update` during maintenance window, but use cached package lists from Docker image.
* `-s`: Don't override the sources.list on the host with the one from the docker image.
* `pushgateway_url`: URL of Prometheus pushgateway. Used to push detailed upgrade job metrics into Prometheus.

## Docker images

Images are avaiable on DockerHub for

* [Ubuntu Bionic](https://hub.docker.com/r/projectsyn/suc-ubuntu-bionic)
* [Ubuntu Focal](https://hub.docker.com/r/projectsyn/suc-ubuntu-focal)

* Every Monday, at 9:00 UTC new images are built and pushed to DockerHub using the date (formatted as `YYYYMMDD`) as the tag.
* On pushes to `master`, images are built and pushed to DockerHub using tag `latest`.

