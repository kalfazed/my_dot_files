function remove_matches
    if test (count $argv) -lt 2
        echo "Usage: remove_matches <pattern1> <pattern2> ... <directory>"
        return 1
    end

    # Get the last argument as directory
    set dir $argv[-1]
    set patterns $argv[1..-2]

    if not test -d "$dir"
        echo "Error: '$dir' is not a directory."
        return 1
    end

    set matches

    for pat in $patterns
        # Find files for each pattern
        set found (find -L "$dir" -name "$pat" 2>/dev/null)
        if test -n "$found"
            set matches $matches $found
        end
    end

    if test (count $matches) -eq 0
        echo "No matches found for patterns in '$dir'."
        return 0
    end

    echo "Matched files and directories:"
    for f in $matches
        echo $f
    end

    read -l -P "Do you want to remove them? (y/n) " confirmation
    if test "$confirmation" = "y"
        for f in $matches
            rm -rf -- $f
        end
        echo "All matched files/directories have been removed."
    else
        echo "Removal cancelled."
    end
end

