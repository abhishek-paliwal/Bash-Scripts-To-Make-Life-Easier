#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
########################################################
## THIS PROGRAM RENAMES ALL FILES IN A DIRECTORY
## BY PREFIXING THE ORIGINAL FILENAME WITH THE CREATION DATE OF THE FILE IN YYYYMMDD FORMAT
## THIS PROGRAM ALSO REMOVES STRANGE CHARS FROM FILENAMES AND REPLACES THEM WITH HYPHENS.
## CREATED ON: Thursday July 19, 2018
## CREATED BY: PALI
#########################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PWD=`pwd` ;
cd $PWD ;
RENAME_DIR='__TMP_renamed_files_with_date' ;
mkdir $RENAME_DIR ;

echo ;
echo "Current working directory is: $PWD " ;
echo ;
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<" ;

## REAL MAGIC BEGINS BELOW FOR EVERY FILE
for f in *.* ;
do
    ## FIRST, EXTRACT FILE BASENAME AND EXTENSION FROM ORIGINAL FILENAME
    filename=$(basename -- "$f") ;
    extension="${filename##*.}" ;
    filename="${filename%.*}" ;

    ## SECOND: Extracting filename by converting original filename to title case and removing all the strange characters with hyphens, then spaces
    new_filename=`echo "$filename" | awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1' | sed -e 's/[{}\,! ()\-\+\.]/_/g' | sed -e 's/__*/-/g'` ;


    echo "CURRENT FILENAME: $f " ;
    echo "CURRENT FILE_BASENAME (OLD): $filename" ;
    echo "CURRENT FILE_BASENAME (NEW): $new_filename" ;
    echo "CURRENT FILE_EXTENSION: $extension" ;

    ####################################################
    ## Cuts the filename text with first 8 characters, and assigns that as a variable
    new_time=`echo "$new_filename" | cut -c 1-8` ;
    new_time_length=${#new_time} ;

    echo "First 8 chars (found from filename): "$new_time ;
    echo "First 8 chars (LENGTH): "$new_time_length ;


        ## IF the new variable is only digits, such as date, etc. then do following:
        if [[ $new_time_length == 8 && $new_time =~ ^[0-9]+$ ]]
            then
                echo "COMMENT: FILENAME OK. First 8 chars start with a number (or date). So NO RENAMING DONE." ;

                ## RENAME BUT DON'T ADD ANY DATE AS PREFIX (SINCE IT'S ALREADY THERE)
                NEW_FILENAME=`echo "$new_filename"\.$extension` ;

            else
                echo "COMMENT: FILENAME NOT OK. First 8 chars do not start with a number. HENCE, RENAMING DONE BY PREFIXING MODIFICATION DATE. <============= " ;

                ## RENAME BY ADDING DATE AS PREFIX (SINCE IT'S NOT ALREADY THERE)
                NEW_FILENAME=`echo $(date -r "$f" +"%Y%m%d-$new_filename")\.$extension` ;

        fi
    ####################################################

    ## THIRD, RENAME OLD FILE TO NEW FILENAME, AND COPY IT TO A SUBFOLDER
    cp "$f" "$RENAME_DIR/$NEW_FILENAME" ;

    echo "FILE RENAMED and MOVED FROM $f to $NEW_FILENAME " ;
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<" ;
    echo ;

done ;

## NOW RUNNING ANOTHER COMMAND BY CALLING ANOTHER BASH SCRIPT ...
## ... WHICH CHANGES THE FILE MODIFICATION TIME BASED UPON THE RENAMED FILENAME
echo "================= NOW MODIFICATION TIMES WILL BE CHANGED ============== " ;
cd $RENAME_DIR ; echo "Listing all files in $RENAME_DIR :"; ls -1;
sh $HOME/GitHub/Bash-Scripts-To-Make-Life-Easier/101-pali-change-modification-time-of-files.sh ;
echo ; echo " ===> FINAL STEP: CREATION TIME for all filenames has been changed. <===" ; echo ;

## Opening current working directory
echo "Now opening current directory ..."
open $PWD ;

################### PROGRAM ENDS ########################
#########################################################
