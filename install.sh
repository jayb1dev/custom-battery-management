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

#
# Escape slashes in dir name
#
ESCAPED_PWD_DIR=$(echo $PWD_DIR | sed 's/\//\\\//g')

#
# Replace template values
#
TEMPLATE_FILES="battery.c custom-battery-management.service"

for TEMPLATE_FILE in $TEMPLATE_FILES; do

    cat ${TEMPLATE_FILE}.template | \
        sed "s/__BASE_DIR__/${ESCAPED_PWD_DIR}/g" > $TEMPLATE_FILE

done

#
# Debug
#
# cat battery.c
# cat custom-battery-management.service

gcc battery.c -o battery
chmod u+s battery

cp custom-battery-management.service /etc/systemd/system

systemctl daemon-reload
systemctl enable custom-battery-management

systemctl stop custom-battery-management
systemctl start custom-battery-management

systemctl status --no-pager custom-battery-management


