#!/bin/bash
#
#

if [[ $EUID -ne 0 ]]; then

    echo
    echo "You must be root to run this script."
    echo
    exit 1

fi

BASE_NAME=$(basename "$0")
BASE_DIR=$(dirname "$0")
PWD_DIR=$(pwd)

if [ "$BASE_DIR" != "." ]; then

    echo
    echo "Run this script from within the install directory."
    echo 
    echo "E.g. ./$BASE_NAME"
    echo

    exit 1
fi

systemctl stop custom-battery-management
systemctl disable custom-battery-management

rm -f /etc/systemd/system/custom-battery-management.service

systemctl daemon-reload

#
# Delete geenrated files and log files.
#
rm -f battery
rm -f battery.c
rm -f custom-battery-management.service
rm -f battery.err.log
rm -f battery.out.log


