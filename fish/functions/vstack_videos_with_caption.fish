function vstack_videos_with_caption
    if test (count $argv) -lt 2
        echo "Usage: vstack_videos_with_caption <video1> <video2> [caption1] [caption2] [output_name]"
        return 1
    end

    set video1 $argv[1]
    set video2 $argv[2]
    set caption1 (string escape -- $argv[3])
    set caption2 (string escape -- $argv[4])
    set output_name $argv[5]

    if test -z "$caption1"
        set caption1 "video1"
    end

    if test -z "$caption2"
        set caption2 "video2"
    end

    if test -z "$output_name"
        set output_name "output.mp4"
    end

    ffmpeg -i $video1 -i $video2 \
        -filter_complex "\
        [0:v]drawtext=text='$caption1':fontcolor=white:fontsize=24:box=1:boxcolor=black@0.5:x=10:y=10[v0]; \
        [1:v]drawtext=text='$caption2':fontcolor=white:fontsize=24:box=1:boxcolor=black@0.5:x=10:y=10[v1]; \
        [v0][v1]vstack=inputs=2[outv]" \
        -map "[outv]" -map "0:a?" -map "1:a?" \
        -c:v libx264 -crf 23 -preset veryfast -shortest \
        $output_name
end

