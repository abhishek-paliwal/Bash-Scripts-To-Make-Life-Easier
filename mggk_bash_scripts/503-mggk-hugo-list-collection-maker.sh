#!/bin/bash
#####################################################################
## THIS PROGRAM FINDS OUT THE URL, FEATURED IMAGE AND TITLE FROM ALL THE *.MD (MARKDOWN)
## FILES PRESENT IN THE PRESENT WORKING DIRECTORY AND CREATES A NUMBERED LIST WITH
## TITLES WITH LINK AND IMAGES AND SAVES THEM TO AN HTML FILE.
## FILENAME: 503-mggk-hugo-list-collection-maker.sh
## DATE: 9 FEB 2019
## BY: PALI
#####################################################################
### Change the following variables only, if you have to #############
SITE_PREFIX="https://www.mygingergarlickitchen.com"
FILENAME='_delete_this_after_taking_results/0-FINAL.html'
STARTCOUNT=29 ## RESET THE STARTCOUNT TO 1 FOR NORMAL USE
#####################################################################

############ Do not change anything below this line #################
#####################################################################

echo "Present working directory: $(pwd) "
echo # blank line

## Initializing the html files (rewriting if already exists)
mkdir _delete_this_after_taking_results
echo > $FILENAME

## Listing all *.md files and displaying them on CLI
echo ;
echo "List of all *.md files :"
ls -1 *.md | nl

## LOOPING THROUGH ALL THE *.MD FILES
for x in $(ls -1 *.md)
do
    echo ">>>> BEGIN : Running on: $x "
    ## featured_image:
    featured_image=$(egrep -ih 'featured_image:' $x | sed 's/featured_image: //g' )

    ## title
    title=$(egrep -ih 'title:' $x | sed 's/title: //g' )

    ## url
    url=$(egrep -ih 'url:' $x | sed 's/url: //g' )

    ##### final magic
    echo "<a href='$SITE_PREFIX$url'><img src='$SITE_PREFIX$featured_image' width='600px' /></a>" >> $FILENAME

    echo "<h3>$STARTCOUNT. <a href='$SITE_PREFIX$url'>$title</a></h3>" >> $FILENAME

    echo "<<<< END : Running on: $x "
    echo

    ((STARTCOUNT++)) ## Incrementing STARTCOUNT by 1

done

## Opening pwd (works only on Mac OX 10.10+)
echo "Now opening $(pwd)"
open $(pwd)
######################### PROGRAM ENDS ####################################
