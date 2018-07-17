#!/bin/bash
## FILENAME: 202-change-id3-tags-info-for-mp3.sh
## THIS PROGRAM CHANGES THE ID3 MUSIC TAGS OF AUDIO MP3 FILES THRU COMMAND LINE
## THIS PROGRAM USES 'MUTAGEN' PYTHON API TOOLS, AND SPECIFICALLY mid3v2 cli TOOL FROM MUTAGEN
###################################################
## Installing Mutagen Tools on OSX = Run 'sudo pip install mutagen' in OS X.
## See full tutorial here: http://mutagen.readthedocs.io/en/latest/man/mid3v2.html
## Created: Tuesday July 17, 2018
## By: Pali
###################################################

## Starting in the present working directory
MAIN_DIR=`pwd` ;
echo ; echo "Working directory: $MAIN_DIR" ;
cd $MAIN_DIR ;

echo ;
echo "LIST OF ALL FILES IN THIS DIRECTORY: " ;
echo "======================================= " ;
ls -1 ; # Listing all files in pwd
echo "======================================= " ;
echo ;

## Reading user input from command line
read -p "[1] Enter ARTIST name : " name_artist
read -p "[2] Enter ALBUM name : " name_album
read -p "[3] Enter COVER JPG/PNG Filename with extension (COVER FILE SHOULD BE IN SAME FOLDER) : " name_cover

## REAL MAGIC BEGINS: BY LOOPING THRU ALL MP3s
for x in *.mp3;
do
    ## Viewing exising tags on original song
    echo "CURRENT FILE INFO: " ;
    echo "-------------------" ;
    mutagen-inspect $x ;

    # Extracting filename by converting original filename to title case and removing all the strange characters with hyphens, then spaces
    new_songname=`echo "$x" | awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1' | sed -e 's/[{}\,! ()\-\+]/_/g' | sed -e 's/__*/-/g' | tr "-" " " | sed -e 's/\.mp3//g'`
    printf '%s' " //// $new_songname ////" ;

    ## Now deleting all exising tags (basic clean up step)
    mid3v2 --delete-all $x ;

    ## Now adding and applying all tags with info provided
    mid3v2 --song="$new_songname" --artist="$name_artist Artist" --album="$name_album Album" --comment="Background Music" --picture="$name_cover" --year="2018" --genre="Background Music Genre" $x ;

    ## Viewing modified tags on song
    mutagen-inspect $x ;

    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;
    echo "#### ID3 c h a n g e  d o n e  for: $x ####" ;
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;
    echo ;

done

## Opening working DIRECTORY
open $MAIN_DIR ;

####################################################
############### PROGRAM ENDS #######################
