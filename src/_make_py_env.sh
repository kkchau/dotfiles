#!/bin/bash

CONFIRM_Y="[Yy]"

# Build Python3 Virtual Environment with pre-loaded packages

build_env() {
    local DEFAULT_PYTHON_PACKAGES=(
        pylint
        black
        ipython
    )
    # Get env path
    read -p "Where should the venv be created? [default=$HOME/env]: " VENV_PATH
    [[ -z $VENV_PATH ]] && VENV_PATH="$HOME/env"

    # Overwrite env protection
    if [[ -d $VENV_PATH ]]; then
        read -p "$VENV_PATH already exists, overwrite? [Y/n]" OVERWRITE
        if [[ $OVERWRITE =~ $CONFIRM_Y ]]; then
            rm -rf $VENV_PATH
            python3 -m venv $VENV_PATH

            INFO "Default packages will be installed"
            source $VENV_PATH/bin/activate
            if [[ $? -ne 0 ]]; then
                WARN "Could not source $VENV_PATH/bin/activate; won't install packages"
            else
                pip install --upgrade pip
                pip install "${DEFAULT_PYTHON_PACKAGES[@]}"
            fi
        fi
    fi
}
