#!/bin/bash
###############################################################################
## THIS BASH SCRIPT RENAMES AND COPIES THE MGGK HUGO MARKDOWN FILES BASED UPON
## THE DATE VALUE FOUND IN THE YAML FRONTMATTER
###############################################################################
## CODED ON: Thursday April 4, 2019
## BY: PALI
###############################################################################

echo "Present working directory: $(pwd) " ;
echo ;

## Asking for user confirmation to continue
read -p "IS WORKING DIRECTORY CORRECT? Should I continue the script? [press ENTER]:"

###############################################################################
TMP_FOLDER="_TMP_RENAMED_" ;
mkdir $TMP_FOLDER ;
echo "$TMP_FOLDER created..." ;
echo ;
###############################################################################

## Looping through all the MD files for renaming based upon the date found
## in the frontmatter
for x in *.md ;
do
    echo "FILENAME = $x" ;

    ## Print out the whole matched text
    printf "GREP SEARCH RESULT = " ;
    grep -irh 'date: ' $x ;

    ## Extracting the required characters from matched string
    name_prefix=$( grep -irh 'date: ' $x | cut -c 7-16 | sed 's/-//g' )  ;
    echo "NAME_PREFIX = $name_prefix" ;

    ## Copying (+ renaming)
    cp $x _TMP_RENAMED_/$name_prefix-$x
    echo "RENAMED TO =  _TMP_RENAMED_/$name_prefix-$x " ;
    echo ">>>> Renaming + copying DONE !" ;
    echo ;
done

#######################################
## IN CASE OF ERRORS = debugging
echo ">>>> IN CASE OF ERRORS: Please make sure that there are no spaces in the original filenames. If there are spaces, convert them to hyphens before running this script. " ;

#######################################
## Opening working directory (following command works only on Mac OS)
open $(pwd)

############################### PROGRAM ENDS ##################################
