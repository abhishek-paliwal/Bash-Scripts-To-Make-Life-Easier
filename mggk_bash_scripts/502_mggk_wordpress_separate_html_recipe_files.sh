#!/bin/bash
cat << EOF
    ############################################################################
    # MADE FOR MGGK:
    # THIS PROGRAM SEPERATES html files in _downloaded_html_files, as:
    ##### 1. HTML pages using Easyrecipe markup block
    ##### 2. HTML pages using Pali's created recipe markup block
    ##### 3. HTML pages using no valid recipe markup block at all.
    ######################
    # IMPORTANT NOTE: This program should only be run after the successful run of
    # the script '501_mggk_wordpress_find_post_first_published_dates.sh'
    # Because, it needs to have the HTML files locally saved , in the _downloaded_html_files
    # directory.
    ######################
    # CREATION DATE: January 19, 2019
    # CREATED BY: PALI
    ############################################################################
    ############################################################################
    # USAGE (run the following command):
    # > sh 502_mggk_wordpress_separate_html_recipe_files.sh
    ############################################################################
    ############################## BEGIN #######################################
    ############################################################################
EOF

## DECLARING SOME VARIABLES
DATE_VAR=$(date "+%Y-%m-%d")
HTML_FOLDER="_downloaded_html_files" ;
###################
cd $HTML_FOLDER ;
PWD=$(pwd)
echo "Present working directory: $PWD"
###################

## Creating 3 directory to hold categorized html files
dir00="00-CATEGORIZED-HTML-LIST"
mkdir $dir00 ;

## Defining the 3 needed files
file01="$dir00/01_EASYRECIPE_block_html_list.html"
file02="$dir00/02_PALIRECIPE_block_html_list.html"
file03="$dir00/03_NORECIPE_block_html_list.html"

## PRINTING OUT THE VARIOUS CATEGORIES HTML FILES on command line

## 01: Printing filenames with valid EasyRecipe block (-H prints filenames containing)
echo "01: Files containg EASYRECIPE block = ";
egrep -H -io 'ERSRatings' *.html | wc -l
echo ;

## 02: Printing filenames with valid PaliRecipe block (-H prints filenames containing)
echo "02: Files containg PALIRECIPE block = ";
egrep -H -io 'JSON\+LD RECIPE SCHEMA BLOCK BELOW THIS' *.html | wc -l
echo ;

## 03: Printing files with no valid recipe block (-L means not containing)
echo "03: Files with NO VALID RECIPE block = ";
egrep -L -H -io 'ERSRatings|JSON\+LD RECIPE SCHEMA BLOCK BELOW THIS' *.html | wc -l
echo ;

############################################################################
echo ">>>>> NOW SAVING THESE LISTS INTO 3 SEPARATE HTML FILES <<<<< "
############################################################################
############################################################################
## SAVING HTML FILES with hyperlinks
## 'egrep -l' displays only the filename containing pattern
############################################################################
## EasyRecipe file list to HTML
num_files=$(egrep -l -io 'ERSRatings' *.html | wc -l)  ;
echo "<h2>01. Files containing EASYRECIPE block (TOTAL: $num_files ) </h2>" > $file01
echo "<h3>(Note: Open this file in Firefox, as Google Chrome constantly reloads it.)</h3>" >> $file01

count=1 ;
for i in $(egrep -l -io 'ERSRatings' *.html)
do
    echo "$count : <a target='_blank' href='../$i'>$i</a> <br>" >> $file01 ;
    ((count++))
done
echo ">>> DONE (1/3): $file01" ;
############################################################################
## PaliRecipe file list to HTML
num_files=$(egrep -l -io 'JSON\+LD RECIPE SCHEMA BLOCK BELOW THIS' *.html | wc -l)  ;
echo "<h2>01. Files containing PALIRECIPE block (TOTAL: $num_files ) </h2>" > $file02
echo "<h3>(Note: Open this file in Firefox, as Google Chrome constantly reloads it.)</h3>" >> $file02

count=1 ;
for i in $(egrep -l -io 'JSON\+LD RECIPE SCHEMA BLOCK BELOW THIS' *.html)
do
    echo "$count : <a target='_blank' href='../$i'>$i</a> <br>" >> $file02 ;
    ((count++))
done
echo ">>> DONE (2/3): $file02" ;
############################################################################
## No Valid Recipes file list to HTML
num_files=$(egrep -l -L -io 'ERSRatings|JSON\+LD RECIPE SCHEMA BLOCK BELOW THIS' *.html | wc -l)  ;
echo "<h2>01. Files containing NO VALID RECIPE block (TOTAL: $num_files ) </h2>" > $file03
echo "<h3>(Note: Open this file in Firefox, as Google Chrome constantly reloads it.)</h3>" >> $file03

count=1 ;
for i in $(egrep -l -L -io 'ERSRatings|JSON\+LD RECIPE SCHEMA BLOCK BELOW THIS' *.html)
do
    echo "$count : <a target='_blank' href='../$i'>$i</a> <br>" >> $file03 ;
    ((count++))
done
echo ">>> DONE (3/3): $file03" ;

############################################################################
################################# END ######################################
############################################################################
