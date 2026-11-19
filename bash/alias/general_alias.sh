#!/bin/bash

# General aliases
if [ "$(uname -s)" = "Darwin" ]; then
    alias ls='ls -p -G'
    alias sleep='pmset sleepnow'
    alias lm='df -hl'
else
    alias ls='ls -p --color=auto'
    alias sleep='sudo systemctl suspend'
    alias lm='df -hl -x tmpfs'
fi
# eza is the maintained fork of exa (Homebrew only ships eza)
if command -v eza >/dev/null 2>&1; then
    alias ll='eza --icons --long --git'
else
    alias ll='exa --icons --long --git'
fi
alias la='ls -A'
alias make='make -j64'
alias gt='git log --graph --pretty=format:"%x09%C(auto) %h %Cgreen %ar %Creset%x09 %C(cyan ul)%an%Creset %x09%C(auto)%s %d"'
alias gm='git commit -m'
alias dsort='du -sh -- * | sort -rh'
alias pip='python -m pip'
alias lla='ll -a'
alias tmux='tmux -u'
alias pd="peco_select_directory"
alias rs="rsync -azh --info=progress2 --no-i-r" # copy to local
alias rss="rsync -azh --info=progress2 -e \"ssh -T -c aes128-ctr -o Compression=no -x\" --block-size=128K --inplace " # copy to remote

# # Alias vim to neovim or lvim
if [ "$(type -t lvim)" == "file" ]; then
    alias vim='lvim'
fi
