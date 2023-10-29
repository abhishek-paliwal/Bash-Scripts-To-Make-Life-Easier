#!/bin/bash
## THIS PROGRAM RESIZES and REDUCES SIZE FOR ALL (png, jpg) IMAGES IN PWD TO 1200px wide dimensions for MGGK 

WORKDIR="$DIR_Y" ; 
echo ">> CURRENT WORKING DIRECTORY = $(pwd)" ;

################################################################################
function FUNC_IMAGE_RESIZE () {
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
    QUAL="$1" ;  
    echo ">> The images will be resized using imagemagick using QUAILTY = $QUAL" ...
    echo ">> IMPORTANT NOTE: These images will be resized IN PLACE (> 950 KB), meaning the original images WILL BE REPLACED ..."; 
    fd -t f -e png -e jpg -S +950k ; 
    echo ">> NOW RESIZING ... (if any images are still over 950 KB) ..." ; 
    fd -t f -e png -e jpg -S +950k -x convert {} -resize 1200x -quality $QUAL {} ; 
}
################################################################################

## CALLING FUNCTION FOR VARIOUS QUAILY SETTINGS

FUNC_IMAGE_RESIZE 90 
FUNC_IMAGE_RESIZE 85 
FUNC_IMAGE_RESIZE 80 
FUNC_IMAGE_RESIZE 75 
