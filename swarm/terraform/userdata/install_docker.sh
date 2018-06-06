#!/bin/bash

apt-get remove  -y docker docker-engine docker.io

apt-get update

apt-get install -y \
        jq \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common \
        nfs-common

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install -y docker-ce

groupadd docker
usermod -aG docker admin

systemctl enable docker

