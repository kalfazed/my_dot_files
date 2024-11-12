#!/usr/bin/bash

source ~/.hostname.sh

sudo apt-get install -y fish peco curl
mkdir -p ~/.config/fish
cp -r * ~/.config/fish
sudo cp -r ./packages/bin/* /usr/local/bin

echo "SETUVAR HOST:['${hostname}']" >> ~/.config/fish/fish_variables

# Install fisher and z
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fish -c "fisher install jethrokuan/z"
fish -c "fisher install jorgebucaran/nvm.fish"
fish -c "nvm install v22.11.0"
fish -c "set --universal nvm_default_version v22.11.0"
