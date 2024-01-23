#!/bin/bash

THIS_SCRIPT_NAME=$(basename $0) ;
THIS_SCRIPT_NAME_WITHOUT_EXTENSION=$(echo $THIS_SCRIPT_NAME | sed 's/.sh//g') ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## THIS SCRIPT READS ALL .jpg IMAGES IN THE WORKING DIRECTORY AND
    ## CREATES VARIOUS VERSIONS WITH DIFFERENT RATIOS AND DIMENSIONS AND
    ## SAVES THEM TO A TEMPORARY OUTPUT DIRECTORY WITH PREFIXES.
    ######################################### 
    ## THIS SCRIPT USES imagemagick / mogrify / convert commands on CLI.
    ## IT CREATES THE FINAL IMAGE BY COMPOSITING ONE IMAGE OVER ANOTHER BY BLURRING
    ## THE BOTTOM IMAGE.
    ################################################################################
    ## CREATED ON: 2020-09-15
    ## CREATED BY: PALI
    ################################################################################
    ## USAGE:
    #### bash $THIS_SCRIPT_NAME
    ################################################################################
    ## >>>> Important note: >>>>
    ## Don't put any images directly in $HOME_WINDOWS/Desktop/Y. Instead make
    ## a sub-directory and put images there. Any other directory is OKAY.
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################
#PWD=$(pwd) ;
##
PWD="$HOME_WINDOWS/Desktop/_LROOM" ;
cd $PWD ;
##
echo; echo ">>>> Present working directory: $PWD" ;
echo; echo "##------------------------------------------------------------------------------" ;
echo ">>>> IMPORTANT NOTE:" ; 
echo "##------------------------------------------------------------------------------" ;
echo "=> Don't put any images directly in $HOME_WINDOWS/Desktop/Y "
echo "=> Put all your images in => $PWD. It's because while processing, the program will also read the temporary folders thus created, and throw errors." ;
echo "##------------------------------------------------------------------------------" ;

################################################################################
## SETTING SOME VARIABLES
IMAGEDIR="$PWD" ;
WORKINGDIR="$HOME_WINDOWS/Desktop/Y"
TMP_OUTPUT_DIR="$WORKINGDIR/_tmp_output_$THIS_SCRIPT_NAME_WITHOUT_EXTENSION" ;
TMP_OUTPUT_DIR_FINAL="$WORKINGDIR/_tmp_final_COMPOSITE_output_$THIS_SCRIPT_NAME_WITHOUT_EXTENSION" ;
TMP_OUTPUT_DIR_FINAL_CENTERCROPPED="$WORKINGDIR/_tmp_final_CENTERCROPPED_output_$THIS_SCRIPT_NAME_WITHOUT_EXTENSION" ;

################################################################################
echo ">>>> Following images found in $PWD. These Images will be read for further processing ..." ;
echo;
ls $IMAGEDIR | nl; 
echo; 

## User confirmation to continue
read -p "CAUTION: If PWD is correct, then please press ENTER to continue ..." ;
echo ">>>>>>>>>>>>>>>>> GOOD TO GO ... >>>>>>>>>>>>>>>>>>>>" ;
################################################################################

## Creating output directories
echo ">>>> Creating temporary output directories ..." ;
mkdir $TMP_OUTPUT_DIR $TMP_OUTPUT_DIR_FINAL $TMP_OUTPUT_DIR_FINAL_CENTERCROPPED ;

