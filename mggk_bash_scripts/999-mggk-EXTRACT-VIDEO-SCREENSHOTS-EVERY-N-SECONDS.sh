#!/bin/bash

##################################################################################
## SOME VARIABLES (CHANGE THE DIRs IF NEEDED)
WORKDIR="$HOME_WINDOWS/Desktop/Y" ;
DIR_WHICH_YOUTUBE_VIDEOS="/home/ubuntu/GitHub/2020-LEELA-RECIPES/content" ;
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
  ## MAKE SURE THE VIDEOS ARE NAMED WITH THEIR CORRESPONDING MGGK URL.
  ## AFTER THIS STEP, YOU NEED TO MOVE THE RELEVANT STEPS IMAGES INTO THE STEP-XX SUBFOLDERS. THEN RUN STEP 2.
  ###########################################
  ## IF YOU CHOOSE OPTION 2 WHEN ASKED FOR USER INPUT => 
  ## THIS PROGRAM RENAMES STEP IMAGES SEQUENTIALLY, ACCORDING
  ## TO THE STEP DIRECTORY THEY ARE PRESENT IN. MAKE SURE THAT STEP-XX DIRECTORIES
  ## ARE NOT EMPTY.
  #### For renaming, it uses the 'rename' command. If your system does not have it ...
  #### Install rename command using homebrew by running > brew install raname 
  ###########################################
  ## IF YOU CHOOSE OPTION 3 WHEN ASKED FOR USER INPUT => 
  ## THIS PROGRAM DOWNLOADS ALL VIDEOS FROM YOUTUBE FOUND IN AN ALREADY SPECIFIED DIRECTORY.
  ## CURRENT SPECIFIED DIRECTORY = $DIR_WHICH_YOUTUBE_VIDEOS
  ## IF NEEDED, CHANGE SPECIFIED DIRECTORY BY CHANGING THIS
  ## VARIABLE => \$DIR_WHICH_YOUTUBE_VIDEOS.
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
echo; echo ">> Following mkv and mp4 files for processing ..." ;
ls *.mkv
ls *.mp4 

##################################################################################
##
function FUNCTION_step1_video_thumbnails_extraction () {
    echo; echo "RUNNING STEP 1 = Thumbnails extraction from Video ... " ; echo; 
    for x in $(find $WORKDIR/ -type f \( -name '*.mp4' -o -name '*.mkv' \)) ; do 
        x_name=$(echo $(basename $x) | sed 's+\.mkv++g'  | sed 's+\.mp4++g' ) ; 
        echo "=> CURRENT FILE UNDER PROCESSING: $x_name" ;
        dir_thumbs="${x_name}-thumbs" ; 
        mkdir $dir_thumbs ; 
        ## Making 8 subdirectories
        for y in $(seq 1 8); do 
            mkdir $dir_thumbs/${x_name}-step-$y ; 
        done; 
        ## Finally running ffmpeg magic to extract 1 frame every 1/3 second(s) of video
        ## (eg. fps=2, 1/2, 1/30, 1/60 for every 0.5, 2, 30, and 60 seconds respectively)
        ffmpeg -i $x -vf fps=3 $dir_thumbs/${x_name}_thumb%4d.jpg ; 
    done
}

