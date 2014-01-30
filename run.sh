#!/bin/bash

RUNNING=$(pgrep tabletShortcuts -c)
echo $RUNNING
cd $(dirname $BASH_SOURCE)

if [[ $RUNNING -eq 1 ]]; then
dbus-send --dest=sevanteri.TabletShortcuts --type=method_call /app sevanteri.TabletShortcuts.hideshow    
else
./tabletShortcuts.py&
fi