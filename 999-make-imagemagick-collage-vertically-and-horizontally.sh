#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USAGE FOR BASH 
## Print this help as >> this_script_name --help
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ######################################################
    ## THIS PROGRAM MAKES TWO COLLAGES BY CONCATENATING IMAGES
    ## IN PRESENT WORKING DIRECTORY USING IMAGEMAGICK.
    ## ONE COLLAGE IS VERTICAL, AND ONE HORIZONTAL.
    ######################################################
    ## MADE ON: Friday OCTOBER 5, 2018
    ## MADE BY: PALI
    ######################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


echo "THIS PROGRAM MAKES TWO COLLAGES FROM COMMAND LINE INPUTS USING IMAGEMAGICK" ; echo ;

PWD=$(pwd);
TMP_DIR="_TMP_COLLAGE_DIR_CONCATENATE" ;

cd $PWD ;
echo "Current working directory: $PWD " ;

mkdir $TMP_DIR ;
echo "DONE: Temporary directory made = $TMP_DIR " ;

#######################################################
echo "LIST OF IMAGES TO USE FOR COLLAGE: " ;
ls -1 *.*g | nl ;
#######################################################

echo "Enter collage block WIDTH or HEIGHT (in px): " ;
read WIDTH ;

echo "Enter collage block PADDING (in px): " ;
read PADDING ;

NUMBER0=$(ls -1 *.*g | wc -l) ;
NUMBER=$(echo $NUMBER0 | bc -l ) ;
echo "TOTAL NUMBER of images to use for collage: $NUMBER" ;

#######################################################
## REAL MAGIC HAPPENS BELOW

echo; echo "========> MAKING 4 COLLAGES...." ;
sep="x" ;
one="1" ;

###########################
echo "MAKING HORIZONTAL COLLAGES ..." ;
mkdir _TMP_RESIZE_DIR1 ; mogrify -path _TMP_RESIZE_DIR1/ -resize $sep$WIDTH *.*g ;

montage _TMP_RESIZE_DIR1/*.*g -tile $NUMBER$sep$one -mode concatenate $TMP_DIR/1a_HORZ_COLLAGE.jpg ;
montage _TMP_RESIZE_DIR1/*.*g -tile $NUMBER$sep$one -mode concatenate -geometry ^$sep$WIDTH+$PADDING+$PADDING $TMP_DIR/1b_HORZ_COLLAGE_EQUAL_WIDTH.jpg ;

echo "COMMAND USED: montage _TMP_RESIZE_DIR1/*.*g -tile $NUMBER$sep$one -mode concatenate -geometry $sep$WIDTH+$PADDING+$PADDING $TMP_DIR/1b_HORZ_COLLAGE_EQUAL_WIDTH.jpg " ;
###########################

###########################
echo; echo "MAKING VERTICAL COLLAGES ..." ;
mkdir _TMP_RESIZE_DIR2 ; mogrify -path _TMP_RESIZE_DIR2/ -resize $WIDTH$sep *.*g ;

montage _TMP_RESIZE_DIR2/*.*g -tile $one$sep$NUMBER -mode concatenate $TMP_DIR/2a_VERT_COLLAGE.jpg ;
montage _TMP_RESIZE_DIR2/*.*g -tile $one$sep$NUMBER -mode concatenate -geometry $WIDTH$sep+$PADDING+$PADDING $TMP_DIR/2b_VERT_COLLAGE_EQUAL_HEIGHT.jpg ;

echo; echo "COMMAND USED: montage _TMP_RESIZE_DIR2/*.*g -tile $one$sep$NUMBER -mode concatenate -geometry $WIDTH$sep+$PADDING+$PADDING $TMP_DIR/2b_VERT_COLLAGE_EQUAL_HEIGHT.jpg " ;
###########################


#######################################################
echo;
echo "IN CASE OF ERRORS: =========> " ;
echo "1. Make sure that the filename starts with a alphabet, such as a101.jpg/png, etc." ;


#######################################################
echo; echo "Opening $PWD " ;
open $PWD ;
