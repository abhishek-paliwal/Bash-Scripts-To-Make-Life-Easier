#!/bin/bash
################################################################################
THIS_FILENAME="504b_mggk-copy-markdown-files-with-matching-urls-from-text-file.sh"
################################################################################
cat << EOF
  ##############################################################################
  ## FILENAME: $THIS_FILENAME
  #### USAGE: > sh $THIS_FILENAME.sh \$1
  #### WHERE, \$1 = LINKS TEXT FILE TO BE USED (eg., MY-URLS-TO-MD-FILES.TXT )
  ##############################################################################
  ## THIS PROGRAM FINDS ALL THE MARDKDOWN FILES IN HUGO MAIN CONTENT DIRECTORY
  ## BY READING A TEXT FILE WITH WHICH CONTAINS THE HYPERLINKS OF THE URLS FROM
  ## MGGK OFFICIAL WEBSITE. THEN, IT COPIES THEM ALL TO PWD.
  #####################################
  #### IMPORTANT NOTE: Don't forget to replace the original versions of the markdown files
  #### after you are done with editing them.
  #####################################
  ##### =============== FORMAT OF THE TEXT FILE BELOW: ================== ######
  ###### https://www.mygingergarlickitchen.com/gut-friendly-delicious-indian-kanji-for-your-tummy/
  ###### https://www.mygingergarlickitchen.com/5-modern-kitchen-gadgets-you-would-love-to-use/
  ###### https://www.mygingergarlickitchen.com/10-cooking-hacks-and-how-tos-of-the-21st-century/
  ###### ...
  ###### ...
  ###### ...
  ##############################################################################
  ## CODED ON: April 17, 2019
  ## BY: PALI
  ##############################################################################
EOF

################################################################################
INPUT_FILE="$1" ; ## getting the first argument from command line
MARKDOWN_FILES_ROOTDIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content" ;

PWD=$(pwd) ;
echo; echo ">>>> PRESENT WORKING DIRECTORY = $PWD" ;

## CHECKS IF ARGUMENT IS PRESENT. IF NOT, SCRIPT EXITS RIGHT THERE.
if [ -z "$1" ] ; then
echo "NO ARGUMENT on command line. \$1 = TEXT file not found." ;
exit 1
fi
##

## USER CONFIRMATION TO CONTINUE
echo;
read -p "Is this the directory where the \$1 = $1 LINKS TEXT file is present? If NO, then press CTRL+C, and CD to that directory. If yes, press the ENTER key to continue ... " ;
################################################################################

################################################################################
################### REAL MAGIC HAPPENS BELOW ###################################
OUTPUT_COPY_FOLDER="$PWD/_TMP_OUTPUT_COPIED_MARKDOWN_FILES" ;
mkdir $OUTPUT_COPY_FOLDER ;

### ASSIGNING TMP FILE FOR OUTPUT
DATE_VAR=$(date +%Y%m%d-%H%M%S);
TMP_SEARCH_FILELIST="$PWD/_TMP_OUTPUT_SEARCH_FILELIST-$DATE_VAR.TXT"  ;
##
## INITIALIZING THIS TMP_SEARCH_FILELIST
cat > $TMP_SEARCH_FILELIST <<INITFILE
########################################################################
## THIS IS THE OUTPUT OF SCRIPT: $THIS_FILENAME
## CREATED ON: $(date)
########################################################################
INITFILE
################################################################################

## READING LINES FROM THE LINKS FILE
while IFS= read -r line
do
  #echo "$line" ;
  ## REMOVING SOME TEXT FROM THE URL
  SEARCH_KEYWORD=$(echo $line | sed 's|https://www.mygingergarlickitchen.com||g' ) ;
  echo; echo ">>>> SEARCH_KEYWORD = $SEARCH_KEYWORD" ;

  ## GREP SEARCH OUTPUT RELEVANT MD FILES - USING THE KEYWORD FOUND IN LINE ABOVE
  echo ">>>> FILE CONTAINING THIS URL SEARCH KEYWORD IN $MARKDOWN_FILES_ROOTDIR =" ;
  grep -irl "url: $SEARCH_KEYWORD" $MARKDOWN_FILES_ROOTDIR/* ;

  ## SAVING THIS FILE LIST TO ANOTHER TEXT FILE:
  echo ">>>> ADDING THIS FILE NAME TO A TMP TEXT FILE --> $TMP_SEARCH_FILELIST " ;
  grep -irl "url: $SEARCH_KEYWORD" $MARKDOWN_FILES_ROOTDIR/* >> $TMP_SEARCH_FILELIST ;

  ## FINALLY COPYING THE ORIGINAL FILE TO PWD
  echo ">>>> COPYING THE ORIGINAL FILE TO PWD ..." ;
  cp $(grep -irl "url: $SEARCH_KEYWORD" $MARKDOWN_FILES_ROOTDIR/*) $OUTPUT_COPY_FOLDER/ ;


done < "$INPUT_FILE"
################################################################################

## SUMMARY AND NOTES:
echo;
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" ;
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" ;
echo "#### SUMMARY + IMPORTANT NOTES: #### " ;
echo "Don't forget to replace the original versions of the markdown files after you are done with editing them."

TOTAL_INPUT_URLS=$(cat $1 | wc -l ) ;
TOTAL_INPUT_URLS_UNIQ=$(cat $1 | grep -iv '#' | sort | uniq | wc -l ) ;
TOTAL_OUTPUT_FILES_FOUND=$(cat $TMP_SEARCH_FILELIST | grep -iv '#' | sort | uniq | wc -l ) ;

echo "TOTAL_INPUT_URLS ( FOUND IN ORIGINAL FILE = $1 )= $TOTAL_INPUT_URLS_UNIQ" ;
echo "TOTAL_INPUT_URLS (SORTED UNIQUE)= $TOTAL_INPUT_URLS_UNIQ" ;
echo "TOTAL_OUTPUT_FILES_FOUND (SORTED UNIQUE)= $TOTAL_OUTPUT_FILES_FOUND" ;
echo ;

################################################################################
## OPENING PWD
echo ">>>> Opening PWD = $PWD" ;
open $PWD ;
