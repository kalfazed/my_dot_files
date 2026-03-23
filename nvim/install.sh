#!/usr/bin/bash

# installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

nvm install 22
nvm use 22 # Active the latest version

# install latest cargo and rustc
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# install npm
sudo apt-get install -y codespell flake8 black isort unzip

# install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# install treesitter
C_INCLUDE_PATH=/usr/lib/gcc/x86_64-linux-gnu/11/include cargo install --locked tree-sitter-cli

mkdir ~/.config/nvim
cp -r * ~/.config/nvim/

echo "Installation done. For additional install, please refer to README"
