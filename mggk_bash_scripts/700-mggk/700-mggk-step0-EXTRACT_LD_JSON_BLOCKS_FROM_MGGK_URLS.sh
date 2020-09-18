#!/bin/bash
THIS_SCRIPT_NAME="$basename $0" ;
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ##################################################################################
    ## THIS PROGRAM EXTRACTS URLS FROM ALL MD FILES WITH MGGK_JSON_RECIPE BLOCK
    ## AND THEN FEEDS THOSE URLS TO A EXTERNAL PYTHON SCRIPT WHICH THEN USES
    ## BEAUTIFUL SOUP TO EXTRACT ALL VALID LD+JSON SCRIPT BLOCKS FOUND ON THOSE URLs.
    ##################################################################################
    ## Created on: November 8, 2019
    ## Coded by: Pali
    #########################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##------------------------------------------------------------------------------
DIR="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content" ;
WORKDIR="$HOME_WINDOWS/Desktop/Y" ;
cd $WORKDIR ;
echo ">>>> CURRENT WORKING DIRECTORY => $WORKDIR "
##------------------------------------------------------------------------------

## looping through all md files with valid mggk_json_recipe tags
for mdfile in $(grep -irl 'mggk_json_recipe:' $DIR/ | head -3) ;
do
    #echo ">>>> CURRENT FILE: $mdfile" ;
    MYURL=$(grep 'url: ' $mdfile| sed 's+url: ++g') ;
    echo "      >>>> URL found:  $MYURL" ;
    ## Feeding this url to the python script for exctrating ld+json blocks
    python3 $DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/700-mggk/700-mggk-step1-EXTRACT_LD_JSON_BLOCKS_FROM_MGGK_URLS.py $MYURL $WORKDIR ;
done    

echo "##------------------------------------------------------------------------------" ;
echo ">>>> Now separating the extracted JSON files based upon their LD+JSON block type ..." ;
echo "##------------------------------------------------------------------------------" ;

## Separate JSON files based upon their LD+JSON blocks
mkdir _json_recipes ;
for myfile in $(grep -il '"@type": "Recipe"' *.json) ; do mv $myfile  _json_recipes/ ; done ; 

mkdir _json_videos
for myfile in $(grep -il '"@type": "VideoObject"' *.json) ; do mv $myfile _json_videos/ ; done ; 

mkdir _json_articles
for myfile in $(grep -il '"@type": "NewsArticle"' *.json) ; do mv $myfile _json_articles/ ; done ; 

mkdir _json_breadcrumbs
for myfile in $(grep -il '"@type": "BreadcrumbList' *.json) ; do mv $myfile _json_breadcrumbs/ ; done ; 

mkdir _json_logos
for myfile in $(grep -il '"@type": "Organization"' *.json) ; do mv $myfile _json_logos/ ; done ; 
echo "##------------------------------------------------------------------------------" ;


echo "##------------------------------------------------------------------------------" ;
echo ">>>> NOTE: You can find all the output JSON files in the $WORKDIR" ;
echo "##------------------------------------------------------------------------------" ;
