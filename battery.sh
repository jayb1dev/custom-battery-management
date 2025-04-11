#!/bin/bash
#
#

#
# Set these as you prefer.
#
LOW_CRITICAL=15
LOW=20
HIGH=90
HIGH_CRITICAL=95

#
# Enable sound
# Set this to "yes" or "no"
#
ENABLE_SOUND=yes

#
# Enable checking for a VPN. 
#
# If a vpn is running which would prevent communication with
# the smart plug, this will stop the vpn before attempting power 
# operations on the smart plug on your local LAN.
#
# If you do not have a vpn running, set this to "no"
#
ENABLE_VPN_CHECK=yes

#
# Path to sounds that can be played with pw-play
#
SOUND_PLUG=/usr/share/sounds/Yaru/stereo/power-plug.oga
SOUND_UNPLUG=/usr/share/sounds/Yaru/stereo/power-unplug.oga

#
# This is required to play sound with pw-play when running as
# a systemd service.
#
# Find this by running as your logged in user: 
# printenv | grep XDG_RUNTIME_DIR
#
export XDG_RUNTIME_DIR=/run/user/1000

#
# Play sound.
#
sound() {
    if [ "$ENABLE_SOUND" == "yes" ]; then
        pw-play $1
        pw-play $1
        pw-play $1
    fi
}

#
# Power on or power off
#
power() {

    if [ "$ENABLE_VPN_CHECK" == "yes" ]; then

        #
        # Get vpn pid and check if we need to stop the vpn.
        #
        vpn_pid=$(ps -ef | grep vpnagentd | grep -v grep | awk '{print $2}')

        if [ "$vpn_pid" != "" ]; then
            echo "Stopping vpn $vpn_pid ..."
            kill -KILL $vpn_pid
        fi

    fi

    if [ "$1" == "on" ]; then
        echo "Power on."
    fi

    if [ "$1" == "off" ]; then
        echo "Power off."
    fi
}

while [ 1 ]; do

    #
    # Default time to sleep between battery checks.
    #
    sleep_time=60

    date=$(date)
    percent=$(tlp-stat -b | grep ^Charge | awk '{print $3}' | cut -d '.' -f 1)

    #
    # Get status.
    #
    # This will be one of: 
    #   "Charging" 
    #   "Discharging"
    #   "Full"
    #
    status=$(sudo tlp-stat -b | grep /sys/class/power_supply/BAT0/status | awk '{print $3}' )


    #
    # Log date, status, percentage...
    #
    echo "[$date] ($status) Battery percent: $percent"

    if [ "$percent" == "100" ]; then
        #
        # Don't just keep beeping?
        # Not much else we can do here. 
        #
        echo "Battery full."
        sleep $sleep_time
        continue
    fi

    if [ "$percent" -lt "$LOW" -a "$status" != "Charging" ]; then
        echo "Battery low."
        sound $SOUND_PLUG
        sleep_time=20
    fi

    if [ "$percent" -lt "$LOW_CRITICAL" -a "$status" != "Charging" ]; then
        echo "Battery low critical."

        #
        # Begin charging (power on plug)
        #
    fi

    if [ "$percent" -gt "$HIGH" -a "$status" != "Discharging" ]; then
        echo "Battery high."
        sound $SOUND_UNPLUG
        sleep_time=20
    fi

    if [ "$percent" -gt "$HIGH_CRITICAL" -a "$status" != "Discharging" ]; then
        echo "Battery high critical."

        #
        # Stop charging (power off plug)
        #
    fi

    sleep $sleep_time

done

