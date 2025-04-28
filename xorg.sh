#!/bin/bash

sudo Xorg -noreset -config $(pwd)/xorg.conf :99 &
export DISPLAY=:99
icewm-session &

x11vnc -display :99 -nopw -listen localhost -xkb &
