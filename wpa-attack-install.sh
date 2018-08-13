#!/bin/bash

# Check for network connection
/bin/ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && STATUS=1 || STATUS=0
if [[ $STATUS -ne 1 ]]; then
  echo "This script requires network access"
  exit 1
fi

# Check for permissions
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Change to home directory
cd
apt update
apt upgrade

# Install all dependencies
apt install -y openssl libssl-dev opencl-headers zlib1g-dev libpcap0.8-dev libcurl4-openssl-dev

# Clone all necessary repositories
git clone https://github.com/ZerBea/hcxdumptool.git
git clone https://github.com/ZerBea/hcxtools.git
git clone https://github.com/hashcat/hashcat.git

cd hcxtools
make
make install

cd

cd hcxdumptool
make
make install

cd

cd hashcat
make
make install
