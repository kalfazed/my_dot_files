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

sudo apt-get update

directories=("bash" "fish" "tmux" "peco")

for dir in "${directories[@]}"; do
    if [ -d "$dir" ] && [ -f "$dir/install.sh" ]; then
        echo "Installing in $dir..."
        (cd "$dir" && bash install.sh && cd ..)
    else
        echo "Skipping $dir: Directory or install.sh not found."
    fi
done
