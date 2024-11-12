#!/usr/bin/bash
# installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
echo "export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"" >> ~/.bashrc
echo "[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm" >> ~/.bashrc

nvm install 22
nvm use 22 # Active the latest version

# install latest cargo and rustc
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# install neovim-0.9.0
sudo cp -r packages/nvim-0.9.1/* /usr/local/

# install npm
sudo apt-get update
sudo apt-get install -y npm python3 python-is-python3 pip shellcheck

# install npm
sudo apt-get install -y codespell flake8 black isort

# install lunarvim-1.4 stable
LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) -y
mkdir ~/.config/lvim
cp -r * ~/.config/lvim/

# global clangd setting
cp -r ./clangd ~/.config/

echo "Installation done. For additional install, please refer to README"
