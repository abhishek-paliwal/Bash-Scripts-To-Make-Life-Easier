#!/bin/bash
################################################################################
## This Bash script reads a text file, identifies lines starting with 
## a number, and merges them with the preceding line, saving the 
## modified content to an output file.
####
## DATE: 2023-11-24
## BY: Pali
################################################################################

ROOTDIR="$REPO_SCRIPTS/003-invoice-ocr-processor/lidl_invoices_cropped" ;
ROOTDIR_OUTPUT="$REPO_SCRIPTS/003-invoice-ocr-processor/lidl_invoices_cropped/_final_sorted_combined_output" ;
WORKDIR="$DIR_Y" ; 

# Input and output file names
input_file="$WORKDIR/COMBINED-LIDL-INVOICES-INPUT.txt" ; 
tmpfile="$WORKDIR/_tmp003_1.txt" ;
output_final="$WORKDIR/COMBINED-LIDL-INVOICES-OUTPUT-SORTED-NUMBERED.txt" ; 
##
cat "$ROOTDIR"/FIN_OCR* > "$input_file" ; # create input file combining all lidl invoices
echo > "$tmpfile" ## initialize file

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
echo "$current_line" >> "$tmpfile"

sort "$tmpfile" | nl > "$output_final" ; 
cat "$output_final" ; 

## Finally Copy to root output directory
cp "$output_final" "$ROOTDIR_OUTPUT/" ; 
echo ">> File copied => $output_final (TO) $ROOTDIR_OUTPUT/" ;  
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
