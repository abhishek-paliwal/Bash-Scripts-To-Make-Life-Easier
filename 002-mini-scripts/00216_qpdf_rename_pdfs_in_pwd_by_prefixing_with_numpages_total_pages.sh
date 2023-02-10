#/bin/bash

## THIS SCRIPT RENAMES PDFS BY PREFIXING FILENAMES WITH TOTAL NUMBER OF PAGES IN EVERY PDF FILE
## THIS SCRIPT USES qpdf program, can be installed by > brew install qpdf


## Exit if no pdf found 
pdfarray=( $(ls *.pdf) ) ; 
if [[ ${#pdfarray[@]} -gt 0 ]] ; then 
    echo ">> SUCCESS: PDFs found. The program will continue ..." ; 
else
    echo ">> FAILURE: No PDFs found. The program will exit now." ; 
    exit ; 
fi 

#####################################################################

## SET VARIABLES
DIR_RENAMED="_TMP_RENAMED_PDFS" ;
DIR_ORIGINAL="_TMP_ORIGINAL_PDFS" ;
mkdir -p $DIR_RENAMED $DIR_ORIGINAL ; 

for x in *.pdf ; do 
    echo "##============================================" ; 
    totalPages=$(qpdf --show-npages $x) ; 
    echo "$totalPages =  Total pages in // $x" ;
    ##
    echo "  >> Copying original (just in case)..." ; 
    cp "$x" $DIR_ORIGINAL/ ; 
    ##
    echo "	>> RENAMING PDF = > $x" ;  
    NAME_PREFIX="Numpages-$(printf "%03i%s" "$totalPages")" ; 
    cp "$x" "$DIR_RENAMED/$NAME_PREFIX-$(basename $x)" ; 
done 

echo; 
echo ">> File tree list = >" ; 
tree ; 


