#!/bin/bash

# Function to customize bash prompt
function bash_prompt {
  # suffix
  suffix='$'

  # Git branch
  bash_git_branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/')
  
  # echo pwd and git branch
  echo -en "${YELLOW}${HOST}${CLEAR}${PURPLE}$(pwd)${CYAN}$bash_git_branch${CLEAR}\n"

  # Prompt suffix
  echo -n "$suffix "
}
