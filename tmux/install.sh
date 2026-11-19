#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

# install tmux
case "$(uname -s)" in
    Darwin)
        if ! command -v brew >/dev/null 2>&1; then
            echo "Homebrew is required on macOS: https://brew.sh" >&2
            exit 1
        fi
        brew install tmux
        ;;
    Linux)
        sudo apt-get -y install tmux
        ;;
esac

# config files
cp .tmux.conf .tmux.conf.osx .tmux.powerline.conf ~/

# status bar scripts (battery, ...)
mkdir -p ~/.tmux/scripts
cp scripts/*.sh ~/.tmux/scripts/
chmod +x ~/.tmux/scripts/*.sh

# TPM (tmux plugin manager); press prefix + I inside tmux to install plugins
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
