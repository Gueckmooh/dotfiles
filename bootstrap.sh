#!/bin/bash

info () {
    printf "\r  [ \033[00;34minfo\033[0m ] $1\n"
}

user () {
    printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    echo ''
    exit
}

TEMP=$(getopt -o 'f' --long 'force' -n "$0" -- "$@")

if [ $? -ne 0 ]; then
	  echo 'Terminating...' >&2
	  exit 1
fi

eval set -- "$TEMP"
unset TEMP

while true; do
	  case "$1" in
        '-f'|'--force')
            force=t
            shift
            continue
            ;;
        '--')
            shift
            break
            ;;
		    *)
			      echo 'Internal error!' >&2
			      exit 1
		        ;;
	  esac
done

setup_gitconfig () {

    if [[ "$force" ]]
    then
        rm -fr git
    fi

    if [[ ! -d git ]]
    then
        info "Creating dir git"
        mkdir git
    fi

    if [[ ! -f git/.gitconfig ]]
    then
        info 'Setup gitconfig'

        user ' - What is your github author name?'
        read -e git_authorname
        user ' - What is your github author email?'
        read -e git_authoremail

        sed -e "s/USERNAME/$git_authorname/g" -e "s/EMAIL/$git_authoremail/g" bootstrap/gitconfig.template > git/.gitconfig

        success 'gitconfig'
    fi
}

setup_gitconfig
