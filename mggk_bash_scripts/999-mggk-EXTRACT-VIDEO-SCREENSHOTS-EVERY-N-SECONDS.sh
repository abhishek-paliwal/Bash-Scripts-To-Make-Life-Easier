#!/bin/bash

##################################################################################
## SOME VARIABLES (CHANGE THE DIR IF NEEDED)
WORKDIR="$HOME_WINDOWS/Desktop/Y" ;
##################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ###############################################################################
  ## IF YOU CHOOSE OPTION 1 WHEN ASKED FOR USER INPUT => 
  ## THIS PROGRAM EXTRACTS VIDEO THUMBNAIL SCREENSHOTS FROM
  ## ALL mkv OR mp4 FILES PRESENT IN $WORKDIR, AND SAVES THEM TO PROPER SUBDIRECTORIES.
  ## AFTER THIS STEP, YOU NEED TO MOVE THE RELEVANT STEPS IMAGES INTO THE STEP-XX SUBFOLDERS.
  ####
  ## IF YOU CHOOSE OPTION 2 WHEN ASKED FOR USER INPUT => 
  ## THIS PROGRAM RENAMES STEP IMAGES SEQUENTIALLY, ACCORDING
  ## TO THE STEP DIRECTORY THEY ARE PRESENT IN. MAKE SURE THAT STEP-XX DIRECTORIES
  ## ARE NOT EMPTY.
  ###############################################################################
  ## Coded by: PALI
  ## On: October 13, 2020
  ###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
echo; echo ">> Working directory: $WORKDIR" ;
echo; echo "  >> Following mkv and mp4 files for processing ..." ;
ls *.mkv
ls *.mp4 

##################################################################################
##
function step1_video_thumbnails_extraction () {
    for x in $(find $WORKDIR/ -type f \( -name '*.mp4' -o -name '*.mkv' \)) ; do 
        x_name=$(echo $(basename $x) | sed 's+\.mkv++g'  | sed 's+\.mp4++g' ) ; 
        echo "=> CURRENT FILE UNDER PROCESSING: $x_name" ;
        dir_thumbs="${x_name}-thumbs" ; 
        mkdir $dir_thumbs ; 
        ## Making 8 subdirectories
        for y in $(seq 1 8); do 
            mkdir $dir_thumbs/${x_name}-step-$y ; 
        done; 
        ## Finally running ffmpeg magic to extract screenshots
        ffmpeg -i $x -vf fps=1/2 $dir_thumbs/${x_name}_thumb%3d.jpg ; 
    done
}

##
function step2_rename_steps_thumbnails () {
    for x in $(find $WORKDIR/ -type f \( -name '*.mp4' -o -name '*.mkv' \)) ; do 
        x_name=$(echo $(basename $x) | sed 's+\.mkv++g'  | sed 's+\.mp4++g' ) ; 
        dir_thumbs="${x_name}-thumbs" ; 
        echo "=> CURRENT FILE UNDER PROCESSING: $dir_thumbs" ;
        ## Renaming images in all found subdirectories
        for y in $(seq 1 8); do 
            mkdir $dir_thumbs/${x_name}-step-$y ; 
        done; 
        ## Finally running ffmpeg magic to extract screenshots
        ffmpeg -i $x -vf fps=1/2 $dir_thumbs/${x_name}_thumb%3d.jpg ; 
    done
}
##################################################################################
#step1_video_thumbnails_extraction
step2_rename_steps_thumbnails
#parentdir="$(dirname "$dir")"

for x in $(find $WORKDIR/ -type d); do echo $(basename $x) ; done
