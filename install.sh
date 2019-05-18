#!/usr/bin/env bash

# This script must be executed from within the .dotfiles directory
INSTALL_DIR=$(pwd)

DOTFILES=(.environment .tmux.conf .tmux.conf.local .vimrc)

# Symlink dotfiles
for dotfile in ${DOTFILES[@]}; do
    ln -s ${INSTALL_DIR}/${dotfile} ~/${dotfile} 
done

# Generate SSH key
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -C "kkhaichau@gmail.com"
    eval "$(ssh-agent -s)"
fi

# Install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Source environment file
if ! grep -Fxq "source ~/.environment" ~/.zshrc; then
    echo "source ~/.environment" >> ~/.zshrc
fi

# If using macOS, get Homebrew
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "Currently using a ${machine} OS"

if [ ${machine} == "Mac" ]; then

    # Mac specific SSH config
    if ! grep -Fxq "Host *" ~/.ssh/config; then
        echo "Updating SSH config"
        echo "Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_rsa
    " >> ~/.ssh/config
        ssh-add -K ~/.ssh/id_rsa
    fi

    # Brew
    if ! command -v brew; then
        echo "Installing Homebrew"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    BREW_INSTALL_TARGETS=(macvim cmake tmux)

    echo "Installing brew packages"
    for package in ${BREW_INSTALL_TARGETS[@]}; do
        if ! command -v ${package}; then
            brew install ${package}
        fi
    done

fi

# Get Vundle
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# Set up Vundle plugins
vim -c ":PluginInstall" -c "qa!"

# If using YouCompleteMe, install it
if [ -d ~/.vim/bundle/YouCompleteMe ]; then
    cd ~/.vim/bundle/YouCompleteMe
    ./install.py
    cd ${INSTALL_DIR}
fi
