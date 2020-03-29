#!/bin/bash
#
# Preview the currently installed Plymouth theme
#
set -eu

DURATION="${1:-10}"
COMMAND="${2:-wait}"

plymouthd

function quit {
    plymouth quit
}
trap quit EXIT

# Wait for plymouth to actually be available or else we'll end up switching to a
# new TTY without showing plymouth for some reason.
while ! plymouth --ping; do
    sleep 1
done

plymouth show-splash
#plymouth change-mode --shutdown

case $COMMAND in
wait)
    sleep $((DURATION))
    ;;
status)
    for i in $(seq 1 $DURATION); do
        message="$(date) $i"
        echo plymouth update --status="$message"
        plymouth update --status="$message"
        sleep 0.5
    done
    ;;
message)
    for i in $(seq 1 $DURATION); do
        message="$(date) $i"
        echo plymouth display-message --text="$message"
        plymouth display-message --text="$message"
        sleep 0.5
    done
    ;;
progress)
    for i in $(seq 0 $DURATION); do
        percentage=$((100/DURATION*i))
        echo plymouth system-update --progress="$percentage"
        plymouth system-update --progress="$percentage"
        sleep 0.5
    done
    ;;
password)
    sleep 1
    plymouth ask-for-password --prompt=Password: &
    sleep $DURATION
    ;;
esac

echo "EOF"
sleep 1
