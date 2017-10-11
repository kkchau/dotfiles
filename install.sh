#!/bin/bash

#############################################################################
#                                                                           #
# Creates symlinks to dotfiles in this repository                           #
#                                                                           #
#############################################################################

########## Variables

dir=~/.dotfiles
dir_old=~/.dotfiles_old
files=".bashrc .zshrc .dircolors .vimrc .aliases .tmux.conf .inputrc .oh-my-zsh .vim .config"

########## Messages

usage="$(basename "$0") -- Create symlinks to provided dotfiles" 

##########


# old dotfiles
echo "Creating backup directory $dir_old"
mkdir -p $dir_old

# change to this repo
# echo "Changing to new dotfiles directory $dir"
# cd $dir

# backup
echo "Backing up and replacing dotfiles"
for file in $files; do
    echo "Moving $file..."
    mv ~/$file $dir_old/
    echo "Replacing $file..."
    ln -sf $dir/${file} ~/$file
done

# install Vundle
if [ ! -d ~/.vim/bundle/Vundle.vim/.git ]; then
    echo "Installing Vundle"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo "Done! Remember to run :PluginInstall in vim to install plugins!"
fi

install_zsh() {
    if [ ! -d "$dir/zsh" ]; then
        mkdir -p $dir/zsh
        wget -qO - ftp://ftp.zsh.org/pub/zsh.tar.gz | tar -xzvf -C $dir/zsh
    fi
}
