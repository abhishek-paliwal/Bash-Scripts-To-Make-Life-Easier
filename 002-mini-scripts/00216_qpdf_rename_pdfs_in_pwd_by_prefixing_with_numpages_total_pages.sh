#/bin/bash

## THIS SCRIPT RENAMES PDFS BY PREFIXING FILENAMES WITH TOTAL NUMBER OF PAGES IN EVERY PDF FILE
## THIS SCRIPT USES qpdf program, can be installed by > brew install qpdf


DIR_RENAMED="_TMP_RENAMED_PDFS" ;
mkdir -p $DIR_RENAMED ; 

for x in *.pdf ; do 
echo "##============================================" ; 
totalPages=$(qpdf --show-npages $x) ; 
echo "$totalPages =  Total pages in // $x" ;
echo "	>> RENAMING PDF = > $x" ;  
mv "$x" "$DIR_RENAMED/$(printf "NumPages_" "%03i_%s" "$totalPages" "$x")" ; 
done ; 

echo; 
echo ">> File tree list = >" ; 
tree ; 


