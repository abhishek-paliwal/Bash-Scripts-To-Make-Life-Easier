#/bin/bash

## THIS PROGRAM RENAMES ALL AWGP ORIGINAL PDFS TO PDFS WITH BOOK SERIAL NUMBERS

originaldir="_original_pdfs" ; 
newdir="_renamed_pdfs" ;
mkdir -p $newdir ; 

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Rename only those pdfs which are not already renamed
c=0; 
for x in $(fd -e pdf --search-path="$originaldir" | grep -iv 'BOOK_SERIALNUM' ) ; do 
    ((c++)) ; 
    echo "##########################################################################" ;  
    echo ">> CURRENT FILE = $c // $x" ; 
    ##
    base_x=$(basename $x) ; 
    ##
    bvar=$(grep -i $base_x v1_awgp_merged_full_book_catalog.csv | awk -F ';' '{print $1}' ) ; 
    echo "  >> FOUND BOOK SERIAL => $bvar" ;
    ##
    newname="$newdir/$bvar"_XX_"$base_x" ; 
    echo "  >> copying the renamed pdf => $newname" ; 
    cp $x "$newname" ; 
done

## produce tree output
tree --filesfirst > _results_example_tree.txt
