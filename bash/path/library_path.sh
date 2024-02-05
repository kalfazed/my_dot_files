#!/bin/bash

add_ld_path() {
    local new_path="$1"
    
    # Check if the new path is not already in the existing PATH
    if [[ ":$LD_LIBRARY_PATH:" != *":$new_path:"* ]]; then
        LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${new_path}"
        export LD_LIBRARY_PATH
    fi
}

# Modify your path here
add_ld_path /usr/local/cuda/lib64
add_ld_path /usr/local/lib
