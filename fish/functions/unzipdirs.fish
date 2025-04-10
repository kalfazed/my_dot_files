# Unzip multiple zip files into directories with the same name as the zip files
# Usage: unzipdirs [ZIPFILE] [ZIPFILE] ...
#
function unzipdirs
  for zip in $argv
    7z x $zip -o(basename $zip .zip)
  end
end

