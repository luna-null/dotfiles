#!/bin/bash
# Reduce mp4 to 480i resolution and reduce size considerably
# $1	input file
# $2	output file
# $3	target size
# $4	bitrate
target_size_mb="$3"
target_size=$(( $target_size_mb * 1000 * 1000 * 8 ))
length=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$1"`
length_round_up=$(( ${length%.*} + 1 ))
total_bitrate=$(( $target_size / $length_round_up ))
audio_bitrate=$(( $4 * 1000 )) # 128k bit rate
video_bitrate=$(( $total_bitrate - $audio_bitrate ))

[ ! "$1" ] && {
echo -e "Error!! No filename given."; exit 1; } || echo -e "Searching for $1"
ffmpeg -i "$1" -s hd720 -strict -2  -b:v $video_bitrate -maxrate:v $video_bitrate -bufsize:v $(( $target_size / 20 )) -b:a $audio_bitrate "$2"


# ffmpeg -i INPUT_FILE.MP4 -vf "fps=16,scale=160:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=64[p];[s1][p]paletteuse=dither=bayer" -loop 0 OUTPUT_FILE.GIF

# ffmpeg -y -i input.mp4 -filter_complex "fps=5,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=32[p];[s1][p]paletteuse=dither=bayer" output.gif
