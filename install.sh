#!/bin/bash
#  _           _        _ _
# (_)_ __  ___| |_ __ _| | |
# | | '_ \/ __| __/ _` | | |
# | | | | \__ \ || (_| | | |
# |_|_| |_|___/\__\__,_|_|_|

function createBackupDir () {

    local __bkdir="/home/$(whoami)/.bk/$(date +%Y-%m-%d-%H%M%S)"
    # create a backup directory if it doesn't exist
    mkdir -p "$__bkdir"

    # move files into backup directory
    for i in .bash_profile .bashrc .profile .vimrc .viminfo .alias; do
        # if not a symlink, backup the file
        if [ ! -h "/home/$(whoami)/$i" ]; then
            mv "$i" "$__bkdir"
        fi

    done
}

function setupBash () {

    # deploy symlinks to new files
    if [ -f "/home/$(whoami)/dotfiles/bash/bashrc" ]; then
        ln -fs "/home/$(whoami)/dotfiles/bash/bashrc" ~/.bashrc
    else
        printf "/home/$(whoami)/dotfiles/bash/bashrc NOT FOUND\n"
    fi

    if [ -f "/home/$(whoami)/dotfiles/bash/bash_profile" ]; then
        ln -fs ~/dotfiles/bash/bash_profile ~/.bash_profile
    else
        printf "/home/$(whoami)/dotfiles/bash/bash_profile NOT FOUND\n"
    fi

    # reload .bash_profile
    source "/home/$(whoami)/.bash_profile"

}

function setupVIM () {

    mkdir -pv "/home/$(whoami)/.vim/colors"
    # symlink the vim color directory
    ln -fs "/home/$(whoami)/dotfiles/vim/colors" ~/.vim/colors
    # symlink over vim stuff
    ln -fs "/home/$(whoami)/dotfiles/vim/vimrc" ~/.vimrc

    # download vim themes
    curl -s https://raw.githubusercontent.com/Yggdroot/duoduo/master/colors/duoduo.vim > vim/colors/duoduo.vim

}

function installAptCyg () {
    # download apt-cyg
    if [ "$(which lynx)" ]; then
        lynx -source rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg
    else
        printf "Make sure that lynx is installed prior to running cygwin setup"
        exit 1
    fi

    # install apt-cyg
    install apt-cyg /bin
}

function installApps () {

    local __apps=(vim tmux zip unzip rar unrar rsync curl pv git wget)
    local __appsLinux=(htop)
    local __appsCygwin=()

    # determine if cygwin and install apt-cyg
    if [ "$(uname -s | grep -ic 'cygwin')" -eq 1 ] && [ ! "$(command -v apt-cyg)" ]; then
        printf "Detected Cygwin..."
        installAptCyg
    fi

    # apt
    if [ "$(command -v apt-get)" ]; then

        # install generic apps
        for i in ${__apps[@]}; do
            sudo apt-get install -y $i
        done

        # install linux specific
        for i in ${__appsLinux[@]}; do
            sudo apt-get install -y $i
        done

    elif [ "$(command -v yum)" ]; then

        # install generic apps
        for i in ${__apps[@]}; do
            sudo yum install -y $i
        done

        # install linux specific
        for i in ${__appsLinux[@]}; do
            sudo yum install -y $i
        done

    elif [ "$(command -v apt-cyg)" ]; then

        # install generic apps
        for i in ${__apps[@]}; do
            apt-cyg install $i
        done

        # install cygwin specific
        for i in ${__appsCygwin[@]}; do
            apt-cyg install $i
        done

    else
        printf "install method not known, skipping app install..."
    fi
}

# the loop
while true; do

    printf "dotfiles installation menu...\n\n"
    printf "0 - Automatic Install and Setup\n"
    printf "1 - Install apps\n"
    printf "2 - BASH Profile\n"
    printf "3 - VIM Profile\n"
    printf "Q - Quit\n"

    # take in input
    read -p "Enter Choice: " choice

    case "$choice" in
        0 )
            # automatic install and setup
            installApps
            setupBash
            setupVIM
            exit 0
            ;;
        1 )
            # install apps
            installApps
            break
            ;;
        2 )
            # setupBash
            setupBash
            break
            ;;
        3 )
            # setupVIM
            setupVIM
            break
            ;;
        q|Q )
            # quit
            exit 0
            ;;
        * )
            printf "Choice not recognized, try again..."
            ;;
    esac

done