#!/usr/bin/env bash

# For Cape and other Thinkpads
xinput set-prop "TPPS/2 IBM TrackPoint" "libinput Accel Speed" -0.4

set -x
screens=$(xrandr|egrep '^e?DP-(.+) connected'|wc -l)
if [ $screens -gt 2 ]; then
  ${HOME}/.screenlayout/alternate.sh
else
  ${HOME}/.screenlayout/default.sh
fi