##################################################################################
## DEFINING MAIN FUNCTION WHICH WILL DO ALL MAGIC
function CREATE_IMAGE_TO_GIVEN_RATIO_AND_DIMENSIONS () {

    myimage="$1" ;
    myratio="$2" ;
    mydimensions="$3" ;
    
    image_original="$IMAGEDIR/$myimage" ;
    image_step0="$TMP_OUTPUT_DIR/$myimage"
    image_step1="$TMP_OUTPUT_DIR/blurred_$myimage"
    image_stepFinal="$TMP_OUTPUT_DIR_FINAL/$myratio-$myimage" 

    image_stepCenterCropped_tmp="$TMP_OUTPUT_DIR_FINAL_CENTERCROPPED/_tmp_$myratio-$myimage"
    image_stepCenterCropped="$TMP_OUTPUT_DIR_FINAL_CENTERCROPPED/$myratio-$myimage"
    
    ##------------------------------------------------------------------------------
    ## STEP 0 = creating a copy of original image to fit in given dimensions (unforced)
    magick $image_original -resize $mydimensions $image_step0

    ## STEP 1 = creating blurred image from original, for the background image.
    convert $image_original -blur 0x7 $image_step1

    ## STEP 2 = resizing images to 1x1 dimensions (forced on both dimensions // notice the exclamation sign)
    magick $image_step1 -resize $mydimensions! $image_step1

    ## STEP 3 = compositing step0 image over blurred image
    magick composite -gravity center $image_step0 $image_step1 $image_stepFinal ;

    ##------------------------------------------------------------------------------
    ## EXTRA STEP = Resizing and Center cropping the image without compositing ##
    ## => In this step, big images will be made smaller, and smaller images will be enlarged ##
    ## => For that, smaller dimension will be considered always (notice the ^ sign) ##
    convert $image_original -resize $mydimensions^ -gravity center -extent $mydimensions $image_stepCenterCropped
    ##------------------------------------------------------------------------------

    ## FINAL MESSAGE PRINTING ON CLI.
    echo "  // Image saved // Ratio = $myratio // Dimensions = $mydimensions" ;
    echo "  // Composite image saved = $(basename $image_stepFinal)" ;
    echo "  // Center-Cropped image saved = $(basename $image_stepCenterCropped)" ;
    #echo "  // Next step: Please move this new image to proper $myratio directory." ;
    echo;
}

##------------------------------------------------------------------------------
## PROCESSING IMAGES ONE BY ONE AND SAVING IN DIFFERENT RATIOS AND DIMENSIONS
echo;
## BEGIN: FOR LOOP ##
COUNT=1;
TOTAL_IMAGES=$(ls $IMAGEDIR/ | wc -l) ;
for this_image in $(ls $IMAGEDIR/) ;
do 
    echo "Reading this image ($COUNT of $TOTAL_IMAGES) => $this_image"; 
    ## Calling the function with its parameters
    CREATE_IMAGE_TO_GIVEN_RATIO_AND_DIMENSIONS "$this_image" "1x1" "1200x1200" ;
    CREATE_IMAGE_TO_GIVEN_RATIO_AND_DIMENSIONS "$this_image" "4x3" "1200x800" ;
    CREATE_IMAGE_TO_GIVEN_RATIO_AND_DIMENSIONS "$this_image" "16x9" "1200x675" ;
    
    ## Updating the running counter
    COUNT=$((COUNT+1))
done
## END: FOR LOOP ##
##------------------------------------------------------------------------------
 

################################################################################
## SHOWING THE DISPLAY MESSAGE FOR THE CHOSEN IMAGE Upload directory DEPENDING UPON
## WHETHER THIS PROGRAM IS RUN BY WHICH USER (Mac or Windows WSL)
################################################################################

echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
if [ $USER = "ubuntu" ]; then
    DIR_TO_UPLOAD="$DIR_GITHUB/2020-LEELA-RECIPES/static/rich-markup-images" ;
    echo "USER = $USER // USER is ubuntu on WSL. Hence, you will need to move images to this directory: $DIR_TO_UPLOAD" ;
else
    DIR_TO_UPLOAD="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/wp-content/rich-markup-images" ;
    echo "USER = $USER // USER is NOT ubuntu on WSL. Hence, you will need to move images to this directory: $DIR_TO_UPLOAD" ;
fi
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
###### 
## DISPLAYING THE COMMANDS TO COPY-PASTE BY THE USER
echo;
echo "=========================== TO DO THIS => Move all the chosen 1x1, 4x3, 16x9 images to $IMAGEDIR" ;
echo "=========================== Then Copy-paste the following commands to move all images to corresponding hugo directory" ;
echo;    
echo "mv $IMAGEDIR/1x1*.jpg $DIR_TO_UPLOAD/1x1/" ;
echo "mv $IMAGEDIR/4x3*.jpg $DIR_TO_UPLOAD/4x3/" ;
echo "mv $IMAGEDIR/16x9*.jpg $DIR_TO_UPLOAD/16x9/" ;
echo "mv $IMAGEDIR/*.jpg $DIR_TO_UPLOAD/original_copied/" ;
echo ;

## VERY IMPORTANT MESSAGE
echo;
echo "################################################################################" ;
echo "###################### VERY IMPORTANT MESSAGE ##################################" ;
echo "################################################################################" ;
echo "=> 1. Before running this program, MAKE VERY SURE that the input images have been renamed based upon the URL of the page on which they will be published under Guided Recipes." ;
echo "=> 2. As an example, if the URL is https://www.YOURSITE.com/this-is-page-url/ , then the input image should be renamed as this-is-page-url.jpg, before running this program." ;   
echo "################################################################################" ;
echo "################################################################################" ;
