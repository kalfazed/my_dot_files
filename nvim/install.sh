#!/usr/bin/bash

set -e

# ask for the sudo password upfront and keep it cached for the whole script
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &

# installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 22
nvm use 22 # Active the latest version

# install latest cargo and rustc
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# install dependencies
sudo apt-get update
sudo apt-get install -y build-essential codespell flake8 black isort unzip clang libclang-dev llvm-dev

# install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz

# deploy nvim config first, so a flaky tree-sitter-cli build below can never
# prevent the editor config from being installed
mkdir -p ~/.config/nvim
cp -r * ~/.config/nvim/

# Dynamic configure C_INCLUDE_PATH 和 LIBCLANG_PATH
DYNAMIC_C_INCLUDE=$(gcc -print-file-name=include)
DYNAMIC_LIBCLANG=$(find /usr/lib -name "libclang.so" -printf "%h\n" -quit 2>/dev/null)

echo "Detected C_INCLUDE_PATH: $DYNAMIC_C_INCLUDE"
echo "Detected LIBCLANG_PATH: $DYNAMIC_LIBCLANG"

# install treesitter (retry a few times; transient build/network failures
# here should not abort the whole installation)
for i in 1 2 3; do
    if C_INCLUDE_PATH="$DYNAMIC_C_INCLUDE" LIBCLANG_PATH="$DYNAMIC_LIBCLANG" cargo install --locked tree-sitter-cli; then
        break
    fi
    echo "tree-sitter-cli install failed (attempt $i/3)"
done

echo "Installation done. For additional install, please refer to README"
