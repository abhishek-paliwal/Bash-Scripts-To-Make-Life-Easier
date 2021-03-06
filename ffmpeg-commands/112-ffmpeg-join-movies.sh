#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ## THIS BASH FILE CONCATENATES THE VIDEO FILES, ALL MP4 FILES PRESENT IN A DIRECTORY.
    ## BEORE RUNNING THIS, MAKE SURE THAT THE MP4 FILES ARE CORRECTLY ENCODED BY ADOBE ENCODER, ALL WITH THE SAME SPECS
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################

PWD=`pwd` ;
cd $PWD ;

## Define variables for directories
INPUT_RAW="1_INPUT_RAW";
INPUT_FFMPEG_ENCODED="2_INPUT_FFMPEG_ENCODED";
OUTPUT="3_OUTPUT_FFMPEG";
TMP_FILE="tmp_filenames.txt"
NAME_FOR_FILE=$(basename $PWD) ;

## Deleting filenames if exists
rm $FILENAMES

## Creating required directories
mkdir $INPUT_RAW ## Directory for outputs. Create if not exists.
mkdir $INPUT_FFMPEG_ENCODED ## Directory for outputs. Create if not exists.
mkdir $OUTPUT ## Directory for outputs. Create if not exists.

## First move all mp4 files to raw files directory, if files are not correctly placed.
mv *.mp4 $INPUT_RAW/

## Loop begins over all movie files, in our case all MP4 files
for i in $INPUT_RAW/*.mp4 ; do
    echo "file '$i'" >> $TMP_FILE
done

## ACTUAL FFMPEG COMMAND RUNS BELOW, and concatenates all files in reading order
ffmpeg -f concat -i $TMP_FILE -c copy $OUTPUT/$NAME_FOR_FILE.mp4

## Open the working Directory
open $PWD
