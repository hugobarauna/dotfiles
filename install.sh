#!/bin/bash

echo "Installing bash configs"
rm ~/.bash_profile
ln -s $PWD/bash/bash_profile.sh ~/.bash_profile

echo "Installing bin"
rm -rf ~/bin
mkdir ~/bin
ln -s $PWD/bash/functions.sh ~/bin/functions.sh

echo "Installing Vim configs"
rm ~/.vimrc
ln -s $PWD/vim/vimrc ~/.vimrc

rm ~/.vimrc.bundles
ln -s $PWD/vim/vimrc.bundles ~/.vimrc.bundles

rm -f ~/.vim/autoload/plug.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
