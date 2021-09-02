#!/bin/bash

## This file creates 3 symbolic links (its mdfile + its steps-dir + its mggk url), 
## for each url given in an external text file

file="20210731-mggk-create-symbolic-links-for-given-mggk-urls-REQUIREMENT.txt" ;
dir_output="$DIR_X" ;
dir_steps="$REPO_MGGK/static/wp-content/recipe-steps-images" ;

for x in $(cat $file) ; do
####
    keyword=$(echo $x | sd '/' '' ) ;
    echo "################################################################################" ;
    nameFile=$(fd "$keyword" -I --search-path="$REPO_MGGK/content/" -e md -t f) ;
    nameDir=$(fd "$keyword" -I --search-path="$dir_steps" -t d) ;
    ##
    LINKFILE="$dir_output/$keyword-FILE" ;    
    LINKDIR="$dir_output/$keyword-DIR" ;
    
    if [ ! -z $LINKFILE ] ; then  ln -s $nameFile $LINKFILE ; fi
    if [ ! -z $LINKFILE ] ; then  ln -s $nameDir $LINKDIR ; fi
    ##
    ## CREATE A INTERNET URL SHORTCUT IN OUTPUT DIRECTORY
    urlfile="$dir_output/$keyword.url" ;
    myurl="https://www.mygingergarlickitchen.com/$keyword/#recipe-here" ;
    echo "[InternetShortcut]" > "$urlfile"
    echo "URL=$myurl" >> "$urlfile"
####
done
