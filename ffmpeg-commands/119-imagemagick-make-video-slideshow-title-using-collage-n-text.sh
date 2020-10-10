#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ##############################################################################
    ## THIS PROGRAM USES IMAGEMAGICK TO CREATE A SLIDESHOW TITLE SLIDE FROM
    ## IMAGES IN PRESENT WORKING DIRECTORY, USING TWO LINES OF TEXT AND
    ## FIRST 8 IMAGES PRESENT IN THAT FOLDER (WIDE IMAGES WORK BEST)
    ##########################################
    ## IMPORTANT NOTE:
    ## All the image names should start with lowercase 'a', such as a101.jpg, a102.jpg, etc.
    ##########################################
    ## MADE BY: PALI
    ## CRAFTED ON: Sunday October 14, 2018
    ##############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
PWD=`pwd` ;
echo "Present working directory: $pwd" ; echo ;

cd $PWD ;

## CREATING TMP DIRECTORY TO DO ALL MAGIC, AND TO SAVE ORIGINAL FILES AS SUCH
mkdir _TMP_COLLAGECOVER_DIR;
cp *.* _TMP_COLLAGECOVER_DIR/;
cd _TMP_COLLAGECOVER_DIR ;

######################################################

# LISTING ALL IMAGES, ONE PER LINE
allimages=`ls -1 *.*g | sort -n ` ;

echo "All valid images in $PWD: " ;
echo -e "$allimages" ; echo ;

echo "#################################################" ;

##############################################################################
echo "ENTER TEXT FOR LINE 1 (WILL APPEAR AT TOP) [Enter hyphens where you want line breaks to appear]: " ;
read textline1 ;

echo "ENTER TEXT FOR LINE 2 (WILL APPEAR AT BOTTOM) [Enter hyphens where you want line breaks to appear]: " ;
read textline2 ;

echo "Enter WIDTH for title slide in px (eg. 1920, 1280, 3840, etc.): " ;
read width ;

echo "Enter HEIGHT for title slide in px (eg. 1080, 720, 2160, etc.): " ;
read height ;

############################################
## SOME CALCULATIONS FOR TEXT PORTIONS HEIGHTS
percentageheightline1="20" ; ## 15% width for top text
percentageheightline2="25" ; ## 20% width for bottom text
percentageheightcollage="55" ; ## 65% width of collage (altogether 100% total)

heightline1=$(echo "$height*$percentageheightline1/100 " | bc -l ) ;
heightline2=$(echo "$height*$percentageheightline2/100 " | bc -l ) ;

heightcollage=$(echo "$height*$percentageheightcollage/100 " | bc -l ) ;
##############################################################################

## Now generating random HEX colors for title
#random_color_background=`echo "#$(openssl rand -hex 3)"` ;
random_color_background="white" ;
#random_color_text="white" ;
random_color_text=`echo "#$(openssl rand -hex 3)"` ;

echo "  Chosen random_color_background=$random_color_background" ;
echo "  Chosen random_color_text=$random_color_text" ;
##############################################################################
##############################################################################

## REAL MAGIC HAPPENS BELOW
sep="x" ;

############################################
## OPERATING ON LINE 1
echo ;
echo "======> LINE 1 = $textline1" ;
textline1_new=`echo $textline1 | sed -e 's/-/\\\\n/g' ` ; ##Imagemagick needs '\\\\n' to enter \n
echo "TEXTLINE1_NEW: $textline1_new " ;

convert -background $random_color_background -fill $random_color_text -font "$HOME/Library/Fonts/SketchRockwell-Bold.ttf" -size $width$sep$heightline1 -gravity center label:"$textline1_new" __TITLE_line1.jpg

echo "======>   IMAGEMAGICK: TITLE SLIDE PORTION CREATED for LINE 1 " ;
############################################

## OPERATING ON LINE 2
echo ;
echo "======> LINE 2 = $textline2" ;
textline2_new=`echo $textline2 | sed -e 's/-/\\\\n/g' ` ; ##Imagemagick needs '\\\\n' to enter \n
echo "TEXTLINE2_NEW: $textline2_new " ;

convert -background $random_color_background -fill \#c0c0c0 -font "$HOME/Library/Fonts/ambroise-francois-regular.otf" -size $width$sep$heightline2 -gravity center label:"$textline2_new" __TITLE_line2.jpg

echo "======>   IMAGEMAGICK: TITLE SLIDE PORTION CREATED for LINE 2 " ;
############################################

## CREATING COLLAGE USING FIRST 8 IMAGES
echo;
widthcollageblock=$(echo "$width/4" | bc -l ) ;
heightcollageblock=$(echo "$heightcollage/2" | bc -l ) ;

images4collage=$(ls -1 a*.*g | head -8) ;

montage $images4collage -background white -tile 4x2 -geometry $widthcollageblock$sep$heightcollageblock+5+5 __TITLE_collage.jpg

echo "======>  IMAGEMAGICK: TITLE SLIDE COLLAGE CREATED" ;
############################################

## CREATING FINAL MONTAGE USING ALL THE PORTIONS
montage __TITLE_line1.jpg __TITLE_collage.jpg __TITLE_line2.jpg -background $random_color_background -tile 1x3 -mode concatenate -gravity center __FINAL_COLLAGE.jpg
##############################################################################

echo; echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>< <<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;
echo "IN CASE OF ANY ERRORS, MAKE SURE THAT:" ;
echo "      1. All the image names should start with lowercase 'a', such as a101.jpg, a102.jpg, etc." ;
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>< <<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ; echo ;

######################################################
echo "Now opening $PWD" ;
open $PWD ;
