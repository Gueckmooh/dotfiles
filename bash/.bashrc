#[[ $TERM != "screen" ]] && exec tmux

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

#export color_prompt=yes;
if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}[\e[0;32m`ps ax | wc -l`(\j)\e[0m][\e[0;31m$?\e[0m]\e[1;34m\u\e[0m@\e[1;34m\h\e[0m:\e[0;36m\w\e[1;35m\$\e[0m\n\e[0;37m<\A>\e[0m '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    #PS1='${debian_chroot:+($debian_chroot)}\e[1;34m\u\e[0m@\e[1;34m\h\e[0m:\e[0;36m\w\e[1;35m\$\e[0m '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [[ -f ~/.bash_functions ]]; then
	. ~/.bash_functions
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# export PATH=$PATH::/usr/local/netbeans-8.2/bin
# export PATH=$PATH:/opt/i3lock-fancy
export PATH=$PATH:$HOME/bin
export PATH=$PATH:/home/brignone/.cargo/bin/
export GIT_SSH_COMMAND="ssh -i $HOME/.ssh/id_rsa -lgit"
export XDG_CONFIG_HOME=/home/brignone/.config
#sublime_text &

# OPAM configuration
. /home/brignone/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_121
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

parse_git_branch() {
    tput setaf 32; git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ ──(\1)──/'
}

__pth () {
    echo -n "${PWD/#$HOME/\~}" | awk -F "/" 'NF>4 { print $1"/"$2"/.../"$(NF-1)"/"$NF }
    NF<=4 { print $0 }'
}

__ret_code () {
    ret=$?
    if [[ $ret == 0 ]]
    then
       tput setaf 2; echo -n $ret
    else
        tput setaf 1; echo -n $ret
    fi
}

export PS1="┌─[\[$(tput sgr0)\]\[\033[38;5;7m\]\$(__ret_code)\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;1m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;2m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput sgr0)\]\[\033[38;5;63m\]\$(__pth)\[$(tput sgr0)\]\$(parse_git_branch)\[\033[38;5;15m\]\n└─[\[$(tput sgr0)\]\[\033[38;5;226m\]\A\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;1m\]---\[$(tput sgr0)\]\[\033[38;5;15m\]\\$ \[$(tput sgr0)\]"
export MYPS1="┌─[\[$(tput sgr0)\]\[\033[38;5;7m\]\$(__ret_code)\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;1m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;2m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput sgr0)\]\[\033[38;5;63m\]\$(__pth)\[$(tput sgr0)\]\$(parse_git_branch)\[\033[38;5;15m\]\n└─[\[$(tput sgr0)\]\[\033[38;5;226m\]\A\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;1m\]---\[$(tput sgr0)\]\[\033[38;5;15m\]\\$ \[$(tput sgr0)\]"

# export PS1="┌─[\[$(tput sgr0)\]\[\033[38;5;7m\]\$?\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;1m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;2m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput sgr0)\]\[\033[38;5;63m\]\w\[$(tput sgr0)\]\$(parse_git_branch)\[\033[38;5;15m\]\n└─[\[$(tput sgr0)\]\[\033[38;5;226m\]\A\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;1m\]---\[$(tput sgr0)\]\[\033[38;5;15m\]\\$ \[$(tput sgr0)\]"

export TERM=rxvt-unicode-256color
# export PATH=$PATH:/home/brignone/Documents/node/node-v6.11.3-linux-x64/bin
export JAVA_HOME=/usr/lib/jvm/jdk-8-oracle-x64


#if test -f `which powerline-daemon`
#then
#    powerline-daemon -q
#    POWERLINE_BASH_CONTINUATION=1
#    POWERLINE_BASH_SELECT=1
#    . /usr/share/powerline/bindings/bash/powerline.sh
#fi


# export EDITOR="emacs -nw"
export EDITOR="emacsclient -nw"

if [[ ! -z $DISPLAY ]]
then
    # echo Welcome ! | toilet | lolcat
    echo Welcome ! | $HOME/bin/random-figlet | lolcat
    fortune -s 2> /dev/null | cowsay -f $HOME/.config/cows/totoro.cow | lolcat
fi

export XDG_USER_CONFIG_DIR=$HOME/.config
#export GTK_THEME=Ant-Dracula
export QEMU_LD_PREFIX=/usr/arm-linux-gnueabi/
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
# export PATH=$PATH:$JAVA_HOME/bin
# source /opt/Xilinx/Vivado/2018.2/settings64.sh
#source /home/brignone/Xilinx/Vivado/2017.3/settings64.sh

export LUA_PATH="./?/init.lua;$HOME/lua/?.lua;$HOME/lua/?/init.lua;$HOME/lua/?/?.lua;$HOME/lua/?.so;;"


# Exercism
# PATH=$PATH:/home/brignone/install/exercism

eval $(thefuck --alias)

# Add Otawa to path
OTAWA_PATH='/home/brignone/install/otawa/Otawa/linux/bin'
PATH=$PATH:$OTAWA_PATH
# added by Anaconda3 2018.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/brignone/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/home/brignone/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/brignone/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/home/brignone/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<

export PS1=$MYPS1


# MPD confguration
export MPD_HOST="localhost"
export MPD_PORT="6601"
