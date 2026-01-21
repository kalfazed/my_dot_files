function dcount_help
    echo "Usage: dcount [DIRECTORY...]"
    echo ""
    echo "Counts the number of immediate sub-directories in the specified DIRECTORY(s)."
    echo "If no DIRECTORY is provided, it counts directories in the current path."
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message and exit."
end

function dcount
    # 1. Check for help arguments
    if contains -- -h $argv; or contains -- --help $argv
        dcount_help
        return 0
    end

    # 2. Determine targets
    # If no arguments, target is current dir "."; otherwise, use all provided arguments
    set -l targets
    if test (count $argv) -eq 0
        set targets .
    else
        set targets $argv
    end

    set -l total_count 0

    # 3. Loop through each target directory
    for target in $targets
        # Check if directory exists
        if not test -d $target
            echo $RED"Error: '$target' is not a directory"$CLEAR
            continue
        end

        set -l abs_path (realpath $target)

        # 4. Count directories
        # -mindepth 1: Excludes the directory itself from the count
        # -maxdepth 1: Only looks at immediate subfolders (does not go recursive)
        set -l dir_count (find $target -mindepth 1 -maxdepth 1 -type d | wc -l)
        
        # Print result for current directory
        echo -e $GREENB"$dir_count directories "$CLEAR"in $abs_path"
        
        # Add to total
        set total_count (math $total_count + $dir_count)
    end

    # 5. Show total if multiple directories were scanned
    if test (count $targets) -gt 1
        echo "----------------------------------------"
        echo -e $GREENB"Total: $total_count directories"$CLEAR
    end
end
