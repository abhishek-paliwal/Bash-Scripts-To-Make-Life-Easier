#!/bin/bash

function FUNC_CREATE_VIDEO_COLLAGE_3X3 () {
ffmpeg -i 1.mp4 -i 2.mp4 -i 3.mp4 -i 4.mp4 -i 5.mp4 -i 6.mp4 -i 7.mp4 -i 8.mp4 -i 9.mp4 -filter_complex "nullsrc=size=1920x1080 [base];
[0:v] setpts=PTS-STARTPTS, scale=640x360 [one];
[1:v] setpts=PTS-STARTPTS, scale=640x360 [two];
[2:v] setpts=PTS-STARTPTS, scale=640x360 [three];
[3:v] setpts=PTS-STARTPTS, scale=640x360 [four];
[4:v] setpts=PTS-STARTPTS, scale=640x360 [five];
[5:v] setpts=PTS-STARTPTS, scale=640x360 [six];
[6:v] setpts=PTS-STARTPTS, scale=640x360 [seven];
[7:v] setpts=PTS-STARTPTS, scale=640x360 [eight];
[8:v] setpts=PTS-STARTPTS, scale=640x360 [nine];
[base][one] overlay=shortest=1:x=0:y=0 [tmp1];
[tmp1][two] overlay=shortest=1:x=640:y=0 [tmp2];
[tmp2][three] overlay=shortest=1:x=1280:y=0 [tmp3];
[tmp3][four] overlay=shortest=1:x=0:y=360 [tmp4];
[tmp4][five] overlay=shortest=1:x=640:y=360 [tmp5];
[tmp5][six] overlay=shortest=1:x=1280:y=360 [tmp6];
[tmp6][seven] overlay=shortest=1:x=0:y=720 [tmp7];
[tmp7][eight] overlay=shortest=1:x=640:y=720 [tmp8];
[tmp8][nine] overlay=shortest=1:x=1280:y=720" -c:v libx264 _output_video_collage_1920x1080_3x3.mp4
}

FUNC_CREATE_VIDEO_COLLAGE_3X3