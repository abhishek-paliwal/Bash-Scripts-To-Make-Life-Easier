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
  ## MAKE SURE THE VIDEOS ARE NAMED WITH THEIR CORRESPONDING MGGK URL.
  ## AFTER THIS STEP, YOU NEED TO MOVE THE RELEVANT STEPS IMAGES INTO THE STEP-XX SUBFOLDERS. THEN RUN STEP 2.
  ###########################################
  ## IF YOU CHOOSE OPTION 2 WHEN ASKED FOR USER INPUT => 
  ## THIS PROGRAM RENAMES STEP IMAGES SEQUENTIALLY, ACCORDING
  ## TO THE STEP DIRECTORY THEY ARE PRESENT IN. MAKE SURE THAT STEP-XX DIRECTORIES
  ## ARE NOT EMPTY.
  #### For renaming, it uses the 'rename' command. If your system does not have it ...
  #### Install rename command using homebrew by running > brew install raname 
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
        ## Finally running ffmpeg magic to extract screenshots
        ffmpeg -i $x -vf fps=1/2 $dir_thumbs/${x_name}_thumb%3d.jpg ; 
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
##################################################################################

## CALLING THE FUNCTIONS, DEPENDING UPON THE OPTION CHOSEN BY THE USER
echo; echo; 
echo "What do you want to do? Select your option =======>
1) FUNCTION_step1_video_thumbnails_extraction
2) FUNCTION_step2_rename_steps_thumbnails
" ;

echo "Enter your choice (1/2): " ;
read which_function_to_run

if [ "$which_function_to_run" == "1" ]; then
    echo ">> Your chosen step is: $which_function_to_run" ;
    echo ">> Hence, this will run => FUNCTION_step1_video_thumbnails_extraction" ;
    FUNCTION_step1_video_thumbnails_extraction ;
elif [ "$which_function_to_run" == "2" ]; then
    echo ">> Your chosen step is: $which_function_to_run" ;
    echo ">> Hence, this will run => FUNCTION_step2_rename_steps_thumbnails" ;
    FUNCTION_step2_rename_steps_thumbnails ;
else 
    echo ">> Your chosen step is INVALID = $which_function_to_run // TRY AGAIN." ;
fi
##################################################################################
