ARG ubuntu_version=18.04
FROM docker.io/ubuntu:$ubuntu_version

RUN apt-get update && apt-get install -y curl software-properties-common && \
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

COPY run.sh /run.sh
COPY update-packages.sh /update-packages.sh
