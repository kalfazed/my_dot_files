function rmd
    # Check if at least one directory name is provided
    if test (count $argv) -eq 0
        echo "Usage: remove_directories <directory1> [<directory2> ...]"
        return 1
    end

    set directory_found 0
    # Find and print the directory paths of specified directories
    for dir in $argv
        set match (find . -type d -name $dir -print)
        if test "$match" != ""
          find . -type d -name $dir -print
          set directory_found 1
        end
    end

    if test "$directory_found" -eq 1
      # Confirm before removing directories
      echo -e $RED"Do you want to remove the listed directories? (y/n):" $CLEAR

      read -l confirmation

      if test "$confirmation" = "y"
          # Find and remove specified directories in the current directory and its subdirectories
          for dir in $argv
              find . -type d -name $dir -exec rm -rf {} +
          end

          echo "Directories removed successfully."
      else
          echo "Removal canceled."
      end
    else 
      echo -e $GREEN"No matched directory found" $CLEAR
    end
end


