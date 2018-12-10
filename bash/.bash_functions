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
        # open=""
        # for i in $*
        # do
        #     open="$open -e '(find-file \"$i\")'"
        # done
        # emacsclient --alternate-editor 'vim' -nw -e "(alpha-on-term)" $open
        emacsclient --alternate-editor 'vim' -nw -e "(alpha-on-term)" -e "(find-file \"$1\")"
    else
        # emacsclient --alternate-editor 'vim' -nw .
        emacsclient --alternate-editor 'vim' -nw -e "(alpha-on-term)" -e '(dired ".")'
    fi
}
