#!/bin/bash

add_path() {
    local new_path="$1"
    
    # Check if the new path is not already in the existing PATH
    if [[ ":$PATH:" != *":$new_path:"* ]]; then
        PATH="${PATH}:${new_path}"
        export PATH
    fi
}


# Modify your path here
add_path /usr/local/bin
add_path /usr/local/cuda/bin
add_path /usr/src/tensorrt/bin
