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

    # Don't create .DS_Store on network drives
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE

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
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    BREW_INSTALL_TARGETS=(
        macvim
        cmake
        tmux
        grip
        sshfs
        coreutils
        universal-ctags
    )
    echo "Installing brew packages"
    for package in ${BREW_INSTALL_TARGETS[@]}; do
        brew install ${package}
    done

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
if ! grep -Fxq "source ~/.environment" ~/.bash_profile; then
    echo ". ~/.environment" >> ~/.bash_profile
fi

# Build Python3 Virtual Environment with pre-loaded packages
DEFAULT_PYTHON_PACKAGES=(
    pylint
    black
)
if [[ ! -z $(which python3) ]]; then
    read -p "Python3 found on system at $(which python3); create default virtual environment with default packages? [Y/n]: " CREATE_VENV
    if [[ ${CREATE_VENV} =~ ${CONFIRM_Y} ]]; then
        read -p "Where should the venv be created? [default=$HOME/env]: " VENV_PATH
        [[ -z $VENV_PATH ]] && VENV_PATH="$HOME/env"
        python3 -m venv $VENV_PATH

        INFO "Default packages will be installed"
        source $VENV_PATH/bin/activate
        if [[ $? -ne 0 ]]; then
            WARN "Could not source $VENV_PATH/bin/activate; won't install packages"
        else
            pip install "${DEFAULT_PYTHON_PACKAGES[@]}"
        fi
    fi
fi
