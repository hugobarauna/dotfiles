#!/bin/bash

echo "Installing bash configs"
rm ~/.bash_profile
ln -s $PWD/bash/bash_profile.sh ~/.bash_profile

echo "Installing bin"
rm -rf ~/bin
mkdir ~/bin
ln -s $PWD/bash/functions.sh ~/bin/functions.sh
