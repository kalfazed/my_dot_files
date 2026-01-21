function fcount_help
    echo "Usage: fcount [DIRECTORY...]"
    echo ""
    echo "Counts the number of files recursively in the specified DIRECTORY(s)."
    echo "If no DIRECTORY is provided, it counts files in the current directory."
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message and exit."
end

function fcount
    # 1. Check for help arguments
    if contains -- -h $argv; or contains -- --help $argv
        fcount_help
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
        
        # 4. Count files (Optimized: removed 'xargs ls', direct pipe to wc -l is safer/faster)
        set -l file_count (find $target -type f | wc -l)
        
        # Print result for current directory
        echo -e $GREENB"$file_count files "$CLEAR"in $abs_path"
        
        # Add to total
        set total_count (math $total_count + $file_count)
    end

    # 5. Show total if multiple directories were scanned
    if test (count $targets) -gt 1
        echo "----------------------------------------"
        echo -e $GREENB"Total: $total_count files"$CLEAR
    end
end
