#!/usr/bin/env bash

INFO() {
    echo 2>&1 "INFO: $@"
}
WARN() {
    echo 2>&1 "WARN: $@"
}

CONFIRM_Y="[Yy]"
CONFIRM_N="[Nn]"

# This script must be executed from within the .dotfiles directory
INSTALL_DIR=$(pwd -P)
[[ $(basename ${INSTALL_DIR}) != ".dotfiles" ]] && WARN "Please execute script from .dotfiles directory" && exit 1
DOTFILES=(.environment .tmux.conf .tmux.conf.local .vimrc)

# Make backups of current dotfiles
MAKE_BACKUPS() {
    mkdir ~/.dotfiles_backup
    for dotfile in ${DOTFILES[@]}; do
        cp -L ~/${dotfile} ~/.dotfiles_backup
        rm -f ~/${dotfile}
    done
}
if [[ -d ~/.dotfiles_backup ]]; then
    read -p ".dotfiles_backup already exists! Overwrite? [Y/n]: " OVERWRITE
    if [[ ${OVERWRITE} =~ ${CONFIRM_Y} ]]; then
        rm -rf ~/.dotfiles_backup
        MAKE_BACKUPS
    else
        INFO "Won't overwrite ~/.dotfiles_backup"
    fi
else
    MAKE_BACKUPS
fi

# Symlink dotfiles
INFO "Symlinking dotfiles..."
for dotfile in ${DOTFILES[@]}; do
    INFO "Linking from ${INSTALL_DIR}/${dotfile} to ${HOME}/${dotfile}"
    ln -s ${INSTALL_DIR}/${dotfile} ~/${dotfile}
done

# Generate SSH key
read -p "Generate SSH key? [Y/n]: " GENERATE_KEY
if [[ ${GENERATE_KEY} =~ ${CONFIRM_Y} ]]; then
    if [ ! -f ~/.ssh/id_rsa ]; then
        read -p "Specify email ID for key: " SSH_EMAIL_COMMENT
        KEYGEN_CMD=( "ssh-keygen" "-t" "rsa" "-b" "4096" "-C" "${SSH_EMAIL_COMMENT}" )
        INFO ${KEYGEN_CMD}
        ${KEYGEN_CMD}
        eval "$(ssh-agent -s)"
    else
        WARN "~/.ssh/id_rsa already exists, won't create a new key"
    fi
else
    INFO "Won't generate SSH key"
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
    read -p "Machine discovered to be ${machine}; setup ${machine}? [Y/n]: " MAKE_MAC
    if [[ ${CREATE_VENV} =~ ${CONFIRM_Y} ]]; then
        . ./src/install_mac.sh
        build_mac
    fi
fi

# Get Vundle
INFO "Installing Vundle for Vim plugins"
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# Set up Vundle plugins
vim -c ":PluginInstall" -c "qa!"

# If using YouCompleteMe, install it
INFO "Install YouCompleteMe to utilize plugin"
#if [ -d ~/.vim/bundle/YouCompleteMe ]; then
#    cd ~/.vim/bundle/YouCompleteMe
#    ./install.py
#    cd ${INSTALL_DIR}
#fi

# Source environment file
if ! grep -Fxq ". ~/.environment" ~/.bash_profile; then
    echo ". ~/.environment" >> ~/.bash_profile
fi

# Build Python3 Virtual Environment with pre-loaded packages
if [[ ! -z $(which python3) ]]; then
    read -p "Python3 found on system at $(which python3); create default virtual environment with default packages? [Y/n]: " CREATE_VENV
    if [[ ${CREATE_VENV} =~ ${CONFIRM_Y} ]]; then
        . ./src/_make_py_env.sh
        build_env
    fi
fi
