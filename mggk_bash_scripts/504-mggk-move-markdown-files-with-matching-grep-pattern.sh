#!/bin/bash
######################################################################
## THIS BASH PROGRAM TAKES AN INPUT DIRECTORY AND SEARCHES FOR A GREP
## PATTERN IN THE CONTENT OF ALL THE MARKDOWN FILES. THEN COPIES ALL THE
## MATCHING FILES FROM THE INPUT DIRECTORY TO THE OUTPUT DIRECTORY.
######################################################################
## DATE: FEB 15 2019
## MADE BY: PALI
######################################################################
## USAGE: sh 504-mggk-move-markdown-files-with-matching-grep-pattern $1
## where, $1 is the search term, such as 'tips and tricks'
######################################################################
######################################################################

## FILES WILL BE MOVED FROM INPUT FOLDER TO OUTPUT FOLDER
DATE_VAR=$(date "+%Y%m%d_%H%M%S") ;
SEARCH_TERM="$1" ; ## first cli argument
SEARCH_TERM_SPECIAL=$(echo $SEARCH_TERM | sed 's/ /-/g')

INPUT_FOLDER="$(pwd)" ;
OUTPUT_FOLDER="_TMP_MOVE_FILES_HERE-$DATE_VAR" ;
TMP_FILELIST="$OUTPUT_FOLDER/_TMP_SEARCH_FILELIST_WITH_TEXT_$SEARCH_TERM_SPECIAL.txt"

## Change the working directory to INPUT_FOLDER, which in this case is just PWD.
cd $INPUT_FOLDER ;
mkdir $OUTPUT_FOLDER ;

echo ">>>>>>>>>>>>>>>>>>>>> <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;
echo "INPUT_FOLDER (= WORKING DIRECTORY) : $INPUT_FOLDER" ;
echo "TEXT PATTERN TO SEARCH : $SEARCH_TERM ";
echo ">>>>>>>>>>>>>>>>>>>>> <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;
echo ;

################### DO NOT CHANGE ANYTHING BELOW ######################
######################### REAL MAGIC BELOW ############################
#######################################################################

echo ;
echo ">>>>>>>>> Listing all *.md files: "
ls -1 *.md ;
echo "==================================================== " ;
echo "TOTAL *.md FILES FOUND = $(ls -1 *.md | wc -l) " ;
echo "==================================================== " ;
## SEARCHING FOR THE TERM FROM THE CLI ARGUMENT, THEN SAVING TO FILES
echo "SEARCHING FOR THIS TEXT: $SEARCH_TERM " ;
echo "==================================================== " ;
echo ;

## GREP results displaying
echo ">>>> Displaying GREP results on CLI :"
echo ">>>> Running : grep -il \"$SEARCH_TERM\" *.md | sort -rn " ;
grep -il "$SEARCH_TERM" *.md | sort -rn | nl ; ## just displaying on CLI
echo "==================================================== " ;
echo "TOTAL GREP FILES FOUND =" $(grep -il "$SEARCH_TERM" *.md | sort -rn | wc -l) ;
echo "==================================================== " ;

############### USER CONFIRMATION to continue further ...
read -p ">>>> IF everything's OKAY, press ENTER key to continue ... (else press CTRL+C to stop this script): " ;

## Before doing anything, it makes a full TMP backup of INPUT_FOLDER
DIRNAME=$(basename $INPUT_FOLDER) ;
##  MAKING A complete BACKUP ZIP of INPUT_FOLDER
zip -r $OUTPUT_FOLDER/_TMP_BACKUP-$DATE_VAR-$DIRNAME.zip *.md ;
echo ">>>> DONE!!! TMP ZIP FILE CREATED AT $OUTPUT_FOLDER " ;

echo "#########################################################" > $TMP_FILELIST ; ## writing first line
echo "#### LIST OF md FILES CONTAINING PHRASE: $SEARCH_TERM " >> $TMP_FILELIST ; ## appending
echo "#########################################################" >> $TMP_FILELIST ; ## appending

echo ">>>> BEGIN: TMP FILE_LIST SAVING as: $TMP_FILELIST" ;
grep -il "$SEARCH_TERM" *.md | sort -rn >> $TMP_FILELIST ; ## appending
echo "<<<< END: TMP FILE_LIST SAVED as: $TMP_FILELIST" ;

#######################################################################
## WHILE LOOP RUNNING THRU WHOLE TMP_FILELIST, AND COPYING FILES
while IFS='' read -r line || [[ -n "$line" ]]; do
    echo ;
    echo "Text read from file: $line"
    cp $INPUT_FOLDER/$line $OUTPUT_FOLDER/ ;
    echo "File copied: $line" ;
done < "$TMP_FILELIST"

#######################################################################
## Opening pwd (NOTE: following command only works on MAC OS)
open $INPUT_FOLDER

#######################################################################
################################ PROGRAM ENDS #########################
