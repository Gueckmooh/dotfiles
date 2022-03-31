# -*- mode: shell-script; -*-

if which opam 2> /dev/null > /dev/null
then
    . /home/brignone/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
    eval $(opam env)
fi
