#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## THIS SCRIPT MAKES UNIQUE DIRECTORIES BASED UPON THE AUDIOBOOK PDF FILENAME
## AND MOVES ALL CORRESPONDING FILES TO THOSE DIRECTORIES.
## CREATED: 2023-03-06
## CREATED BY: PALI
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PDF_ROOTDIR="$DIR_Y/AWGP-unread/PDFs"

##################################################################################
FUNC_GET_UNIQ_NAMES () {
    ## Get count of unique names without file extensions
    echo ">> PRINTING count of unique names without file extensions ..." ; 
    fd -tf -e mp3 -e txt -e pdf -x echo {/.} --search-path="$PDF_ROOTDIR" | sd '.txt|.pdf|.mp3' '' | sort | uniq -c
}
##################################################################################

