#!/usr/bin/env fish

function mv_data_from_list_help
    echo "Usage: mv_data_from_list <LIST_FILE> <TARGET_DIR>"
    echo ""
    echo "Move directories listed in a file to the target directory."
    echo ""
    echo "Arguments:"
    echo "  LIST_FILE   Text file containing the names/paths of directories to move."
    echo "              (Relative paths are resolved from the Current Working Directory)."
    echo "  TARGET_DIR  Destination directory where folders will be moved TO."
    echo ""
    echo "Options:"
    echo "  -h, --help  Show this help message and exit."
    echo ""
    echo "Example:"
    echo "  # Run from the folder containing the data:"
    echo "  mv_data_from_list cleanup_list.txt /var/www/html"
end

function mv_data_from_list
    # Color definitions
    set -l RED (set_color red)
    set -l GREEN (set_color green)
    set -l YELLOW (set_color yellow)
    set -l BOLD (set_color -o)
    set -l CLEAR (set_color normal)

    # 1. Check for help
    if contains -- -h $argv; or contains -- --help $argv
        mv_data_from_list_help
        return 0
    end

    # 2. Check arguments
    if test (count $argv) -ne 2
        echo $RED"Error: Missing arguments."$CLEAR
        mv_data_from_list_help
        return 1
    end

    set -l list_file $argv[1]
    set -l target_dest_dir $argv[2] # This is purely the DESTINATION now
    
    # 3. Validate Inputs
    if not test -f "$list_file"
        echo $RED"Error: List file '$list_file' not found."$CLEAR
        return 1
    end

    if not test -d "$target_dest_dir"
        echo $RED"Error: Target directory '$target_dest_dir' not found."$CLEAR
        return 1
    end

    # Get absolute path of destination to ensure safety
    set -l abs_dest_dir (realpath "$target_dest_dir")
    
    # Initialize list
    set -l paths_to_move

    # 4. Parse the list file
    echo "Processing list..."
    
    # Use cat and while read loop
    cat "$list_file" | while read -l line
        # Skip empty/comments
        if test -z "$line"; or string match -q "#*" "$line"
            continue
        end

        set -l source_path ""

        # --- KEY CHANGE HERE ---
        # Logic: If path starts with /, use it as is.
        # Otherwise, look for it in the CURRENT directory ($PWD), NOT the target directory.
        if string match -q "/*" "$line"
            set source_path "$line"
        else
            set source_path "$PWD/$line"
        end

        # Validate existence
        if test -e "$source_path"
             set source_path (realpath "$source_path")
             
             # Safety Check: Don't move if source IS the destination
             if test "$source_path" = "$abs_dest_dir"
                 echo $YELLOW"⚠️  Skipping: Source is same as destination: $source_path"$CLEAR
             else
                 set -a paths_to_move "$source_path"
             end
        else
             echo $YELLOW"⚠️  Warning: Source path not found, skipping: $source_path"$CLEAR
        end
    end

    # 5. Check if empty
    if test (count $paths_to_move) -eq 0
        echo $YELLOW"No valid directories found to move."$CLEAR
        return 0
    end

    # 6. Summary and Confirmation
    echo ""
    echo $RED$BOLD"The following directories will be moved to: $abs_dest_dir"$CLEAR
    echo "----------------------------------------------------"
    for p in $paths_to_move
        # Check for name collision in destination before moving
        set -l dirname (basename "$p")
        if test -e "$abs_dest_dir/$dirname"
            echo $YELLOW"$p -> [WARNING: '$dirname' already exists in target]"$CLEAR
        else
            echo "$p"
        end
    end
    echo "----------------------------------------------------"
    
    read -l -P "Are you sure you want to proceed? [y/N] " confirm

    if test "$confirm" = "y"; or test "$confirm" = "Y"
        echo ""
        for dir in $paths_to_move
            set -l dirname (basename "$dir")
            
            # Final check to prevent overwriting without warning
            if test -e "$abs_dest_dir/$dirname"
                echo $RED"Skipping '$dirname': Destination already exists."$CLEAR
            else
                echo "Moving: $dir ..."
                mv "$dir" "$abs_dest_dir"
            end
        end
        echo $GREEN"Done."$CLEAR
    else
        echo $YELLOW"Operation cancelled."$CLEAR
    end
end

# Executing the function if script is run directly
mv_data_from_list $argv
