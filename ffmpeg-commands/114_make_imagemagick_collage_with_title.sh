#!/bin/bash
########################################################################################
# THIS PROGRAM USES IMAGEMAGICK TO CREATE A TITLE AFTER READING INPUTS FROM COMMAND LINE
# THEN, CREATES A COLALGE USING ALL THE IMAGES IN THE FOLDER
# CREATED BY: PALI
# CREATED ON: Thursday August 2, 2018
########################################################################################

NEW_LINE_VAR="\\\\\\\\n" ; ## THIS WILL PRINT OUT \\n
echo "USE THIS FOR NEW LINES: $NEW_LINE_VAR" ;

echo "ENTER THE TITLE OF THE COLLAGE [ use $NEW_LINE_VAR for new-lines ]: " ;
echo ;
read collage_title ;

echo "ENTER THE DIMENSIONS OF THE TITLE AND EACH IMAGE IN COLLAGE AS WxH [eg., 1920x1080]: " ;
echo ;
read collage_dimensions ;

echo ;
echo "collage_title: $collage_title" ;
echo "collage_dimensions: $collage_dimensions" ;
echo ;

## Now generating random HEX colors for title
random_color_background=`echo "#$(openssl rand -hex 3)"` ;
random_color_text=`echo "#$(openssl rand -hex 3)"`  ;

echo "Chosen random_color_background=$random_color_background" ;
echo "Chosen random_color_text=$random_color_text" ;


## Checking if files exists, and removing if exists:
touch _my_collage*
rm _my_collage*

## STEP 1: MAKING TITLE
convert -background "$random_color_background" -fill "$random_color_text" -font /Users/abhishek/Library/Fonts/BebasNeue\ Book.ttf -size "$collage_dimensions" -gravity east label:"$collage_title" _my_collage_title.jpg

echo ; echo "CURRENT FILES IN DIRECTORY: "
ls -1 *.*g | nl ## chooses all the png/jpg images

## STEP 2: Using IMAGEMAGICK to resize ALL images to Full-HD with padding to keep FULL-HD aspect ratio
echo "=======> ImageMagick currently resizing all images to $collage_dimensions ...."
mogrify -resize $collage_dimensions -background black -gravity center -extent $collage_dimensions *
echo "=======> ImageMagick resizing done ...."

## STEP 3: MAKING COLLAGE USING ALL IMAGES IN PWD
echo ; echo "Now creating collage ....."
montage *.*g -geometry $collage_dimensions+5+5 _my_collage.jpg

## RENAMING COLLAGE FILE BASED UPON title
FINAL_FILENAME=`echo $collage_title | sed 's/\\\\n/-/g' | sed 's/ /-/g'` ;
cp _my_collage.jpg $FINAL_FILENAME.jpg ;

echo "Collage has been made. Now opening working directory"; echo ;
open .

########################################################################################