##
function FUNCTION_step2_rename_steps_thumbnails () {
    echo; echo "RUNNING STEP 2 = Copying + Renaming Thubnails in Step subdirectories ..." ; echo; 
    for thisDir in $(find $WORKDIR/ -type d -name "*step*"); do 
    ##---------------------------------------------------------------------
    echo; echo; echo ">>> PROCESSING THIS DIRECTORY => $thisDir" ;

    ## Getting the parent directory of this subdirectory
    parentDir=$(dirname "$thisDir") ;

    ## Getting the parent directory of this subdirectory + removing some text
    parentDir_to_create_tmp=$(basename $parentDir | sed 's/\-thumbs//g') ;
    parentDir_to_create=$WORKDIR/$parentDir_to_create_tmp ;

    echo " >> CREATING THIS DIRECTORY NOW => $parentDir_to_create" ;
    mkdir $parentDir_to_create ;

    ## First renaming all files by removing spaces, using rename command
    ## Install rename command using homebrew by running > brew install raname
    find $thisDir -type f -name "*.jpg" | rename 's/ /_/g' ; 
    ##
    COUNT=1;
    for thisImage in $(find $thisDir -type f -name "*.jpg" | sort) ; do 
        newImage="$(basename $thisDir)-$COUNT.jpg" ;
        echo; 
        echo "COPYING ... '$thisImage' => $parentDir_to_create/$newImage" ; 
        cp "$thisImage" $parentDir_to_create/$newImage ;
        ((COUNT++));
    done
    ##--------------------------------------------------------------------
    done
}
##
function FUNCTION_step3_download_videos_using_youtube-dl_program () {
    echo "RUNNING STEP 3 = Downloading + Renaming Videos in chosen DIR_WHICH_YOUTUBE_VIDEOS = $DIR_WHICH_YOUTUBE_VIDEOS ..." ; echo; 
    for mymdfile in $(grep -irl 'youtube_video_id:' $DIR_WHICH_YOUTUBE_VIDEOS/ ) ; do 
        ## Extracting url without slashes to use for filename later
        url_var=$(grep -irh 'url:' $mymdfile | tr -d ' ' | sed 's/url://g' | sed 's+/++g') ;
        ## Extracting youtube video id without quotes
        youtube_id=$(grep -irh 'youtube_video_id:' $mymdfile | tr -d ' ' | sed 's/youtube_video_id://g' | sed 's+/++g' | sed 's+"++g') ;
        ## PRINTING
        echo; echo "YOUTUBE_ID = $youtube_id // URL_VAR= $url_var" ;
        ## DOWNLOADING YOUTUBE VIDEO USING youtube-dl program
        youtube-dl --id $youtube_id ;
        ## RENAMING YOUTUBE VIDEO WITH URL_VAR
        mv $youtube_id.mkv  $url_var.mkv ;
        mv $youtube_id.mp4  $url_var.mp4 ;
        echo; echo ">> VIDEO FILE RENAMED AS // IF MKV => $url_var.mkv // IF MP4 => $url_var.mp4" ; 
    done 
}
##################################################################################

## CALLING THE FUNCTIONS, DEPENDING UPON THE OPTION CHOSEN BY THE USER
echo; echo; 
echo "What do you want to do? Select your option =======>
1) FUNCTION_step1_video_thumbnails_extraction
2) FUNCTION_step2_rename_steps_thumbnails
3) FUNCTION_step3_download_videos_using_youtube-dl_program (from this DIR = $DIR_WHICH_YOUTUBE_VIDEOS)
" ;

echo "Enter your choice (1/2/3): " ;
read which_function_to_run

if [ "$which_function_to_run" == "1" ]; then
    echo ">> Your chosen step is: $which_function_to_run" ;
    echo ">> Hence, this will run => FUNCTION_step1_video_thumbnails_extraction" ;
    FUNCTION_step1_video_thumbnails_extraction ;
elif [ "$which_function_to_run" == "2" ]; then
    echo ">> Your chosen step is: $which_function_to_run" ;
    echo ">> Hence, this will run => FUNCTION_step2_rename_steps_thumbnails" ;
    FUNCTION_step2_rename_steps_thumbnails ;
elif [ "$which_function_to_run" == "3" ]; then
    echo ">> Your chosen step is: $which_function_to_run" ;
    echo ">> Hence, this will run => FUNCTION_step3_download_videos_using_youtube-dl_program" ;
    FUNCTION_step3_download_videos_using_youtube-dl_program ;
else 
    echo ">> Your chosen step is INVALID = $which_function_to_run // TRY AGAIN." ;
fi
##################################################################################
