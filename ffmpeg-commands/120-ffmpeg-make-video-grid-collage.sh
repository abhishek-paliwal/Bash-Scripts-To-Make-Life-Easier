#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## USAGE:
    #### > bash $THIS_SCRIPT_NAME
    ################################################################################
    ## This program makes video collages in 1920x1080 as 2x3, 3x2, 3x3 grid.
    ## It reads mp4 video files in working directory as inputs and renames them as
    ## 1.mp4, 2.mp4, 3.mp4, etc.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-12-06
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_CREATE_VIDEO_COLLAGE_3X3_LONG () {
inDir="$1" ;
## creating actual collage
ffmpeg -i $inDir/1.mp4 -i $inDir/2.mp4 -i $inDir/3.mp4 -i $inDir/4.mp4 -i $inDir/5.mp4 -i $inDir/6.mp4 -i $inDir/7.mp4 -i $inDir/8.mp4 -i $inDir/9.mp4 -filter_complex "nullsrc=size=1080x1920 [base];
    [0:v] setpts=PTS-STARTPTS, scale=360x640 [one];
    [1:v] setpts=PTS-STARTPTS, scale=360x640 [two];
    [2:v] setpts=PTS-STARTPTS, scale=360x640 [three];
    [3:v] setpts=PTS-STARTPTS, scale=360x640 [four];
    [4:v] setpts=PTS-STARTPTS, scale=360x640 [five];
    [5:v] setpts=PTS-STARTPTS, scale=360x640 [six];
    [6:v] setpts=PTS-STARTPTS, scale=360x640 [seven];
    [7:v] setpts=PTS-STARTPTS, scale=360x640 [eight];
    [8:v] setpts=PTS-STARTPTS, scale=360x640 [nine];
    [base][one] overlay=shortest=1:x=0:y=0 [tmp1];
    [tmp1][two] overlay=shortest=1:x=360:y=0 [tmp2];
    [tmp2][three] overlay=shortest=1:x=640:y=0 [tmp3];
    [tmp3][four] overlay=shortest=1:x=0:y=640 [tmp4];
    [tmp4][five] overlay=shortest=1:x=360:y=640 [tmp5];
    [tmp5][six] overlay=shortest=1:x=640:y=640 [tmp6];
    [tmp6][seven] overlay=shortest=1:x=0:y=1280 [tmp7];
    [tmp7][eight] overlay=shortest=1:x=360:y=1280 [tmp8];
    [tmp8][nine] overlay=shortest=1:x=640:y=1280" -c:v libx264 $inDir/_output_video_collage_1920x1080_3x3_LONG.mp4
}
########
function FUNC_CREATE_VIDEO_COLLAGE_3X3 () {
inDir="$1" ;
## creating actual collage
ffmpeg -i $inDir/1.mp4 -i $inDir/2.mp4 -i $inDir/3.mp4 -i $inDir/4.mp4 -i $inDir/5.mp4 -i $inDir/6.mp4 -i $inDir/7.mp4 -i $inDir/8.mp4 -i $inDir/9.mp4 -filter_complex "nullsrc=size=1920x1080 [base];
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
    [tmp8][nine] overlay=shortest=1:x=1280:y=720" -c:v libx264 $inDir/_output_video_collage_1920x1080_3x3.mp4
}
########
function FUNC_CREATE_VIDEO_COLLAGE_3X2 () {
inDir="$1" ;
## creating actual collage
ffmpeg -i $inDir/1.mp4 -i $inDir/2.mp4 -i $inDir/3.mp4 -i $inDir/4.mp4 -i $inDir/5.mp4 -i $inDir/6.mp4 -filter_complex "nullsrc=size=1920x1080 [base];
    [0:v] setpts=PTS-STARTPTS, scale=640x360 [one];
    [1:v] setpts=PTS-STARTPTS, scale=640x360 [two];
    [2:v] setpts=PTS-STARTPTS, scale=640x360 [three];
    [3:v] setpts=PTS-STARTPTS, scale=640x360 [four];
    [4:v] setpts=PTS-STARTPTS, scale=640x360 [five];
    [5:v] setpts=PTS-STARTPTS, scale=640x360 [six];
    [base][one] overlay=shortest=1:x=0:y=0 [tmp1];
    [tmp1][two] overlay=shortest=1:x=640:y=0 [tmp2];
    [tmp2][three] overlay=shortest=1:x=1280:y=0 [tmp3];
    [tmp3][four] overlay=shortest=1:x=0:y=360 [tmp4];
    [tmp4][five] overlay=shortest=1:x=640:y=360 [tmp5];
    [tmp5][six] overlay=shortest=1:x=1280:y=360" -c:v libx264 $inDir/_output_video_collage_1920x1080_3x2.mp4
}
########
function FUNC_CREATE_VIDEO_COLLAGE_2X2 () {
inDir="$1" ;
## creating actual collage
ffmpeg -i $inDir/1.mp4 -i $inDir/2.mp4 -i $inDir/3.mp4 -i $inDir/4.mp4 -filter_complex "nullsrc=size=1920x1080 [base];
    [0:v] setpts=PTS-STARTPTS, scale=960x540 [one];
    [1:v] setpts=PTS-STARTPTS, scale=960x540 [two];
    [2:v] setpts=PTS-STARTPTS, scale=960x540 [three];
    [3:v] setpts=PTS-STARTPTS, scale=960x540 [four];
    [base][one] overlay=shortest=1:x=0:y=0 [tmp1];
    [tmp1][two] overlay=shortest=1:x=960:y=0 [tmp2];
    [tmp2][three] overlay=shortest=1:x=0:y=540 [tmp3];
    [tmp3][four] overlay=shortest=1:x=960:y=540" -c:v libx264 $inDir/_output_video_collage_1920x1080_2x2.mp4
}

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Copying and then renaming all mp4 files to working dir
c=1; for x in *.mp4 ; do cp $x $WORKDIR/$c.mp4 ; ((c++)); done

## Calling all functions
FUNC_CREATE_VIDEO_COLLAGE_3X3_LONG "$WORKDIR" ;
FUNC_CREATE_VIDEO_COLLAGE_3X3 "$WORKDIR" ;
FUNC_CREATE_VIDEO_COLLAGE_3X2 "$WORKDIR" ;
FUNC_CREATE_VIDEO_COLLAGE_2X2 "$WORKDIR" ;