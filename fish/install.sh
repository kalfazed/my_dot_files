#!/usr/bin/bash

sudo apt-get install -y fish peco
mkdir -p ~/.config/fish
cp -r * ~/.config/fish

# Set hostname (default $(whoami)
echo "Please input your hostname: "
read hostname
echo "Hello ${hostname}"
echo "SETUVAR HOST:['${hostname}']" >> ~/.config/fish/fish_variables

# Install fisher and z
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fish -c "fisher install jethrokuan/z"
fish
