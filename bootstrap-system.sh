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

info "First of all install some packages"
sudo pacman -S base-devel git man stow emacs xorg-server xorg-xinit mesa xterm xorg-twm awesome gdm xorg-server-xephyr opam python-pip ttf-dejavu ttf-droid ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-font-awesome ttf-hack ttf-inconsolata ttf-liberation acpi luarocks mpd ncmpcpp zathura rofi redshift lolcat cowsay thefuck figlet firefox neofetch compton htop fortune-mod network-manager-applet scrot lxappearence offlineimap neomutt notmuch

info "Install pikaur"
mkdir -p ~/git/
git clone https://aur.archlinux.org/pikaur.git ~/git/pikaur
cd ~/git/pikaur
makepkg -fsri

info "Install some AUR packages"
pikaur -S rtags termite-git matcha-gtk-theme protonmail-bridge

info "Install some opam stuff"
opam init
opam install ocp-indent

info "Install some lua stuff"
sudo luarocks install luafilesystem
sudo luarocks install penlight

git clone https://github.com/gueckmooh/dotfiles ~/.dotfiles

if [[ ! -d ~/.config ]]
then
    mkdir -p ~/.config
fi

git clone --single-branch --branch=testing --recursive https://github.com/gueckmooh/yet-another-awesome-config ~/.config/awesome
git clone https://github.com/gueckmooh/.emacs.d ~/.emacs.d

sudo systemctl enable gdm
