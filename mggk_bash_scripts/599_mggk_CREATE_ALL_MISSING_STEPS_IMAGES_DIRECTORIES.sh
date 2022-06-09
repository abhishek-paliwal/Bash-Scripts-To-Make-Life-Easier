#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
##
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## USAGE:
    #### > bash $THIS_SCRIPT_NAME
    ################################################################################
    ## This program creates missing recipe steps directories with white 1x1px images 
    ## which are then moved by the user to the recipe steps images folder in MGGK hugo 
    ## directory.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: December 18, 2020
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

####################### ADDING COLOR TO OUTPUT ON CLI ##########################
echo "Currently sourcing the bash color script, which outputs chosen texts in various colors ..." ;

source $REPO_SCRIPTS/2000_vendor_programs/color-logger.sh

info "This enables use of keywords for coloring, such as: debug, info, error, success, warn, highlight." ;
debug "Read it's help by running: >> bash $DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/color-logger.sh -h"
##############################################################################

##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 
##
myfile="$WORKDIR/no_steps_present_urls.txt" ;
outfile="$WORKDIR/_all_images_links.txt" ;
CREATE_TMPDIRS_AT="$WORKDIR/_TMPDIRS_CREATED_FOR_NEW_STEPS_IMAGES_FOR_MOVING" ;
WHITE1PX_IMAGE_PATH=" $REPO_SCRIPTS_MGGK/_REQUIREMENT_FILES_MGGK/1px_white.jpg" ;
##

##############################################################################
## BEGIN: CREATE ALL FUNCTIONS
##############################################################################
## First get all urls in mdfiles which have no steps images present
function FUNCTION_GET_ALL_URLS_WITH_STEPS_IMAGES_PRESENT_FRONTMATTER_TAG () {
    HUGODIR="$REPO_MGGK/content" ;
    SUMMARY_FILE_STEPS_IMAGES_DIRS="$REPO_MGGK_SUMMARY/_mggk_summary_of_current_directories_with_steps_images.txt" ;
    TMP1="$WORKDIR/_tmp1.txt" ;
    TMP2="$WORKDIR/_tmp2.txt" ;
    touch $TMP2 $TMP1 ## initialize
    rm $TMP2 $TMP1 ## if already exists
    ##
    cat $SUMMARY_FILE_STEPS_IMAGES_DIRS | grep -iv '#' | sed 's/ //g' | sed 's|/||g' > $TMP1 ;
    ##
    for mdfile in $(grep -irl 'steps_images_present:' $HUGODIR/** ) ; do 
        grep -i 'url: ' $mdfile | sed 's/url: //g' | sed 's+/++g' | sed 's/ //g' >> $TMP2
    done
    ##
    sort $TMP1 > $TMP1.sorted.summaryUrls ;
    sort $TMP2 > $TMP2.sorted.allUrls ;
    diff $TMP1.sorted.summaryUrls $TMP2.sorted.allUrls | grep -i '>' | sed 's/>//g' > $myfile ;
    ##
    rm $TMP2 $TMP1 ## cleaning
}    

## Get all step images urls for each website url obtained from step1
function FUNCTION_GET_IMAGES_URL_BY_CURL () {
    TMP_OUTFILE="$WORKDIR/_tmp0.txt" ;
    ##
    touch $TMP_OUTFILE # initializing
    rm $TMP_OUTFILE ## if already exists
    while IFS= read -r line
    do
        newline=$(echo $line | sed 's/ //g') ; ## remove spaces
        echo "$newline ==> https://www.mygingergarlickitchen.com/$newline/" ;
        curl "https://www.mygingergarlickitchen.com/$newline/" | grep '"image":' | grep -i 'recipe-steps-images' >> $TMP_OUTFILE ;
    done < "$myfile"
    ##
    if [ -f "$TMP_OUTFILE" ]; then
        echo "$TMP_OUTFILE exists. Hence, this file will be processed." ;
        cat $TMP_OUTFILE | sed 's/ //g' | sed 's/"//g' | sed 's+image:https://www.mygingergarlickitchen.com/wp-content/recipe-steps-images/++g' > $outfile
    fi
}

## Get directory names from parsed Image urls + create those directories
function FUNCTION_TO_MAKE_FOLDERS () {
    echo "##------------------------------------------------------------------------------" ; 
    while IFS= read -r line
    do
    #echo "$line" ;
    NEW_DIR=$(dirname "$line") ;
    echo "Creating directory ... $NEW_DIR" ;
    mkdir -p $CREATE_TMPDIRS_AT/$NEW_DIR ;
    done < "$outfile"
}

## Finally copy and properly rename 1px white image to newly created directories 
function FUNCTION_TO_COPY_1PX_IMAGE_TO_FOLDERS () {
    echo "##------------------------------------------------------------------------------" ; 
    while IFS= read -r line
    do
    echo "$line" ;
    NEW_DIR=$(dirname "$line") ;
    cp $WHITE1PX_IMAGE_PATH $CREATE_TMPDIRS_AT/$line ;
    echo "Copying done ... $CREATE_TMPDIRS_AT/$line" ;
    done < "$outfile"
}

##############################################################################
## END: CREATE ALL FUNCTIONS
##############################################################################

## RUNNING THE REQUIRED FUNCTIONS
success ">> STEP 1/4: Getting all urls in mdfiles which have no steps images present" ;
FUNCTION_GET_ALL_URLS_WITH_STEPS_IMAGES_PRESENT_FRONTMATTER_TAG

success ">> STEP 2/4: Getting all step images urls for each website url obtained from step 1" ;
FUNCTION_GET_IMAGES_URL_BY_CURL

success ">> STEP 3/4: Getting directory names from parsed Image urls + create those directories" ;
FUNCTION_TO_MAKE_FOLDERS

success ">> STEP 4/4: Finally copying and properly renaming 1px white image to newly created directories " ;
FUNCTION_TO_COPY_1PX_IMAGE_TO_FOLDERS