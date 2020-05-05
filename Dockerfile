ARG ubuntu_version=18.04
FROM docker.io/ubuntu:$ubuntu_version

RUN apt-get update

COPY run.sh /run.sh
COPY update-packages.sh /update-packages.sh
