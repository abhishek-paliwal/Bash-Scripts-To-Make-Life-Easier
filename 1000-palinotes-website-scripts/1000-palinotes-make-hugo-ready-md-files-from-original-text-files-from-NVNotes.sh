#!/bin/bash
################################################################################
## THIS SCRIPT PARSES EXPORTED TXT FILES FROM NVNOTES IN A FORMAT READY TO BE
## USED IN HUGO STATIC SITE GENERATOR. IT GENERATES MARKDOWN (MD) FILES AT A RESULT
## FOR EACH TXT FILE ENCOUNTERED. JUST PUT THOSE OUTPUT MD FILES INTO
## HUGO'S CONTENT/POSTS/ DIRECTORY.
################################################################################
################################################################################

####################### REAL MAGIC BELOW #######################################
################################################################################
MY_DIR="$HOME/Desktop/X/notes_nv"
################################################################################
OUTPUT_DIR="$MY_DIR/_TMP_OUTPUTS"
mkdir $OUTPUT_DIR ;
################################################################################

## BEGIN : MAIN FOR LOOP #######################################################
for x in *.txt ;
do
## Find file modification time of current file
#### 'stat -s' command output various times as bash variables ready to be used.
#### We are interested in modification time (st_mtime), which is in the 10 columnn
#### of the 'stat -s' output for each file.
MOD_TIME=$(stat -s $x | awk '{print $10}' | sed 's/st_mtime=//g')

## Get date prefix based upon above modification time
#### Converting dates from EPOCH to regular format
DATE_PREFIX=$(date -r $MOD_TIME +%Y-%m-%dT%H:%M:%S)
DATE_PREFIX_YMD=$(date -r $MOD_TIME +%Y-%m-%d)
NEW_FILENAME=$(echo $DATE_PREFIX_YMD-$x | sed 's/_/-/g' | sed 's/.txt/.md/g')

## Extracting URL and TITLE from original filename
TITLE=$(echo $x | sed 's/_/ /g' |sed 's/.txt//g')
URL=$(echo $TITLE | sed 's/ /-/g' | tr 'A-Z' 'a-z')

## Printing all variables before anything
echo "CURRENT FILE: $x"
echo "MOD_TIME = $MOD_TIME"
echo "DATE_PREFIX: $DATE_PREFIX"
echo "DATE_PREFIX_YMD: $DATE_PREFIX_YMD"
echo "TITLE = $TITLE"
echo "URL = $URL"
echo "NEW_FILENAME: $NEW_FILENAME"
echo;

## Writing to a new file and saving to _output
echo "---" > $OUTPUT_DIR/$NEW_FILENAME ## Initializing by writing the first line

########################################
echo "title: $TITLE
url: /$URL/
date: $DATE_PREFIX
publishdate: $DATE_PREFIX_YMD
lastmod: $DATE_PREFIX_YMD
draft: false
tags: ["tag1", "tag2"]
---

" | tee -a $OUTPUT_DIR/$NEW_FILENAME
########################################

## Appending original file content to the new file
cat "$x" >> $OUTPUT_DIR/$NEW_FILENAME

done
## END : MAIN FOR LOOP #######################################################

################################################################################
