#!/bin/bash

if [[ "$1" == '-r' ]]
then
    killall conky cava
fi


pgrep -u $USER conky -x > /dev/null && exit 0

cava -p "$HOME/.config/cava/raw" &
conky -c "$HOME/.config/conky/cava" -d > /dev/null
conky -c "$HOME/.config/conky/notes" -d > /dev/null
conky -d > /dev/null
