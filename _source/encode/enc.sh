#!/bin/bash
# Background loops: 1920x1082 @60, Figma fade baked in (16-bit mask), seamless loop (tail crossfades into head).
# Outputs <name>.mp4 (H.264 8-bit, plays everywhere) and <name>.av1.mp4 (AV1 10-bit, ~35% smaller, used when decodable).
# Demo: clean 1920x1080 @60 H.264 for the Play demo modal.
set -e
cd "$(dirname "$0")"
OUT=out; mkdir -p $OUT
U=/mnt/user-data/uploads
X=0.75
enc(){ # $1 source  $2 name
  local D; D=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$1")
  local OFF; OFF=$(python3 -c "print(round($D-2*$X-0.05,3))")
  echo "== $2 D=$D off=$OFF $(date +%T)"
  ffmpeg -v error -y -i "$1" -loop 1 -i mask16.png -filter_complex "\
[0:v]fps=60,scale=1920:1082:flags=lanczos,split[m0][h0];\
[m0]trim=start=$X,setpts=PTS-STARTPTS[main];[h0]trim=end=$X,setpts=PTS-STARTPTS[head];\
[main][head]xfade=transition=fade:duration=$X:offset=$OFF,format=gbrp16le[v];\
[1:v]format=gbrp16le[m];[v][m]blend=all_mode=multiply:shortest=1,split[a][b];\
[a]format=yuv420p[h];[b]format=yuv420p10le[o]" \
    -map "[h]" -an -c:v libx264 -preset slow -crf 23 -profile:v high -maxrate 8M -bufsize 16M -g 120 -keyint_min 60 -movflags +faststart $OUT/$2.mp4 \
    -map "[o]" -an -c:v libsvtav1 -preset 7 -crf 35 -g 120 -svtav1-params tune=0 -movflags +faststart $OUT/$2.av1.mp4 2>&1 | grep -v '^Svt' || true
  ffmpeg -v error -y -i $OUT/$2.mp4 -frames:v 1 -q:v 3 $OUT/p_$2.jpg
  ffmpeg -v error -y -i "$1" -vf "fps=60,scale=1920:1080:flags=lanczos,format=yuv420p" -an -c:v libx264 -preset slow -crf 21 -profile:v high -maxrate 10M -bufsize 20M -g 120 -movflags +faststart $OUT/demo_$2.mp4
  ls -la $OUT/*$2*
}
enc $U/CleanShot_2026-11-11_at_01_18_49.mp4 titan
enc $U/CleanShot_2026-11-11_at_02_39_41-converted.mp4 district
enc $U/CleanShot_2026-11-11_at_02_50_09.mp4 mystic
enc $U/CleanShot_2026-11-11_at_02_57_52.mp4 wildjohn
echo ALLDONE $(date +%T)
