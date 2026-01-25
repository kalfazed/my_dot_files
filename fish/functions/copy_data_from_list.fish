#!/usr/bin/env fish
#
# copy_data_from_list.fish
#
# This script copies directories listed in a file to a target directory.

# Check for the correct number of arguments
if test (count $argv) -ne 2
    echo "Usage: "(basename (status filename))" <list_file> <target_dir>"
    exit 1
end

set list_file $argv[1]
set target_dir $argv[2]

# Ensure target directory exists
mkdir -p "$target_dir"

# Iterate through each line in the list file
# Fish's equivalent of 'while read' is often handled by piping 'cat' into a 'for' loop
for dir in (cat "$list_file")
    if test -d "$dir"
        echo "Copying $dir -> $target_dir"
        cp -r "$dir" "$target_dir"
    else
        echo "⚠️  Directory does not exist: $dir"
    end
end
