#!/usr/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <hostname>"
    exit 1
fi

# Set hostname (default $(whoami)
hostname=$1
echo "Hello ${hostname}"
echo hostname=${hostname} >> hostname.sh

directories=("bash" "fish" "tmux" "peco" "lvim")

for dir in "${directories[@]}"; do
    if [ -d "$dir" ] && [ -f "$dir/install.sh" ]; then
        echo "Installing in $dir..."
        (cd "$dir" && bash install.sh && cd ..)
    else
        echo "Skipping $dir: Directory or install.sh not found."
    fi
done

rm hostname.sh

# Set default shell as fish
chsh -s /usr/bin/fish

