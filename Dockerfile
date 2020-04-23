ARG ubuntu_version=18.04
FROM ubuntu:$ubuntu_version

RUN apt-get update

ADD run.sh /run.sh
ADD update-packages.sh /update-packages.sh
