#!/bin/bash

# General aliases
alias ls='ls -p --color=auto'
alias la='ls -A'
alias sleep='sudo systemctl suspend'
alias make='make -j64'
alias gt='git log --graph --pretty=format:"%x09%C(auto) %h %Cgreen %ar %Creset%x09 %C(cyan ul)%an%Creset %x09%C(auto)%s %d"'
alias dsort='du -sh -- * | sort -rh'
alias lm='df -hl -x tmpfs'
alias pip='python -m pip'
alias ll='exa --icons --long --no-user --no-time'
alias lla='ll -a'
alias tmux='tmux -u'

# # Alias vim to neovim or lvim
if [ "$(type -t lvim)" == "file" ]; then
    alias vim='lvim'
fi
