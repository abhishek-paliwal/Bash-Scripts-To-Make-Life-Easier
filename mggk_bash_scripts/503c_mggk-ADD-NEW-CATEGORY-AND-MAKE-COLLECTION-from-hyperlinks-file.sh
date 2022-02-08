#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

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
    ## THIS SCRIPT: 
    ## STEP 1 => ASKS THE USER TO SELECT A TEXT FILE CONTAINING MGGK URLS. 
    ## STEP 2 => ASKS AND ADDS A NEW COLLECTION CATEGORY PROVIDED BY THE USER TO ALL MD FILES
    ##        FOUND FROM THOSE MGGK URLS. PLEASE NOTE THAT THE NEW CATEGORY WILL ONLY BE
    ##        ADDED IF NOT ALREADY PRESENT. ELSE, IT WILL BE IGNORED.
    ## STEP 3 => OUTPUTS (ON CLI) THE NEW CATEGORY LINE TO BE ADDED TO THE NEW 
    ##        COLLECTION MD FILE.
    ################################################################################ 
    ## NOTE: THIS PROGRAM AUTOMATICALLY EXRACTS UNIQUE URLs, SO DUPLICATE URLS ARE OKAY.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-11-15
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
#info "This enables use of keywords for coloring, such as: debug, info, error, success, warn, highlight." ;
#debug "Read it's help by running: >> bash $DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/color-logger.sh -h"
##############################################################################

##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

##############################################################################
## Confirmation to proceed
read -p "Please provide the filename containing hyperlinks in DIR_Y [press ENTER KEY to proceed] ..." ; 
##############################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_EXTRACT_UNIQUE_HYPERLINKS_FROM_HEMINGWAY_EXPORTED_MDFILE () {
    ## This function extracts all links from all the mdfiles exported from hemingway editor (works on MAC OS)
    echo; echo ">> Extracting all links from all the mdfiles exported from Hemingway editor (works on MAC OS) ..." ; 
    for myFile in *.md ; do 
        outFile="$WORKDIR/hemingway-Extracted-Links-$(basename $myFile).txt" ;
        grep -iroh '(http.*)' "$myFile" | tr -d '()' | sort -u > $outFile ;
        echo "  >>>> FILE SAVED: $outFile" ; 
        echo ;
    done 
}
####
function FUNC_STEP0_GET_MDFILEPATHS_FROM_HYPERLINKS () {
    ## This function reads each line from hyperlinks file and finds corresponding
    ## mdfile path in MGGK REPO
    searchDir="$REPO_MGGK/content" ;
    info ">> Select the file containing MGGK URLs [should be present in DIR_Y]: " ; 
    inFile=$(fd -I --search-path="$DIR_Y" | fzf) ;
    outFile1="$WORKDIR/step0_output_mggk_part_removed.txt" ;
    outFile_step0="$WORKDIR/step0_output_found_md_filepaths.txt" ; 
    ##
    cat $inFile | grep -i 'mygingergarlickitchen.com' | sd 'https://www.mygingergarlickitchen.com' 'url: ' > $outFile1 ;
    echo ">> FINDING MD FILEPATHS FROM HYPERLINKS ..." ;
    echo > $outFile_step0 ; 
    while read myurl ; do
        echo "##++++++++++++++++++++++++++++++++++++" ;
        echo "CURRENT LINE => $myurl" ; 
        grep -irl "$myurl" $searchDir >> $outFile_step0 ; 
    done < $outFile1 
    ##
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
    echo ">> ALL MD FILES THUS FOUND ..." ;
    cat $outFile_step0 | nl ;
}
####
function FUNC_STEP1_ADD_NEW_CATEGORY_TO_ORIGINAL_MDFILES () {
    ## This function reads each line from mdfilepaths file and adds a 
    ## new collection category provided by the user
    info ">> Enter the new collection category to add [without hyphens, eg. collection diwali sweets]: " ; 
    read addThisCategory ; 
    #addThisCategory="collection diwali sweets" ;
    ##
    inFile="$outFile_step0" ; 
    outFile_step1="$WORKDIR/step1_output_found_md_filepaths_cleaned.txt" ; 
    ## removing empty lines
    grep -iv '^$' $inFile > $outFile_step1 ; 
    ## looping over each line 
    while read mdfilepath ; do
        echo "##--------------------------------------"; 
        echo "FILEPATH => $mdfilepath" ; 
        ## only add new category to original file if not present already.
        categoryNameToSearch="$(echo $addThisCategory | awk '{$1=$1;print}')" ; #remove leading+trailing spaces
        countOfCategoryFound=$(grep -ch "$categoryNameToSearch$" $mdfilepath) ;
        echo $countOfCategoryFound ; 
        if [ "$countOfCategoryFound" == "0" ]; then
            echo "SUCCESS: This category name is NOT FOUND (hence, category added) => $addThisCategory" ;
            replaceText="categories:\n  - $addThisCategory" ;
            sed -i '' "s|categories:|$replaceText|g" $mdfilepath ;
        else
            echo "FAILURE: This category name ALREADY FOUND (hence, category not added) => $addThisCategory" ;
        fi
    done < $outFile_step1
}
####
function FUNC_PRINT_EXISTING_COLLECTION_CATEGORY_NAMES () {
    ## This function prints all unique existing collection categories 
    inDir="$REPO_MGGK/content" ;
    echo "##------------------------------------------------------------------------------";
    echo ">> ALL EXISTING COLLECTION CATEGORIES (with their counts)" 
    grep -irh '\- collection' $inDir | sort | uniq -c ;
    echo "##------------------------------------------------------------------------------"; 
}
####
function FUNC_PRINT_FINAL_CATEGORY_LINE_TO_ADD_IN_COLLECTION_MDFILE () {
    ## This function prints the final line to add in your new collection mdfile. 
    echo "##------------------------------------------------------------------------------";
    highlight ">> ADD THE FOLLOWING LINE TO YOUR COLLECTION MD FILE [then check GITHUB for changes]..." ;
    echo; 
    addThisCategory_new="$(echo $addThisCategory | sed 's| |-|ig')" ; ## convert spaces to hyphens
    warn "{{< mggk-MAKE-COLLECTION-FROM-GIVEN-CATEGORY collectionCategory=\"${addThisCategory_new}\" showMax=100 >}}" ;
    echo "##------------------------------------------------------------------------------"; 
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Calling all functions in correct order
FUNC_EXTRACT_UNIQUE_HYPERLINKS_FROM_HEMINGWAY_EXPORTED_MDFILE
FUNC_STEP0_GET_MDFILEPATHS_FROM_HYPERLINKS ;
FUNC_PRINT_EXISTING_COLLECTION_CATEGORY_NAMES ;
FUNC_STEP1_ADD_NEW_CATEGORY_TO_ORIGINAL_MDFILES ;
FUNC_PRINT_FINAL_CATEGORY_LINE_TO_ADD_IN_COLLECTION_MDFILE ;
