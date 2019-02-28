#!/bin/bash

STOW="stow -t $HOME --ignore='*.info'"

info () {
    printf "\r[ \033[00;34mINFO\033[0m ] $1\n"
}

user () {
    printf "\r[ \033[0;33m??\033[0m ] $1"
}

success () {
    printf "\r\033[2K[ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    echo ''
    exit
}

install () {
    info "Install package $1"
    if [[ -e "$HOME/$1" ]]
    then
        fail "$HOME/$1 already exists"
    fi

    if [[ -e "$(realpath $1)/package.info" ]]
    then
        less "$(realpath $1)/package.info"
    fi

    $STOW "$1"

    if [[ $? != "0" ]]
    then
        fail "Could not install package $1"
    else
        success "Install package $1"
    fi
}

for package in $@
do
    install "$package"
done
