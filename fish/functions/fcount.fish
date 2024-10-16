# Get the count of files
# Usage: fcount <path>
#
function fcount_help
  echo "Usage: fcount [DIRECTORY]"
  echo ""
  echo "Counts the number of files recursively in the specified DIRECTORY."
  echo "If no DIRECTORY is provided, it counts files in the current directory."
  echo ""
  echo "Options:"
  echo "  -h, --help    Show this help message and exit."
end

function fcount
  if test (count $argv) -eq 1
    if test $argv[1] = "--help" -o $argv[1] = "-h"
      fcount_help
      return 1
    end
  end

  if test (count $argv) -eq 0
    set abs_path (realpath .)
  else if test (count $argv) -eq 1
    set abs_path (realpath $argv)
  else
    echo $RED"Too many arguments"$CLEAR
    fcount_help
    return 1
  end

  set file_count (find $argv -type f | xargs ls | wc -l)
  echo -e $GREENB"$file_count files "$CLEAR"in $abs_path"
end

