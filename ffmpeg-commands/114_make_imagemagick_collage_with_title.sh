#!/bin/bash
########################################################################################
# THIS PROGRAM USES IMAGEMAGICK TO CREATE A TITLE AFTER READING INPUTS FROM COMMAND LINE
# THEN, CREATES A COLALGE USING ALL THE IMAGES IN THE FOLDER
# CREATED BY: PALI
# CREATED ON: Thursday August 2, 2018
########################################################################################

PWD=`pwd`;
echo "Current parent directory: $PWD" ;

## CREATING TMP DIRECTORY TO DO ALL MAGIC, AND TO SAVE ORIGINAL FILES AS SUCH
mkdir _TMP_COLLAGE_DIR;
cp *.* _TMP_COLLAGE_DIR/ ;
cd _TMP_COLLAGE_DIR ;

NEW_PWD=`pwd` ;
echo "CURRENT COLLAGE WORKING DIRECTORY: $NEW_PWD" ;

## PRINTING ALL IMAGES DIMENSIONS OF FINAL FILE
echo; echo "Printing all image sizes (sorted from small to big):";
identify -format "%wx%h : %f\n" *.* | sort -r | nl ;

## NOW PRINTING THE DIMENSIONS OF ALL IMAGES WITH HOW MANY IMAGES THEY CORRESPOND
echo; echo "Now printing the dimensions of all images with how many images they correspond to: ";
identify -format "%wx%h\n" *.* | sort -nr > _TMP_LIST.TXT ;
cat _TMP_LIST.TXT | sort -n | uniq -c | sort -k2nr ;


NEW_LINE_VAR="\\\\\\\\n" ; ## THIS WILL PRINT OUT \\n
echo; echo "USE THIS FOR NEW LINES: $NEW_LINE_VAR" ;

echo "ENTER THE TITLE OF THE COLLAGE [ use $NEW_LINE_VAR for new-lines ]: " ;
echo ; echo "(NOTE: KEEP IT EMPTY IF YOU DON'T WANT ANY TITLE SLIDE) " ;
echo ;
read collage_title ;

echo "ENTER THE DIMENSIONS OF THE TITLE AND EACH IMAGE IN COLLAGE AS WxH [eg., 1920x1080]: " ;
echo ;
read collage_dimensions ;

echo "ENTER THE TILE VALUE AS ROWSxCOLUMNS [eg., 4x5]: " ;
echo ;
read tile_value ;

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
touch 0_my_collage*
rm 0_my_collage*

## STEP 1: MAKING TITLE IF TITLE VARIABLE TEXT IS NOT EMPTY.
if [ -z "$collage_title" ]
then
      echo "\$collage_title is empty." ;
else
      echo "\$collage_title is NOT empty.";
      convert -background "$random_color_background" -fill "$random_color_text" -font /Users/abhishek/Library/Fonts/BebasNeue\ Book.ttf -size "$collage_dimensions" -gravity east label:"$collage_title" 0_my_collage_title.jpg ;
fi

echo ; echo "CURRENT FILES IN DIRECTORY: "
ls -1 *.*g | nl ## chooses all the png/jpg images

## STEP 2: Using IMAGEMAGICK to resize ALL images to Full-HD with padding to keep FULL-HD aspect ratio
echo "=======> ImageMagick currently resizing all images to $collage_dimensions ...."
mogrify -resize $collage_dimensions -background black -gravity center -extent $collage_dimensions *
echo "=======> ImageMagick resizing done ...."

## STEP 3: MAKING COLLAGE USING ALL IMAGES IN PWD
echo ; echo "Now creating collage ....."
montage *.*g -tile $tile_value -geometry $collage_dimensions+5+5 0_my_collage.jpg

## RENAMING COLLAGE FILE BASED UPON title
FINAL_FILENAME=`echo "$collage_title-collage" | sed 's/\\\\n/-/g' | sed 's/ /-/g'` ;
cp 0_my_collage.jpg $FINAL_FILENAME.jpg ;

## PRINTING ALL IMAGES DIMENSIONS OF FINAL FILE
echo; echo "==========> DIMENSIONS OF THE PRODUCED COLLAGE: ";
identify -format "%wx%h : %f\n" $FINAL_FILENAME.jpg ;

echo; echo "Collage has been made. Now opening working directory"; echo ;
open .

########################################################################################
