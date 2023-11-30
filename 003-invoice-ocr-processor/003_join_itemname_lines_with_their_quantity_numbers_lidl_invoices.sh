#!/bin/bash
################################################################################
## This Bash script reads a text file, identifies lines starting with 
## a number, and merges them with the preceding line, saving the 
## modified content to an output file.
####
## DATE: 2023-11-24
## BY: Pali
################################################################################

function FUNC_PROCESS_INVOICES_IN_THIS_DIR () {
    ## function takes 2 arguments // arg1 = dir, arg2 = shopname
    WORKDIR="$DIR_Y" ; 
    ROOTDIR="$1" ;
    ROOTDIR_OUTPUT="$ROOTDIR/_final_sorted_combined_output" ;
    SHOP_KEYWORD="$2" ; 
    #
    # Input and output file names
    input_file="$WORKDIR/combined-${SHOP_KEYWORD}-invoices-input.txt" ; 
    output_final="$WORKDIR/combined-${SHOP_KEYWORD}-invoices-output-sorted-numbered.txt" ; 
    tmpfile="$WORKDIR/_tmp003_1.txt" ;
    echo > "$tmpfile" ## initialize file
    #
    ##
    # create input file combining all lidl invoices
    cat "$ROOTDIR"/FIN_OCR* > "$input_file" ; 
    ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # Initialize a variable to store the current line
    current_line=""
    # Read the input file line by line
    while IFS= read -r line; do
        # Check if the line starts with a number
        if [[ $line =~ ^[0-9] ]]; then
            # If it does, join it with the previous line
            current_line+=" --------------- $line"
        else
            # If it doesn't, print the previous line and update the current line
            echo "$current_line" >> "$tmpfile"
            current_line="$line"
        fi
    done < "$input_file"

    # Print the last line (if any)
    echo "$current_line" >> "$tmpfile" ;
    #
    sort "$tmpfile" | grep -iv '^$' | uniq -c | nl > "$output_final" ; 
    cat "$output_final" ; 
    #
    ## Finally Copy to root output directory
    cp "$output_final" "$ROOTDIR_OUTPUT/" ; 
    echo ">> File copied => $output_final (TO) $ROOTDIR_OUTPUT/" ;  
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Call function
FUNC_PROCESS_INVOICES_IN_THIS_DIR "$REPO_SCRIPTS/003-invoice-ocr-processor/lidl_invoices_cropped" "lidl" ; 