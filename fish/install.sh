#!/usr/bin/env bash

cd "$(dirname "$0")"
source ~/.hostname.sh

if [ "$(uname -s)" = "Darwin" ]; then
    # packages/bin contains Linux binaries; use Homebrew on macOS instead (eza: maintained fork of exa)
    brew install fish peco curl p7zip eza ghq rsync
else
    sudo apt-get install -y fish peco curl p7zip-full
fi

mkdir -p ~/.config/fish
cp -r * ~/.config/fish

if [ "$(uname -s)" != "Darwin" ]; then
    sudo cp -r ./packages/bin/* /usr/local/bin
fi

echo "SETUVAR HOST:['${hostname}']" >> ~/.config/fish/fish_variables

# Install fisher and z
# (Node.js is installed by the nvim module, the only one that needs it)
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fish -c "fisher install jethrokuan/z"
