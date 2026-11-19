#!/usr/bin/bash

sudo apt-get -y install tmux
cp .tmux.* ~/
mkdir -p ~/.tmux/scripts
cp scripts/*.sh ~/.tmux/scripts/
chmod +x ~/.tmux/scripts/*.sh
