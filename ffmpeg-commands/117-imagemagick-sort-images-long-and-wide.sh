#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ########################################################################################
    # THIS PROGRAM USES IMAGEMAGICK TO SORT AND RENAME IMAGE FILES
    # BASED UPON THEIR DIMESIONS AS WIDE AND LONG
    # CREATED BY: PALI
    # CREATED ON: Thursday SEPTEMBER 5, 2018
    ########################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
PWD=`pwd`;
echo "Current parent directory: $PWD" ;

## Define keywords to raname files with, so that it would be easier to change just these later
WIDE_KWRD="0_wide_" ;
LONG_KWRD="1_long_" ;
SQUARE_KWRD="2_square_" ;

## CREATING TMP DIRECTORY TO DO ALL MAGIC, AND TO SAVE ORIGINAL FILES AS SUCH
mkdir _TMP_WIDELONG_DIR;
cp *.* _TMP_WIDELONG_DIR/ ;
cd _TMP_WIDELONG_DIR ;

NEW_PWD=`pwd` ;
echo "CURRENT COLLAGE WORKING DIRECTORY: $NEW_PWD" ;

## PRINTING ALL IMAGES DIMENSIONS OF FINAL FILE
echo; echo "Printing all image sizes (sorted from small to big):";
identify -format "%wx%h : %f\n" *.* | sort -r | nl ;

#!/bin/bash
for img in *.*g
do
    width=`identify -format %w $img`  ;
    height=`identify -format %h $img`  ;

    width=`echo $width | bc` ;
    height=`echo $height | bc` ;

    echo; echo "FILENAME: $img // width: $width px // height: $height px " ;

    if [ "$width" -gt "$height" ] ; then echo "$img: WIDE IMAGE RENAMED. " ; mv $img $WIDE_KWRD$img ; fi
    if [ "$width" -lt "$height" ] ; then echo "$img: LONG IMAGE RENAMED. " ; mv $img $LONG_KWRD$img ; fi
    if [ "$width" -eq "$height" ] ; then echo "$img: SQUARE IMAGE RENAMED. " ; mv $img $SQUARE_KWRD$img ; fi

done

## MAKE 3 DIRECTORIES FOR LONG, WIDE AND SQUARE IMAGES
mkdir 0w 1l 2s;

## MOVING FILES TO JUST MADE DIRECTORIES
mv $WIDE_KWRD* 0w/ ;
mv $LONG_KWRD* 1l/ ;
mv $SQUARE_KWRD* 2s/ ;
echo "All files moved to their respective directories"


echo; echo "Images have been renamed. Now opening working directory"; echo ;
open .

########################################################################################
