#!/bin/bash
################################################################################
## THIS SCRIPT JOINS MP3 FILES FOUND IN PWD, USING FFMPEG
################################################################################

###########################################################
## MAIN FUNCTION DEFINITION
FUNC_PRINT_DIVIDER_AND_ASK_FOR_CONFIRMATION_TO_PROCEED () {
    echo; echo "####===========================================================####" ;
    read -p ">>>>>>>> If everything is okay so far, then press ENTER key to continue ..." ;
    echo ;
}
###########################################################

echo "################################################################################" ; 
WORKING_DIR="$(pwd)" ; 
echo ">> PRESENT WORKING DIR = $WORKING_DIR" ; 
echo ">> ARE YOU IN THE DIRECTORY WHERE THE MP3 FILES ARE PRESENT? IF yes, then ..." ;
echo "################################################################################" ; 

TMPLIST_FILE="$WORKING_DIR/_TMP_MP3_LIST_ALL.TXT" ; 
rm $TMPLIST_FILE ; ## if present already

## Listing mp3 files
for f in $(fd -e mp3 -e MP3 | sort -V) ;
    do
    echo "file '$f'" >> $TMPLIST_FILE ;
    done

##
echo ">> THESE mp3 FILES WILL BE JOINED IN THIS ORDER ..." ; 
cat  $TMPLIST_FILE ; 
## CALL FOR CONFIRMATION
FUNC_PRINT_DIVIDER_AND_ASK_FOR_CONFIRMATION_TO_PROCEED ; 

## FINALLY SOME FFMPEG CONCATENATE MAGIC, AND CREATING FINAL FILE
mkdir _TMP_DIR ;
how_many_mp3=$(fd -e mp3 -e MP3 | wc -l | sd ' ' '_') ; 
ffmpeg -f concat -safe 0 -i $TMPLIST_FILE -c copy _TMP_DIR/joined-$how_many_mp3-files-FULL-FINAL-AUDIO.mp3

