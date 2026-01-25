#!/usr/bin/env fish

function cp_data_from_list_help
    echo "Usage: cp_data_from_list <LIST_FILE> <TARGET_DIR>"
    echo ""
    echo "Copy directories listed in a file."
    echo ""
    echo "Arguments:"
    echo "  LIST_FILE   Text file containing the names of directories to remove."
    echo "  TARGET_DIR  Base directory. Relative paths in the list are resolved relative to this."
    echo "              (Absolute paths in the list ignore this argument)."
    echo ""
    echo "Options:"
    echo "  -h, --help  Show this help message and exit."
    echo ""
    echo "Example:"
    echo "  cp_data_from_list cleanup_list.txt /var/www/html"
end

function cp_data_from_list
    # Color definitions for better output
    set -l RED (set_color red)
    set -l GREEN (set_color green)
    set -l YELLOW (set_color yellow)
    set -l BOLD (set_color -o)
    set -l CLEAR (set_color normal)

    # 1. Check for help arguments
    if contains -- -h $argv; or contains -- --help $argv
        cp_data_from_list_help
        return 0
    end

    # 2. Check for correct argument count
    if test (count $argv) -ne 2
        echo $RED"Error: Missing arguments."$CLEAR
        cp_data_from_list_help
        return 1
    end

    set -l list_file $argv[1]
    set -l target_base_dir $argv[2]
    
    # 3. Validate Input Files
    if not test -f "$list_file"
        echo $RED"Error: List file '$list_file' not found."$CLEAR
        return 1
    end

    if not test -d "$target_base_dir"
        echo $RED"Error: Target base directory '$target_base_dir' not found."$CLEAR
        return 1
    end

    # Get absolute path of the base directory to ensure clean joining later
    set -l abs_base_dir (realpath "$target_base_dir")
    
    # Initialize a list to store valid paths to be deleted
    set -l paths_to_remove

    # 4. Parse the list file
    # We use `cat | while read` to handle paths with spaces correctly
    echo "Processing list..."
    cat "$list_file" | while read -l line
        # Skip empty lines or comments (starting with #)
        if test -z "$line"; or string match -q "#*" "$line"
            continue
        end

        set -l final_path ""

        # Check if the path in file is absolute (starts with /)
        if string match -q "/*" "$line"
            set final_path "$line"
        else
            # It's relative, join with target_base_dir
            # Remove trailing slash from base if present to avoid double //
            set final_path "$abs_base_dir/$line"
        end

        # Resolve to clean absolute path (handling ../ etc)
        # We suppress error output; we will check existence manually next
        if test -e "$final_path"
             set final_path (realpath "$final_path")
             set -a paths_to_remove "$final_path"
        else
             echo $YELLOW"⚠️  Warning: Path not found, skipping: $final_path"$CLEAR
        end
    end

    # 5. Check if we found anything to delete
    if test (count $paths_to_remove) -eq 0
        echo $YELLOW"No valid directories found to copy."$CLEAR
        return 0
    end

    # 6. Show summary and ask for confirmation
    echo ""
    echo $RED$BOLD"The following directories will be copied:"$CLEAR
    echo "----------------------------------------------------"
    for p in $paths_to_remove
        echo "$p" -> "$target_base_dir"
    end
    echo "----------------------------------------------------"
    
    read -l -P "Are you sure you want to proceed? [y/N] " confirm

    if test "$confirm" = "y"; or test "$confirm" = "Y"
        echo ""
        for dir in $paths_to_remove
            echo "Moving: $dir to $target_base_dir"
            cp -r "$dir" "$target_base_dir"
        end
        echo $GREEN"Done."$CLEAR
    else
        echo $YELLOW"Operation cancelled."$CLEAR
    end
end
