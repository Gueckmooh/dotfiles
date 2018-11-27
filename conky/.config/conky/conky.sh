#!/bin/bash

cava -p "$HOME/.config/cava/raw" &
conky -c "$HOME/.config/conky/cava" -d > /dev/null
conky -c "$HOME/.config/conky/notes" -d > /dev/null
conky -d > /dev/null
