#!/usr/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <hostname>"
    exit 1
fi

# Set hostname (default $(whoami)
hostname=$1
echo "Hello ${hostname}"
rm ~/.hostname.sh
echo hostname=${hostname} >> ~/.hostname.sh

# ask for the sudo password upfront and keep it cached for the whole script
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &

sudo apt-get update

directories=("bash" "fish" "tmux" "peco" "nvim")

for dir in "${directories[@]}"; do
    if [ -d "$dir" ] && [ -f "$dir/install.sh" ]; then
        echo "Installing in $dir..."
        (cd "$dir" && bash install.sh && cd ..)
    else
        echo "Skipping $dir: Directory or install.sh not found."
    fi
done
