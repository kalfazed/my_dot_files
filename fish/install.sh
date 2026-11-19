#!/usr/bin/env bash

cd "$(dirname "$0")"
source ../lib/pkg.sh
source ~/.hostname.sh

if [ "$PKG_OS" = "Darwin" ]; then
    # packages/bin contains Linux binaries; use Homebrew on macOS instead (eza: maintained fork of exa)
    pkg_install fish peco curl p7zip eza ghq rsync
else
    pkg_install fish peco curl p7zip-full
fi

mkdir -p ~/.config/fish
cp -r * ~/.config/fish

if [ "$PKG_OS" != "Darwin" ]; then
    sudo cp -r ./packages/bin/* /usr/local/bin
fi

echo "SETUVAR HOST:['${hostname}']" >> ~/.config/fish/fish_variables

# Install fisher and z (skip plugins that are already installed)
# (Node.js is installed by the nvim module, the only one that needs it)
fisher_has() { fish -c "type -q fisher; and fisher list" 2>/dev/null | grep -qx "$1"; }

if fisher_has jorgebucaran/fisher && ! forced; then
    skip "fisher"
else
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fi

if fisher_has jethrokuan/z && ! forced; then
    skip "z"
else
    fish -c "fisher install jethrokuan/z"
fi
