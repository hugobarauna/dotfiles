#!/bin/bash

echo "Installing bin"
rm -rf ~/bin
mkdir ~/bin
ln -s $PWD/bash/functions ~/bin/functions
