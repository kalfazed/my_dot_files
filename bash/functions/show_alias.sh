#!/bin/bash

function show_aliases() {
    echo "List of Aliases and Their Commands:"
    alias | while IFS= read -r line; do
        echo "  $line"
    done
}

