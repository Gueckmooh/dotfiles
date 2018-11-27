#!/bin/bash

cava -p "$HOME/.config/cava/raw" &
conky -c "$HOME/.config/conky/cava" -d
conky -c "$HOME/.config/conky/notes" -d
conky -d
