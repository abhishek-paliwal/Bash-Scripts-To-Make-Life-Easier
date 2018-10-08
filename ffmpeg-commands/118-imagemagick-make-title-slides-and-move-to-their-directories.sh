#!/bin/bash
######################################################
## THIS PROGRAM LISTS ALL FOLDERS IN PWD, AND THEN
## BASED UPON THEIR NAMES, CREATES A TITLE SLIDE USING
## IMAGEMAGICK AND THEN MOVES THEM TO THEIR RESPECTIVE
## FOLDERS
## MADE BY: PALI
## CRAFTED ON: Saturday September 15, 2018
######################################################

PWD=`pwd` ;
echo "Present working directory: $pwd" ; echo ;

cd $PWD ;

######################################################

# LISTING ALL FOLDERS, ONE PER LINE
titles=`ls -d1 */ | sort -n | sed -e 's/\///g' ` ;

echo "All valid folders in PWD: " ;
echo -e "$titles" ; echo ;

echo "#################################################" ;

## Now generating random HEX colors for title
random_color_background=`echo "#$(openssl rand -hex 3)"` ;
random_color_text="white" ;

echo "  Chosen random_color_background=$random_color_background" ;
echo "  Chosen random_color_text=$random_color_text" ;

while read line; do

    echo "======> LINE READ: $line" ;
    line_new=`echo $line | sed -e 's/-/\\\\n/g' ` ; ##Imagemagick needs '\\\\n' to enter \n
    echo "LINE_NEW: $line_new " ;

    convert -background $random_color_background -fill $random_color_text -font "$HOME/Library/Fonts/Sortdecai Brush Script.otf" -size 1920x1080 -gravity center label:"$line_new" __TITLE_$line.jpg

    echo "  IMAGEMAGICK: TITLE SLIDE CREATED for: $line" ;
    echo ;

done <<< "$titles"

echo; echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>< <<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;
echo "IN CASE OF ANY ERRORS, MAKE SURE THAT:" ;
echo "      1. All folder names have no spaces, and the words are separated by hyphens." ;
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>< <<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ; echo ;

######################################################
echo "Now opening $PWD" ;
open $PWD ;
