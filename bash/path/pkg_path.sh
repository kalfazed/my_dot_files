#!/bin/bash

add_pkg_path() {
    local new_path="$1"
    
    # Check if the new path is not already in the existing PATH
    if [[ ":$PKG_CONFIG_PATH:" != *":$new_path:"* ]]; then
        PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${new_path}"
        export PATH
    fi
}

add_pkg_path /usr/local/lib/pkgconfig
