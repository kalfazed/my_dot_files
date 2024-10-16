# Get the count of folder
# Usage: dcount <path>
#
function dcount_help
  echo "Usage: dcount [DIRECTORY]"
  echo ""
  echo "Counts the number of folder in the specified DIRECTORY."
  echo "If no DIRECTORY is provided, it counts files in the current directory."
  echo ""
  echo "Options:"
  echo "  -h, --help    Show this help message and exit."
end

function dcount
  if test (count $argv) -eq 1
    if test $argv[1] = "--help" -o $argv[1] = "-h"
      dcount_help
      return
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

  set dir_count (find $argv -maxdepth 1 -type d ! -name "."| wc -l)
  echo -e $GREENB"$dir_count directories "$CLEAR"in $abs_path"
end
