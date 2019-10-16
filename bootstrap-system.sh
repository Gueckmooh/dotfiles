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
sudo pacman -S --needed base-devel git man stow emacs xorg-server xorg-xinit mesa xterm xorg-twm awesome gdm xorg-server-xephyr opam python-pip ttf-dejavu ttf-droid ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-font-awesome ttf-hack ttf-inconsolata ttf-liberation acpi luarocks mpd ncmpcpp zathura rofi redshift lolcat cowsay thefuck figlet firefox neofetch compton htop fortune-mod network-manager-applet scrot lxappearance offlineimap neomutt notmuch pass bash-completion


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

gpg --full-gen-key
user ' - What is your email?'
read -e email
pass init "$email"

sudo systemctl enable gdm
OLDPATH="$PWD"

cd ~/.dotfiles
bash bootstrap.sh
for file in ~/.bash*
do
    info "Savind $file -> $file.old"
    mv "$file" "$file.old"
done

function __stow() {
    info "Stowing $1"
    stow "$1"
}

__stow bash
__stow git
__stow cows
__stow compton
__stow htop
__stow mailcap
__stow mpd
__stow ncmpcpp
__stow redshift
__stow rofi
__stow termite
__stow zathura

info "Bootstraping ended"
neofetch
