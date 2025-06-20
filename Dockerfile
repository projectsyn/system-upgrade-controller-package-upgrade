ARG ubuntu_version=18.04

FROM docker.io/ubuntu:$ubuntu_version AS builder

SHELL ["/bin/bash", "-c"]

COPY scripts/ /scripts

RUN apt-get update && apt-get install -y python3 python3-venv python3-pip && \
    cd /scripts && \
    python3 -m venv .venv && source .venv/bin/activate && \
    pip3 install prometheus_client

FROM docker.io/ubuntu:$ubuntu_version

COPY --from=builder /scripts/ /scripts

RUN apt-get update && apt-get install -y curl software-properties-common dnsutils && \
    add-apt-repository universe && \
    add-apt-repository multiverse && \
    add-apt-repository restricted && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    # Official docker repos for focal aren't available yet...
    [ "$(lsb_release -cs)" != "bionic" ] || add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable" && \
    apt-get update
