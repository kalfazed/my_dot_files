#!/usr/bin/bash
# installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# download and install Node.js (you may need to restart the terminal)
nvm install 22
nvm use 22 # Active the latest version

# install latest cargo and rustc
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# install neovim-0.9.0
sudo cp -r packages/nvim-0.9.1/* /usr/local/

# install npm
sudo apt-get update
sudo apt-get install -y npm python3 python-is-python3 pip shellcheck

# install npm
sudo apt-get install -y codespell flake8 black isort

# install lunarvim-1.3
LV_BRANCH='release-1.3/neovim-0.9' bash lvim-install.sh -y
mkdir ~/.config/lvim
cp -r * ~/.config/lvim/

# global clangd setting
cp -r ./clangd ~/.config/

echo "Installation done. For additional install, please refer to README"
