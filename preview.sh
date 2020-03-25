#!/bin/bash
#
# Preview the currently installed Plymouth theme
#
set -eu

DURATION="${1:-5}"
COMMAND="${2:-wait}"

plymouthd

function quit {
    plymouth quit
}
trap quit EXIT

plymouth --show-splash

case $COMMAND in
wait)
    sleep $DURATION
    ;;
status)
    for i in $(seq 1 $DURATION); do
        plymouth --update=$(date)
        sleep 1
    done
    ;;
password)
    plymouth --ask-for-password
    sleep $DURATION
    ;;
esac
