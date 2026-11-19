#!/usr/bin/env bash

cd "$(dirname "$0")"
source ../lib/pkg.sh

pkg_install peco

mkdir -p ~/.config/peco
cp -r ./config.json ~/.config/peco
