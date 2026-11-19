#!/usr/bin/env bash

cd "$(dirname "$0")"
source ${HOME}/.hostname.sh

mkdir -p ~/.config/bash
cp -r * ~/.config/bash

if [ "$(uname -s)" = "Darwin" ]; then
    # packages/bin contains Linux binaries; use Homebrew on macOS instead.
    # bash: macOS ships bash 3.2, which lacks READLINE_LINE used by the Ctrl+R peco history widget
    # eza: maintained fork of exa
    brew install bash eza ghq peco rsync
    rc_files=(~/.bashrc ~/.bash_profile)   # macOS login shells read .bash_profile
else
    sudo cp -r ./packages/bin/* /usr/local/bin
    rc_files=(~/.bashrc)
fi

echo "HOST=['${hostname}']" >> ~/.config/bash/variables/host_name.sh

for rc in "${rc_files[@]}"; do
    grep -qs "source ~/.config/bash/setup.sh" "$rc" || echo "source ~/.config/bash/setup.sh" >> "$rc"
done
