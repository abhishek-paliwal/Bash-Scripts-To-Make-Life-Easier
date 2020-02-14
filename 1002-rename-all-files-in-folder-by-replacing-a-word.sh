#!/bin/bash
## FILENAME: 1002-rename-all-files-in-folder-by-replacing-a-word.sh
## THIS PROGRAM RENAMES ALL FILES IN PWD THRU COMMAND LINE BY REPLACING USER CHOSEN WORD WITH A DESIRED ONE.
###################################################
## Created: 2020-02-14
## By: Pali
###################################################

## Starting in the present working directory
MAIN_DIR=`pwd` ;
echo ; echo "Working directory: $MAIN_DIR" ;
cd $MAIN_DIR ;

######################################################################
## Check if PWD is not $HOME . Only then, it will run.
PWD=`pwd` ;
if [ "$PWD" == "$HOME" ];
then
    echo "PWD is $PWD . Thus, this script will not run in this directory. " ;
    exit 1 ;
fi
######################################################################

## Creating a new tmp directory to store renamed files
rm _TMP_RENAME_DIR_ ## remove dir if exists already
mkdir _TMP_RENAME_DIR_ ;

echo ;
echo "LIST OF ALL FILES IN THIS DIRECTORY: " ;
echo "======================================= " ;
ls -1 *.* | nl ; # Listing all files in pwd
echo "======================================= " ;
echo ;

################################################################
echo "Enter the word you want replaced: " 
read SEARCHWORD ;

echo "Enter the new word as replacement: "
read NEWWORD ;

echo "SEARCH_WORD = $SEARCHWORD // NEW_WORD = $NEWWORD" ;
################################################################

## REAL MAGIC BEGINS: BY LOOPING THRU ALL FILES
for x in *.* ;
do
    ## Viewing exising tags on original song
    echo "CURRENT FILE NAME: $x " ;
    echo "-------------------" ;

    # Converting original filename to title case and removing all the strange characters, and replacing them with hyphens
    NEW_FILENAME=$(echo "$x" | sed -e "s/$SEARCHWORD/$NEWWORD/g" ) ;
    printf '%s' "======> NEW_FILENAME: $NEW_FILENAME " ;

    ## Now copying the renamed files to a TMP dir (remember quotes for variables)
    echo ;
    echo "RUNNING COMMAND: cp $x _TMP_RENAME_DIR_/$NEW_FILENAME" ;
    cp "$x" "_TMP_RENAME_DIR_/$NEW_FILENAME" ;


    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;
    echo "#### R E N A M I N G  D O N E  FOR: $x ####" ;
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;
    echo ;

done

cd $MAIN_DIR ;

## Opening working DIRECTORY
if [ "$USER" == "ubuntu" ] ; then
    explorer.exe .
else
    ## FINALLY CONVERTING ALL NEW FILENAMES TO LOWERCASE
    cd $MAIN_DIR/_TMP_RENAME_DIR_ ;
    echo '======> Currently renaming all filenames to lowercase' ;
    for f in * ; do mv -- "$f" "$(tr "[:upper:]" "[:lower:]" <<< "$f")" ; done
    ## Opening directory
    open $MAIN_DIR ;
fi    


####################################################
############### PROGRAM ENDS #######################
