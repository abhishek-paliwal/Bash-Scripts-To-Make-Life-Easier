#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
    USAGE: $(basename $0)
    ## FILENAME: 1001-rename-all-files-in-folder-by-removing-strange-chars.sh
    ## THIS PROGRAM RENAMES ALL FILES IN PWD THRU COMMAND LINE BY REMOVING ALL STRANGE CHARS
    ###################################################
    ## Created: Tuesday July 29, 2018
    ## By: Pali
    ###################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


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

## REAL MAGIC BEGINS: BY LOOPING THRU ALL FILES
for x in *.* ;
do
    ## Viewing exising tags on original song
    echo "CURRENT FILE NAME: $x " ;
    echo "-------------------" ;

    # Converting original filename to title case and removing all the strange characters, and replacing them with hyphens
    NEW_FILENAME=`echo "$x" | awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1' | sed -e 's/[{}\,! ()\-\+]/_/g' | sed -e 's/__*/-/g' ` ;
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

## FINALLY CONVERTING ALL NEW FILENAMES TO LOWERCASE
cd $MAIN_DIR/_TMP_RENAME_DIR_ ;
echo '======> Currently renaming all filenames to lowercase' ;
for f in * ; do mv -- "$f" "$(tr "[:upper:]" "[:lower:]" <<< "$f")" ; done

## Opening working DIRECTORY
cd $MAIN_DIR ;
open $MAIN_DIR ;

####################################################
############### PROGRAM ENDS #######################
