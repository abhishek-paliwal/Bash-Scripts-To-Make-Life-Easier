#!/bin/bash
########################################################################################
# THIS PROGRAM USES IMAGEMAGICK TO INSERT CUSTOM TEXT AS LABEL ONTO IMAGES,
# AFTER READING INPUTS FROM COMMAND LINE
# CREATED BY: PALI
# CREATED ON: Thursday August 15, 2018
########################################################################################

PWD=`pwd`;
echo "Current parent directory: $PWD" ;

## CREATING TMP DIRECTORY TO DO ALL MAGIC, AND TO SAVE ORIGINAL FILES AS SUCH
mkdir _TMP_LABELING_DIR;
cp *.* _TMP_LABELING_DIR/ ;
cd _TMP_LABELING_DIR ;

NEW_PWD=`pwd` ;
echo "CURRENT COLLAGE WORKING DIRECTORY: $NEW_PWD" ;

## PRINTING ALL IMAGES DIMENSIONS OF FINAL FILE
echo; echo "Printing all image sizes (sorted from small to big):";
identify -format "%wx%h : %f\n" *.* | sort -r ;

NEW_LINE_VAR="\\\\\\\\n" ; ## THIS WILL PRINT OUT \\n
echo; echo "USE THIS FOR NEW LINES: $NEW_LINE_VAR" ;

echo "ENTER THE LABEL TEXT TO PRINT ONTO EACH IMAGE: " ;
echo ;
read label_text ;

echo "ENTER THE FONT-SIZE OF THE LABEL [ as an integer > 16 ]: " ;
echo ;
read label_fontsize ;

echo ;
echo "label_text: $label_text" ;
echo "label_fontsize: $label_fontsize" ;
echo ;

## Now generating random HEX colors for title
random_color_background=`echo "#$(openssl rand -hex 3)"` ;
random_color_text=`echo "#$(openssl rand -hex 3)"`  ;

echo "Chosen random_color_background=$random_color_background" ;
echo "Chosen random_color_text=$random_color_text" ;

## LABELING ALL IMAGES, ONE BY ONE
for f in *.*g ; ## this will only take jpg, and png
    do
        convert $f -fill "$random_color_text" -undercolor "$random_color_background" -pointsize $label_fontsize -gravity Southwest -annotate +5+5 "\ $label_text " _labeled_$f ;
        echo "=======> DONE: Labeling completed for $f ...."
    done


echo ; echo "CURRENT FILES IN DIRECTORY: "
ls -1 *.*g | nl ## chooses all the png/jpg images

echo; echo "Labeling has been done for all images. Now opening current working directory"; echo ;
open .

########################################################################################
