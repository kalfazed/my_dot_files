#!/bin/bash

# Function to ls after cs
function cd() {
  command cd "$@" && ll
}
