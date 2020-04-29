#!/bin/bash

PID=$(pgrep goautolock)
if test "$?" -eq 0 
then
	kill -s SIGUSR1 "$PID"
fi
