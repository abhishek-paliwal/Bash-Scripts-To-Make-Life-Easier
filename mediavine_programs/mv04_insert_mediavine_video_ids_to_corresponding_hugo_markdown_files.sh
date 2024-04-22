#!/bin/bash
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## THIS CODE INSERTS MEDIAVINE VIDEO IDS TO CORRESPONDING MARKDOWN MD FILE INSIDE
## MGGK REPO CONTENT DIR.
## DATE: 2024-04-22
## BY: PALI
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ROOTDIR="$REPO_MGGK/content/allrecipes" ; 
CSVFILE="$DIR_Y/mv04-mediavine-ids-with-links.csv" ;

##------------------------------------------------------------------------------
# Read the CSV file line by line
while IFS=',' read -r MEDIAVINE_VIDEO_ID MGGK_URL
do
    echo ; 
    echo "MEDIAVINE_VIDEO_ID: $MEDIAVINE_VIDEO_ID" ; 
    echo "MGGK_URL: /$MGGK_URL/" ; 

    ## find md file for this url
    MDFILE=$(grep -irl "url: /$MGGK_URL/" $ROOTDIR | head -1) ; 
    echo "FILE = $MDFILE" ; 
    ## 
    TMPFILE="$DIR_Y/_TMP1.TXT" ; 
sed -i '.bak' "s|youtube_video_id|mediavine_video_id: \"$MEDIAVINE_VIDEO_ID\" \
\\nyoutube_video_id|ig" "$MDFILE" ; 

done < "$CSVFILE"
##------------------------------------------------------------------------------

