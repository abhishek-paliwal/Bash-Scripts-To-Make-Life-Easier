#/bin/bash

##------------------------------------------------------------------------------
## VARIABLES SET UP AND ARGUMENTS CHECKING
PROJECT_DIR="$1" ; 
REPLACE_ORIGINAL_IMAGES="$2" ; 
##
DIR_WATERMARKED="$PROJECT_DIR/_DIR_WATERMARKED" ;
DIR_ORIGINAL_MOVED="$PROJECT_DIR/_DIR_ORIGINAL" ;
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
    if [ -z "$PROJECT_DIR" ] ; then 
        echo "IMPORTANT NOTE: No arguments supplied. Hence defaults will be set." ; 
        echo ;
        PROJECT_DIR="$(pwd)" ; 
        DIR_WATERMARKED="$PROJECT_DIR/_DIR_WATERMARKED" ;
        DIR_ORIGINAL_MOVED="$PROJECT_DIR/_DIR_ORIGINAL" ;
        ## options=(replace_original_images_yes | replace_original_images_no)
        REPLACE_ORIGINAL_IMAGES="replace_original_images_no" ; 
    else 
        echo "IMPORTANT NOTE: The program needs 2 optional CLI arguments. Both arguments provided." ;
        echo; 
    fi
    ## PRINT VARIABLES THUS SET
    echo "PROJECT_DIR             = $PROJECT_DIR" ;
    echo "REPLACE_ORIGINAL_IMAGES = $REPLACE_ORIGINAL_IMAGES" ;
    echo "DIR_WATERMARKED         = $DIR_WATERMARKED" ;
    echo "DIR_ORIGINAL_MOVED      = $DIR_ORIGINAL_MOVED" ;
}
########
function STEP1_FUNC_CLEAN_EXISTING_WATERMARKED_IMAGES_IN_PROJECTDIR () {
    PRINT_FUNC_SEPARATOR ;
    rm -rf "$DIR_WATERMARKED" ; 
    rm -rf "$DIR_ORIGINAL_MOVED" ; 
}
########
function STEP2_FUNC_WATERMARK_IMAGES_IN_PROJECTDIR () {
    PRINT_FUNC_SEPARATOR ;
    ## CREATE OUTPUT DIRECTORIES
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
        ## PRINT SUCCESS MESSAGE
        echo ">> SUCCESS => WATERMARKED IMAGE => $COUNT" ;
        echo "      IMAGE     = $MYIMAGE" ; 
        echo "      NEW_IMAGE = $MYIMAGE_NEW" ;         
    done  
}
########
function STEP3_FUNC_REPLACE_ORIGINAL_IMAGES_AFTER_WATERMARKING () {
    PRINT_FUNC_SEPARATOR ;
    if [ "$REPLACE_ORIGINAL_IMAGES" == "replace_original_images_yes" ]; then
        echo; echo ">> ORIGINAL IMAGES REPLACED." ;    
        ####
        for MYIMAGE in $PROJECT_DIR/*.jpg ; do
            MYIMAGE_BASENAME="$(basename $MYIMAGE)" ; 
            ## MOVE ORIGINAL IMAGES
            mkdir -p "$DIR_ORIGINAL_MOVED" ;
            mv "$MYIMAGE" "$DIR_ORIGINAL_MOVED/$MYIMAGE_BASENAME" ; 
            ## MOVE WATERMARKED IMAGES TO PARENT DIR
            MYIMAGE_WATERMARKED="$DIR_WATERMARKED/$PREFIX_WATERMARKED-$MYIMAGE_BASENAME" ;
            mv "$MYIMAGE_WATERMARKED" "$PROJECT_DIR/" ;        
        done
        ####
        ## CALL CLEANUP FUNCTION HERE
        STEP1_FUNC_CLEAN_EXISTING_WATERMARKED_IMAGES_IN_PROJECTDIR ; 
    else 
        echo; echo ">> NO ORIGINAL IMAGES REPLACEMENT DESIRED." ;       
    fi
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## CALLING FUNCTIONS
STEP0_FUNC_SET_DEFAULTS_IF_ARGUMENTS_ABSENT ;
STEP1_FUNC_CLEAN_EXISTING_WATERMARKED_IMAGES_IN_PROJECTDIR
STEP2_FUNC_WATERMARK_IMAGES_IN_PROJECTDIR ;
STEP3_FUNC_REPLACE_ORIGINAL_IMAGES_AFTER_WATERMARKING ;