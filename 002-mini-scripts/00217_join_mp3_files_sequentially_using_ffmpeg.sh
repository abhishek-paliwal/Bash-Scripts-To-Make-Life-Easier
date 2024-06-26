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
cat -n $TMPLIST_FILE ; 
## CALL FOR CONFIRMATION
FUNC_PRINT_DIVIDER_AND_ASK_FOR_CONFIRMATION_TO_PROCEED ; 

## FINALLY SOME FFMPEG CONCATENATE MAGIC, AND CREATING FINAL FILE
mkdir _TMP_DIR ;
how_many_mp3=$(fd -e mp3 -e MP3 | wc -l | sd ' ' '_') ; 
mp3_outfile="_TMP_DIR/joined-${how_many_mp3}-files-FULL-FINAL-AUDIO.mp3" ; 
ffmpeg -f concat -safe 0 -i $TMPLIST_FILE -c copy "$mp3_outfile" ; 
echo;
echo ">> FINAL MP3 FILE CREATED = $mp3_outfile" ;
echo;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## COPY MP3 FILE TO DIR Y (ALSO RENAME), ONLY IF NAMEFILE EXISTS TO RENAME NEW MP3 FILE EXISTS IN DIR Y
NAMEFILE_FOR_MP3="$DIR_Y/_tmp00_filename_for_mp3.txt" ;
if [ -f "$NAMEFILE_FOR_MP3" ] ; then
    echo ">> NAMEFILE EXISTS ALREADY IN DIR Y (=> $NAMEFILE_FOR_MP3), SO USING IT FOR MP3 RENAMING ..." ;
    echo ">> COPYING MP3 FILE TO DIR Y (ALSO RENAMING) ..." ;
    MP3_NEWNAME0=$(head -1 $NAMEFILE_FOR_MP3) ;
    # Example text found in NAMEFILE_FOR_MP3 : _FINAL_CLEANED_SSML_BOOK_SERIALNUM_975_XX_man_chaahi_santaan.md.ssml
    # Remove '_FINAL_CLEANED_SSML_' and '.md.ssml' from name
    MP3_NEWNAME=$(echo "$MP3_NEWNAME0" | sd '_FINAL_CLEANED_SSML_' '' | sd '.md.ssml' '') ;
    cp "$mp3_outfile" "$DIR_Y/$MP3_NEWNAME.mp3" ;
fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

