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
        # Verify it ends in .json
        if not string match -q "*.json" -- (basename $file)
            echo "Skipping non-JSON file: $file"
            continue
        end

        # Validate it's actually a JSON array or empty
        set content (cat $file 2>/dev/null)
        if test -z "$content" -o "$content" = "[]" -o "$content" = "{}"
            # Okay to reset
            echo "[]" > $file
        else
            # Try to parse it using jq (if available)
            if type -q jq
                jq . $file > /dev/null 2>&1
                if test $status -eq 0
                    echo "[]" > $file
                else
                    echo "⚠️ Invalid JSON, skipping: $file"
                end
            else
                echo "jq not available; cannot validate JSON: $file"
                echo "Skipping: $file"
            end
        end
    end

    echo "JSON files have been reset to empty array."
end

