#/bin/bash

##------------------------------------------------------------------------------
## VARIABLES SET UP AND ARGUMENTS CHECKING
PROJECT_DIR="$1" ; 
DELETE_ORIGINAL_IMAGES="$2" ; 
DELETE_EXISTING_WATERMARKED_IMAGES="$3" ; 
##
PREFIX_WATERMARKED="WATERMARKED" ;
PREFIX_ORIGINAL="ORIGINAL" ;
##------------------------------------------------------------------------------

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## FUNCTION DEFINITIONS
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function PRINT_FUNC_SEPARATOR () {
    echo "##------------------------------------------------------------------------------" ;
    echo "// CURRENT FUNCTION => ${FUNCNAME[1]}" ; ## shows the current running function name
    echo ; 
}
########
function STEP0_FUNC_SET_DEFAULTS_IF_ARGUMENTS_ABSENT () {
    PRINT_FUNC_SEPARATOR ;
    ## SET DEFAULTS IF CLI ARGUMENTS ARE ABSENT
    if [ $# -eq 0 ] ; then 
        echo "No arguments supplied. Hence defaults will be set." ;
        PROJECT_DIR=$(pwd) ; 
        DIR_WATERMARKED="$PROJECT_DIR/_DIR_WATERMARKED" ;
        ## options=(delete_original_images_yes | delete_original_images_no)
        DELETE_ORIGINAL_IMAGES="delete_original_images_no" ; 
        ## options=(delete_watermarked_images_yes | delete_watermarked_images_no)
        DELETE_EXISTING_WATERMARKED_IMAGES="delete_watermarked_images_yes" ; 
    elif [ $# -lt 2 ] ; then 
        echo "ERROR NOTE: The program needs 3 arguments. Less than 3 supplied. Please correct and run again." ;
        exit 1 ; 
    fi
}
########
function STEP1_FUNC_CLEAN_EXISTING_WATERMARKED_IMAGES_IN_PROJECTDIR () {
    PRINT_FUNC_SEPARATOR ;
    if [ "$DELETE_EXISTING_WATERMARKED_IMAGES" == "delete_watermarked_images_yes" ]; then
        rm -rf "$DIR_WATERMARKED" ; 
    fi    
}
########
function STEP2_FUNC_WATERMARK_IMAGES_IN_PROJECTDIR () {
    PRINT_FUNC_SEPARATOR ;
    ## CREATE WATERMARK OUTPUT DIRECTORY
    mkdir -p "$DIR_WATERMARKED" ;
    ######################################
    FONT_TO_USE="$REPO_SCRIPTS/_fonts/Roboto_Condensed/RobotoCondensed-Bold.ttf" ; 
    FONTCOLOR="white" ; 
    ## Set gravity (possible values =  NorthWest, North, NorthEast, West, Center, East, SouthWest, South, SouthEast)
    GRAVITY_TEXT="Center" ;
    GRAVITY_DIRECTION="NorthWest" ; 
    ######################################
    COUNT=0; 
    for MYIMAGE in $PROJECT_DIR/*.jpg ; do
        ((COUNT++)) ;
        IMAGE_WIDTH_ORIGINAL=$(identify -format %w $MYIMAGE) ; 
        IMAGE_WIDTH=$(($IMAGE_WIDTH_ORIGINAL / 9)) ; ## 9 times lesser than width
        MYIMAGE_BASENAME="$(basename $MYIMAGE)" ; 
        MYIMAGE_NEW="$DIR_WATERMARKED/$PREFIX_WATERMARKED-$MYIMAGE_BASENAME" ;
        ## USING imagemagick tool TO CREATE NEW WATERMARKED IMAGES
        convert -background '#00000085' -fill "$FONTCOLOR" -font "$FONT_TO_USE" -gravity $GRAVITY_TEXT -size ${IMAGE_WIDTH}x${IMAGE_WIDTH} caption:"$COUNT" $MYIMAGE +swap -gravity "$GRAVITY_DIRECTION" -composite $MYIMAGE_NEW ;
        ##
        echo ">> SUCCESS => WATERMARKED IMAGE => $COUNT" ;
        echo "      IMAGE     = $MYIMAGE" ; 
        echo "      NEW_IMAGE = $MYIMAGE_NEW" ; 
    done 
}
########
function STEP3_FUNC_DELETE_ORIGINAL_IMAGES_AFTER_WATERMARKING () {
    PRINT_FUNC_SEPARATOR ;
    if [ "$DELETE_ORIGINAL_IMAGES" == "delete_original_images_yes" ]; then
        rm $PROJECT_DIR/ORIGINAL*.jpg ;
    else 
        echo; echo ">> NO ORIGINAL IMAGES DELETION NECESSARY." ;       
    fi
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## CALLING FUNCTIONS
STEP0_FUNC_SET_DEFAULTS_IF_ARGUMENTS_ABSENT ;
STEP1_FUNC_CLEAN_EXISTING_WATERMARKED_IMAGES_IN_PROJECTDIR
STEP2_FUNC_WATERMARK_IMAGES_IN_PROJECTDIR ;
STEP3_FUNC_DELETE_ORIGINAL_IMAGES_AFTER_WATERMARKING ;