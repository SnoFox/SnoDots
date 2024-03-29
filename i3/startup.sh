#!/usr/bin/env bash

# For Cape and other Thinkpads
xinput set-prop "TPPS/2 IBM TrackPoint" "libinput Accel Speed" -0.4
#xset dpms 0 0 0
xset s off
xset dpms 0 0 300

set -x
screens=$(xrandr|egrep '^e?DP-(.+) connected'|wc -l)
if [ $screens -gt 2 ]; then
  ${HOME}/.screenlayout/docked.sh
else
  ${HOME}/.screenlayout/internal.sh
fi
