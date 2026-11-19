#!/usr/bin/env bash

cd "$(dirname "$0")"
mkdir -p ~/.config/peco

if [ "$(uname -s)" = "Darwin" ]; then
    brew install peco
else
    sudo apt-get install -y peco
fi

cp -r ./config.json ~/.config/peco
