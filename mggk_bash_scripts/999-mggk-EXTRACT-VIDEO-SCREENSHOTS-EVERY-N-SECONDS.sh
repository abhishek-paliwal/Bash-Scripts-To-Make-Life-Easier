#!/bin/bash

##################################################################################
## SOME VARIABLES (CHANGE THE DIRs IF NEEDED)
WORKDIR="$HOME_WINDOWS/Desktop/Y" ;
#DIR_WHICH_YOUTUBE_VIDEOS="$(pwd)" ;
DIR_WHICH_YOUTUBE_VIDEOS="$DIR_Y/f" ;
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
  ## ALL mkv OR mp4 OR webm FILES PRESENT IN $WORKDIR, AND SAVES THEM TO PROPER SUBDIRECTORIES. 
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
  ## IF YOU CHOOSE OPTION 0 WHEN ASKED FOR USER INPUT => 
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
echo "------------------------------------------------------" ;  
echo ">> Found following mkv files for processing ..." ;
echo "------------------------------------------------------" ;  
ls -1 *.mkv | nl
echo "------------------------------------------------------" ;  
echo ">> Found following mp4 files for processing ..." ;
echo "------------------------------------------------------" ;  
ls -1 *.mp4 | nl
echo "------------------------------------------------------" ;  
echo ">> Found following webm files for processing ..." ;
echo "------------------------------------------------------" ;  
ls -1 *.webm | nl

##################################################################################
##################################################################################
##
function FUNCTION_step1_video_thumbnails_extraction () {
    echo; echo "RUNNING STEP 1 = Thumbnails extraction from Video ... " ; echo; 
    for x in $(find $WORKDIR/ -type f \( -name '*.mp4' -o -name '*.mkv' -o -name '*.webm' -o -name '*.mov' -o -name '*.MOV' -o -name '*.MP4' -o -name '*.MKV' \)) ; do 
        x_name=$(echo $(basename $x) | sed 's+\.mkv++ig' | sed 's+\.mp4++ig' | sed 's+\.webm++ig' | sed 's+\.mov++ig'  ) ; 
        echo "=> CURRENT FILE UNDER PROCESSING: $x_name" ;
        dir_thumbs="${x_name}-thumbs" ; 
        mkdir $dir_thumbs ; 
        ## Making 8 subdirectories
        for y in $(seq 1 8); do 
            mkdir $dir_thumbs/${x_name}-step-$y ; 
        done; 
        ## Finally running ffmpeg magic to extract 1 frame every 1/3 second(s) of video
        ## (eg. fps=2, 1/2, 1/30, 1/60 for every 0.5, 2, 30, and 60 seconds respectively)
        ffmpeg -i $x -vf fps=3 $dir_thumbs/${x_name}_thumb%5d.jpg ; 
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
    ## Install rename command on MAC OS using homebrew by running > brew install raname
    ## Install rename command on Linux using by running > sudo apt-get install raname
    if [ $USER = "ubuntu" ]; then
        find $thisDir -type f -name "*.jpg" | /usr/bin/rename 's/ /_/g' ;
    else
        find $thisDir -type f -name "*.jpg" | rename 's/ /_/g' ; 
    fi

    ##
    COUNT=1;
    for thisImage in $(find $thisDir -type f -name "*.jpg" | sort -k 2n) ; do 
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

function FUNCTION_step0_list_youtube_videos_to_be_downloaded () {
    echo ">> LISTING YOUTUBE VIDEO IDs TO BE DOWNLOADED FROM THIS DIR => $DIR_WHICH_YOUTUBE_VIDEOS ..." ; echo; 
    tmpfile1="$1" ;
    ##
    echo > tmp0 ; 
    for mymdfile in $(grep -irl 'youtube_video_id:' $DIR_WHICH_YOUTUBE_VIDEOS/ ) ; do 
        ## Extracting url + video id
        url_var=$(grep -irh 'url:' $mymdfile | tr -d ' ' | sed 's/url://g' | sed 's+/++g') ;
        youtube_id=$(grep -irh 'youtube_video_id:' $mymdfile | tr -d ' ' | sed 's/youtube_video_id://g' | sed 's+/++g' | sed 's+"++g') ;
        ## Saving to txt file with semicolon as delimiter
        echo "$url_var;$youtube_id" | sed 's/ //g' >> tmp0
    done
    sort tmp0 | grep -v '^$' > $tmpfile1 ## deleting blank lines + sorting
    cat $tmpfile1 ; ## printing
}    

function FUNCTION_step0A_download_videos_using_youtube_dl_program () {
    echo ">> DOWNLOADING VIDEOS ONE BY ONE ..." ; echo; 
    tmpfile1="$1" ;
    tmpfile2="$2" ;
    tmpfile3="$3" ;
    ##
    echo > tmp1 ; 
    while IFS= read -r line
    do
        echo ">> CURRENT LINE: $line" ; echo; 
        ## Separating the fields using semicolon as delimiter
        url_var=$(echo $line | cut -d';' -f1) ;
        youtube_id=$(echo $line | cut -d';' -f2) ;
        ## DOWNLOADING YOUTUBE VIDEO USING youtube-dl program
        youtube-dl --id "https://youtu.be/$youtube_id" ;
        ## RENAMING YOUTUBE VIDEO WITH URL_VAR
        mv $youtube_id.mkv  $url_var.mkv ;
        mv $youtube_id.mp4  $url_var.mp4 ;
        mv $youtube_id.webm  $url_var.webm ;
        echo; 
        echo ">> VIDEO FILE RENAMED AS $url_var.(mkv|mp4|webm)" ; 
        ##
        ## Appending this to the videos successfully downloaded so far
        echo "$line" >> tmp1
        ## Listing all videos yet to be downloaded at this point
        sort $tmpfile1 | grep -v '^$' > tmp0 ; ## deleting blank lines + sorting
        sort tmp1 | grep -v '^$' > $tmpfile2 ; ## deleting blank lines + sorting
        diff tmp0 $tmpfile2 | grep '<' | sed 's/<//g' > $tmpfile3
        echo "========================================" ;
    done < "$tmpfile1"
}
##
##################################################################################
##################################################################################

## CALLING THE FUNCTIONS, DEPENDING UPON THE OPTION CHOSEN BY THE USER
echo; echo; 
echo "What do you want to do? Select your option =======>
1) FUNCTION_step1_video_thumbnails_extraction
2) FUNCTION_step2_rename_steps_thumbnails
3) FUNCTION_step0A_list_youtube_videos_to_be_downloaded (all videos from this DIR = $DIR_WHICH_YOUTUBE_VIDEOS)
4) FUNCTION_step0A_list_youtube_videos_to_be_downloaded (remaining videos)
" ;

