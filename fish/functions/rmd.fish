# Remove files and directories by name recursivly from current directory
# Usage: rmd <file/dir name> [<file/dir name> ...]
#
function rmd_help 
  echo "Usage: rmd [FILE/DIRECTORY] [FILE/DIRECTORY] ..."
  echo ""
  echo "Recursively removes files or directories by name from the current directory."
  echo "Multiple names can be specified. Before remove, it will list the matched files and directories."
  echo ""
  echo "Options:"
  echo "  -h, --help    Show this help message and exit."
end

function rmd
  if test (count $argv) -eq 1
    if test $argv[1] = "--help" -o $argv[1] = "-h"
      rmd_help
      return 1
    end
  end

  # Check if at least one name is provided
  if test (count $argv) -eq 0
    echo $RED"At least one file or directory name must be provided."$CLEAR
    rmd_help
    return 1
  end

  set items_found 0
  set items_list ""

  # Find and print paths of specified files and directories
  for name in $argv
    # Find directories and files
    set matches (find . -name $name)
    if test "$matches" != ""
        # Print each matched item on a new line
        for match in $matches
            echo "$match"
            set items_found 1
            set items_list $items_list $match
        end
    end
  end

  if test "$items_found" -eq 1
      # Confirm before removing items
      echo -e $RED"Do you want to remove the listed files/directories? (y/n):" $CLEAR
      read -l confirmation

      if test "$confirmation" = "y"
          # Remove specified files and directories in the current directory and its subdirectories
          for item in $items_list
              rm -rf $item
          end
          echo "Files and directories removed successfully."
      else
          echo "Removal canceled."
      end
  else 
      echo "No matched files or directories found"
  end
end


