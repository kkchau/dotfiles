#!/bin/bash

CONFIRM_Y="[Yy]"

build_mac() {

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
        asdf
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
}
