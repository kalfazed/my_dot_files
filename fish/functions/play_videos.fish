function play_videos
# Play all .mp4 files in the given folder using VLC.
# Files are sorted by name.
#
# Usage:
#   play_videos folder_name

  set dir $argv[1]
  find $dir -type f -iname "*.mp4" | sort | xargs vlc
end

