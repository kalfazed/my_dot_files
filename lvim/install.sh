#!/usr/bin/bash

# install latest cargo and rustc
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# install neovim-0.9.0
sudo cp -r packages/nvim-0.9.0/* /usr/local/

# install npm
sudo apt-get update
sudo apt-get install -y npm

# install npm
sudo apt-get install -y codespell flake8 black isort

# install lunarvim-1.3
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
cp -r * ~/.config/lvim/

echo "Installation done. For additional install, please refer to README"
