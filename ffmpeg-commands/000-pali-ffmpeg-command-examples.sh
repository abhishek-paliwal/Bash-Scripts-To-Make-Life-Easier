#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ##############################################
    ## FFMPEG VIDEO CONVERSION - Some Example Commands
    ##############################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


## Converting video to H264, and audio to mp3, keeping the same video resolution
## Simple command to convert using given codecs
ffmpeg -i input.mp4 -c:v libx264 -c:a copy output.mp4

## Command to convert using given codecs specifying CRF and compression preset
## CRF = Valid values from 0-53 -> 17-28 are best. 21-23 are most used for a good compression.
## Compression Presets: ultrafast, superfast, veryfast, faster, fast, medium (is default preset), slow, slower, veryslow
ffmpeg -i input.mp4 -c:v libx264 -preset medium -crf 22 -c:a copy output.mp4

## Only preset, but no CRF
ffmpeg -i input.mp4 -c:v libx264 -preset faster -c:a copy output.mp4

## Command to also know the time it took for ffmpeg to do its work. Time prints on the last line.
time ffmpeg -i input.mp4 -c:v libx264 -preset veryslow -c:a copy output.mp4
