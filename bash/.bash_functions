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
        emacsclient -c $*
    else
        emacsclient -c .
    fi
}

function macl {
    if [[ "$#" != 0 ]]
    then
        emacsclient -nw $*
    else
        emacsclient -nw .
    fi
}
