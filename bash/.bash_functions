#!/bin/bash

function lb {
    if [[ "$#" == 0 ]]
    then
        v=*
    else
        v=$1
    fi
    du -hsx $v | sort -rh | head -10
}

function e {
    if [[ "$#" != 0 ]]
    then
        emacsclient --alternate-editor '' -c $*
    else
        emacsclient --alternate-editor '' -c .
    fi
}

function macl {
    if [[ "$#" != 0 ]]
    then
        emacsclient --alternate-editor '' -nw $*
    else
        emacsclient --alternate-editor '' -nw .
    fi
}

function awmini {
    awesome-client <<EOF
c = client.focus
c.minimized = true
EOF
}

function pm-bridge {
    tmux ls | grep "mail" && tmux a -t mail || tmux new -d -s mail 'protonmail-bridge --cli'
}

function alias-expand {
    alias "$1" | sed "s/alias [^=]*='\(.*\)'/\1/"
}

function launch-pm-bridge {
    tmux new -s mail -d 'protonmail-bridge --cli'
    tmux new -s offlineimap -d offlineimap
    echo "Ok"
}

function terminate-pm-bridge {
    PID=$(pgrep offlineimap)
    kill $PID
    while pgrep offlineimap; do sleep .5; done
}

function ediff {
    emacs --eval "(ediff \"$1\" \"$2\")"
}

function ddg {
    if test "$#" -eq 0
    then
        w3m https://duckduckgo.com
    else
        if test "$1" == "-f"
        then
            shift
            firefox --new-tab "https://duckduckgo.com/?q=$(echo ${@} | sed 's/ /+/g')"
        else
            w3m "https://duckduckgo.com/?q=$(echo ${@} | sed 's/ /+/g')"
        fi
    fi
}


function notify-prepare {
    if test "$#" -ne 3
    then
        exit 1
    fi
    cmd="echo 'notify-send -t 10000 -i \
    ~/.config/awesome/cuddly-succotash/icons/spaceman.jpg \
    \"$1\" \"$2\"' | at $3"
    eval "$cmd"
}
