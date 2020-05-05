ARG ubuntu_version=18.04
FROM docker.io/ubuntu:$ubuntu_version

RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    add-apt-repository multiverse && \
    add-apt-repository restricted && \
    apt-get update

COPY run.sh /run.sh
COPY update-packages.sh /update-packages.sh
