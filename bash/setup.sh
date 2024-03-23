#!/bin/bash

# Set greeting
echo "welcome back!!"

# Get current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function source_files() {
    directory="$1"

    for file in "$directory"/*; do
        if [ -f "$file" ]; then
            source "$file"
        fi
    done
}

# Include all settings
source_files "$DIR/variables"
source_files "$DIR/alias"
source_files "$DIR/functions"
source_files "$DIR/keymaps"
#source_files "$DIR/path"
source_files "$DIR/packages"
source_files "$DIR/packages/z"

export LSCOLORS=gxfxcxdxbxegedabagacad
export TERM=xterm-256color
export THEME_HIDE_HOSTNAME=no
export THEME_COLOR_SCHEME=terminal-dark
export FISH_PROMPT_PWD_DIR_LENGTH=1
export THEME_DISPLAY_USER=yes
export THEME_HOSTNAME=always
export CUDA_MODULE_LOADING=LAZY

# Set custom bash prompt
PS1='$(bash_prompt)'

# Don't overwrite the history file, append to it instead
shopt -s histappend

# When the shell exits, append to the history file instead of overwriting it
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Load the history file and enable command history
HISTFILE=~/.bash_history
HISTSIZE=10000
HISTFILESIZE=10000

# Make commands immediately available in history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
