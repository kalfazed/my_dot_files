#!/bin/bash

# Function to use peco to select a directory and change into it
function peco_select_directory() {
  local path=$(ghq root)/$(ghq list | peco --layout=bottom-up)
  if [ -d "$path" ]; then
    cd "$path"
  else
    echo "No directory selected or invalid path."
  fi
}
