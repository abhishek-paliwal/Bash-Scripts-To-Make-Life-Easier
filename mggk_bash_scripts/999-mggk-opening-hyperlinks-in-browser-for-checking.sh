#!/bin/bash
#############################################################################
## FILENAME: 999-mggk-opening-hyperlinks-in-browser-for-checking.sh
#############################################################################
## THIS PROGRAM OPENS VARIOUS URLS IN THE BROWSER FOR THE USER TO SEE IF THE
## URL IS VALID OR NOT. IT WAITS 2 SECONDS BEFORE OPENING ANOTHER URL,
## SO THAT THE BROWSER DOES NOT GET JAMMED.
#############################################################################
## It expects an input file with multiple lines to be present in the folder.
## Structure of the input file is below:
## ====================
# Link 1 text : https://www.concepro.com
# Link 2 text : https://www.mygingergarlickitchen.com/
# ...
## ====================
#############################################################################
## CODED ON: Wednesday April 10, 2019
## BY: Pali
#############################################################################

## SOME VARIABLES
IN_DIR="$HOME/Desktop/_TMP_Automator_results_" ;
input_filename="$IN_DIR/tmp_links_checker.txt"

## PWD
cd $IN_DIR ;
echo ;
echo "###########################################" ;
echo "Present working directory = $(pwd)" ;
echo ">> Make sure that this file is present in working directory: $input_filename " ;
echo "###########################################" ;

## USER CONFIRMATION
read -p ">>>> Check if input directory is OKAY. Press ENTER to continue ..."

## READING FROM THE FILE LINE BY LINE
while read -r line; do

    echo ;
    echo "Line read from file = $line"

    ## extracting just the url part from the text line
    url=$(echo $line | grep -io 'http\w.*$' ) ;

    echo "opening URL in browser = $url" ;

    open $url ## opening url in the default browser
    sleep 2 ## sleep for 2 seconds before opening another url in the while loop

done < "$input_filename"

#############################################################################
################################### PROGRAM ENDS ############################
