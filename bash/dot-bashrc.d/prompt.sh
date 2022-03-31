# -*- mode: shell-script; -*-

__git_branch() {
    tput setaf 32; git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ ──(\1)──/'
}

__path () {
    echo -n "${PWD/#$HOME/\~}" | awk -F "/" 'NF>4 { print $1"/"$2"/.../"$(NF-1)"/"$NF }
    NF<=4 { print $0 }'
}

__return_code () {
    ret=$?
    if [[ $ret == 0 ]]
    then
        tput setaf 2; echo -n $ret
    else
        tput setaf 1; echo -n $ret
    fi
}

export PS1="\[$(tput sgr0)\]\[\033[38;5;15m\]┌─[\[$(tput sgr0)\]\[\033[38;5;7m\]\$(__return_code)\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;1m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;2m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput sgr0)\]\[\033[38;5;63m\]\$(__path)\[$(tput sgr0)\]\$(__git_branch)\[\033[38;5;15m\]\n└─[\[$(tput sgr0)\]\[\033[38;5;226m\]\A\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;1m\]---\[$(tput sgr0)\]\[\033[38;5;15m\]\\$ \[$(tput sgr0)\]"