echo "Enter your choice (1/2/3/4): " ;
read which_function_to_run

##################################################################################
if [ "$which_function_to_run" == "3" ]; then
    tmpfile1A="$WORKDIR/tmp_youtube_videos_ALL.txt" ;
    tmpfile2A="$WORKDIR/tmp_youtube_videos_DOWNLOADED_SO_FAR.txt" ;
    tmpfile3A="$WORKDIR/tmp_youtube_videos_NOT_DOWNLOADED_SO_FAR.txt" ;
    echo > $tmpfile1A ## initialize this file    
    echo > $tmpfile2A ## initialize this file
    echo > $tmpfile3A ## initialize this file
    ##
    FUNCTION_step0_list_youtube_videos_to_be_downloaded "$tmpfile1A" ;
    FUNCTION_step0A_download_videos_using_youtube_dl_program "$tmpfile1A" "$tmpfile2A" "$tmpfile3A" ;
elif [ "$which_function_to_run" == "4" ]; then
    tmpfile1B="$WORKDIR/tmp_youtube_videos_NOT_DOWNLOADED_SO_FAR.txt" ;
    tmpfile2B="$WORKDIR/tmp_youtube_videos_DOWNLOADED_SO_FAR_REMAINING.txt" ;
    tmpfile3B="$WORKDIR/tmp_youtube_videos_NOT_DOWNLOADED_SO_FAR_REMAINING.txt" ;
    #echo > $tmpfile1B ## DO NOT initialize this file    
    echo > $tmpfile2B ## initialize this file
    echo > $tmpfile3B ## initialize this file
    ##
    FUNCTION_step0A_download_videos_using_youtube_dl_program "$tmpfile1B" "$tmpfile2B" "$tmpfile3B" ;
elif [ "$which_function_to_run" == "1" ]; then
    FUNCTION_step1_video_thumbnails_extraction ;
elif [ "$which_function_to_run" == "2" ]; then
    FUNCTION_step2_rename_steps_thumbnails ;
else 
    echo ">> Your chosen step is INVALID = $which_function_to_run // TRY AGAIN." ;
fi
##################################################################################

