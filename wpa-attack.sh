#!/bin/bash

## CONSTANTS - Change if applicable ##
interfaceName="wlan0"

# Check for permissions
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

airmon-ng start $interfaceName

airmon-ng check kill

monInterfaceName=$interfaceName"mon"

airodump-ng $monInterfaceName
