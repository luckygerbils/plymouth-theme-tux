#!/bin/bash
#
# Preview the currently installed Plymouth theme
#

DURATION="${1:-5}"

plymouthd
plymouth --show-splash
sleep "$DURATION"
plymouth quit
