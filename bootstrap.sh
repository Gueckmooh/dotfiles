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

setup_neomutt () {
    if [[ "$force" ]]
    then
        rm -fr neomutt
    fi

    if [[ ! -d neomutt ]]
    then
        info "Creating dir neomutt"
        mkdir -p neomutt/.config/neomutt
    fi

    if [[ ! -f neomutt/.config/neomutt/mailcap ]]
    then
        info "Setup mailcap"
        cp bootstrap/mutt.mailcap neomutt/.config/neomutt/mailcap
    fi

    if [[ ! -f neomutt/.config/neomutt/neomuttrc ]]
    then
        info "Setup neomuttrc"

        user ' - What is your name?'
        read -e name
        user ' - What is your email?'
        read -e email
        user ' - What is your proton-mail bridge password?'
        read -e pmpasswd

        sed -e "s/NAME/$name/g" -e "s/EMAIL/$email/g" -e "s/BRIDGE-PASSWORD/$pmpasswd/g" bootstrap/muttrc.template > neomutt/.config/neomutt/neomuttrc

        success 'neomuttrc'
    fi

    if [[ ! -f neomutt/.config/neomutt/aliases ]]; then touch neomutt/.config/neomutt/aliases; fi
    if [[ ! -f neomutt/.config/neomutt/signature ]]; then touch neomutt/.config/neomutt/signature; fi
}

setup_offlineimap () {
    if [[ "$force" ]]
    then
        rm -fr offlineimap
    fi

    if [[ ! -d offlineimap ]]
    then
        info "Creating dir offlineimap"
        mkdir -p offlineimap/
    fi

    if [[ ! -f offlineimap/.offlineimaprc ]]
    then
        info "Setup offlineimaprc"

        user ' - What is your email?'
        if [[ -z ${email+x} ]]
        then
            read -e email
        else
            info "Guessing $email"
        fi

        user ' - What is your proton-mail bridge password?'
        if [[ -z ${pmpasswd+x} ]]
        then
            read -e pmpasswd
        else
            info "Guessing $pmpasswd"
        fi

        sed -e "s/EMAIL/$email/g" -e "s/BRIDGE-PASSWORD/$pmpasswd/g" bootstrap/offlineimaprc.template > offlineimap/.offlineimaprc

        success 'neomuttrc'
       fi
}

setup_notmuch () {
    if [[ "$force" ]]
    then
        rm -fr notmuch
    fi

    if [[ ! -d notmuch ]]
    then
        info "Creating dir notmuch"
        mkdir -p notmuch/
    fi

    if [[ ! -f notmuch/.notmuch-config ]]
    then
        info "Setup notmuch-config"

        user ' - What is your email?'
        if [[ -z ${email+x} ]]
        then
            read -e email
        else
            info "Guessing $email"
        fi

        user ' - What is your name?'
        if [[ -z ${name+x} ]]
        then
            read -e name
        else
            info "Guessing $name"
        fi

        # sed -e "s/EMAIL/$email/g" -e "s/BRIDGE-PASSWORD/$pmpasswd/g" bootstrap/offlineimaprc.template > offlineimap/.offlineimaprc
        sed -e "s/NAME/$name/g" -e "s/EMAIL/$email/g" bootstrap/notmuch-config.template > notmuch/.notmuch-config

        success 'notmuch'
    fi
}

setup_gitconfig
setup_neomutt
setup_offlineimap
setup_notmuch
