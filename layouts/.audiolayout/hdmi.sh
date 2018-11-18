#!/bin/bash

pacmd set-default-sink alsa_output.pci-0000_00_03.0.hdmi-stereo-extra1
sink_index=$(pacmd list-sinks | grep -e '* index:')
sink_index=${sink_index##* }
inputs_index=$(pacmd list-sink-inputs | grep -e 'index:')
for idx in $inputs_index
do
    if [ "$idx" != "index:" ]
    then
	pacmd move-sink-input $idx $sink_index
    fi
done
