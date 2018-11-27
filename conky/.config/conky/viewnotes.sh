#!/bin/bash

awk '/TODO/ {print} /INPROGRESS/ {print}' "$HOME/org/TODO.org" | sed "s/TODO //g" | sed "s/* INPROGRESS/->/g"
