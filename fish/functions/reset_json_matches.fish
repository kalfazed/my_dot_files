function reset_json_matches
    if test (count $argv) -lt 2
        echo "Usage: reset_json_matches <pattern1> <pattern2> ... <directory>"
        return 1
    end

    set dir $argv[-1]
    set patterns $argv[1..-2]

    if not test -d "$dir"
        echo "Error: '$dir' is not a directory."
        return 1
    end

    set matches

    for pat in $patterns
        set found (find -L "$dir" -name "$pat" 2>/dev/null)
        if test -n "$found"
            set matches $matches $found
        end
    end

    if test (count $matches) -eq 0
        echo "No matches found for patterns in '$dir'."
        return 0
    end

    echo "Matched JSON files:"
    for f in $matches
        echo $f
    end

    read -l -P "Do you want to reset these JSON files to '[]'? (y/n) " confirmation
    if test "$confirmation" != "y"
        echo "Reset cancelled."
        return 0
    end

    for file in $matches
        if not string match -q "*.json" -- (basename $file)
            echo "Skipping non-JSON file: $file"
            continue
        end

        # Force reset regardless of file content
        echo "[]" > $file
    end

    echo "JSON files have been force-reset to empty array."
end

