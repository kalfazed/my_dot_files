#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"
source ../lib/pkg.sh

if [ "$PKG_OS" = "Darwin" ] && ! have brew; then
    echo "Homebrew is required on macOS: https://brew.sh" >&2
    exit 1
fi
pkg_install tmux

# config files
cp .tmux.conf .tmux.conf.osx .tmux.powerline.conf ~/

# status bar scripts (battery, ...)
mkdir -p ~/.tmux/scripts
cp scripts/*.sh ~/.tmux/scripts/
chmod +x ~/.tmux/scripts/*.sh

# TPM (tmux plugin manager); press prefix + I inside tmux to install plugins
if [ -d ~/.tmux/plugins/tpm ] && ! forced; then
    skip "tpm"
else
    rm -rf ~/.tmux/plugins/tpm
    git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
