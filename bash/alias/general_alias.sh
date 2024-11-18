#!/bin/bash

# General aliases
alias ls='ls -p --color=auto'
alias la='ls -A'
alias sleep='sudo systemctl suspend'
alias make='make -j64'
alias gt='git log --graph --pretty=format:"%x09%C(auto) %h %Cgreen %ar %Creset%x09 %C(cyan ul)%an%Creset %x09%C(auto)%s %d"'
alias gm='git commit -m'
alias dsort='du -sh -- * | sort -rh'
alias lm='df -hl -x tmpfs'
alias pip='python -m pip'
alias ll='exa --icons --long --git'
alias lla='ll -a'
alias tmux='tmux -u'
alias pd="peco_select_directory"
alias rs="rsync -azh --info=progress2 --no-i-r" # copy to local
alias rss="rsync -azh --info=progress2 -e \"ssh -T -c aes128-ctr -o Compression=no -x\" --block-size=128K --inplace " # copy to remote

# # Alias vim to neovim or lvim
if [ "$(type -t lvim)" == "file" ]; then
    alias vim='lvim'
fi
