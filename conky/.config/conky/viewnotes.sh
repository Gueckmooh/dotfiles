#!/bin/bash

awk '/^[*]+[[:space:]]+TODO/ {print} /^[*]+[[:space:]]+INPROGRESS/ {print}' "$HOME/org/TODO.org" | sed "s/TODO //g" | sed "s/* INPROGRESS/->/g"
