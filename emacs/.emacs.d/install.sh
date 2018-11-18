#!/bin/bash

PACKAGES=(
    xclip
    w3m
    fonts-powerline
    clang
    lua-check
    lua5.1
    shellcheck
    git
)

TO_INSTALL=()

for package in "${PACKAGES[@]}"
do
    if ! dpkg-query -l "$package" > /dev/null 2> /dev/null
    then
       TO_INSTALL=( ${TO_INSTALL[@]} "$package")
    fi
done

for package in "${TO_INSTALL[@]}"
do
    echo "Package $package is missing"
done

SUDO=
if [[ $(id -u) != "0" ]]
then
    echo "sudo will be used..."
    SUDO=sudo
fi

for package in "${TO_INSTALL[@]}"
do
    $SUDO apt install "$package"
done
