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
        emacsclient --alternate-editor 'vim' -c $*
    else
        emacsclient --alternate-editor 'vim' -c .
    fi
}

function macl {
    if [[ "$#" != 0 ]]
    then
        emacsclient --alternate-editor 'vim' -nw $*
    else
        emacsclient --alternate-editor 'vim' -nw .
    fi
}
