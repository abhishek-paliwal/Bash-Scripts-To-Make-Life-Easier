#!/bin/bash

#### Find possible mdfiles for inserting links for given keyword
echo ">> Enter your keyword to find possible md files for linking [all lowercase] => " ; 
read myKeyword ; 
myKeyword_hyphen=$(echo "$myKeyword" | sd ' ' '-') ;
##
inbound_links_counts_file="$DIR_DROPBOX_SCRIPTS_OUTPUT/_output-YOAST-ALLMGGKURLS-FOUND_INBOUND_LINKS_COUNTS.txt"
outbound_links_counts_file="$DIR_DROPBOX_SCRIPTS_OUTPUT/_output-YOAST-ALLMGGKURLS-FOUND_OUTBOUND_LINKS_COUNTS.txt" ;
outFile1="$DIR_Y/_tmp1_found_possible_incoming_links_files.txt" ;
outFile2="$DIR_Y/_tmp2_found_possible_incoming_links_files.txt" ;
echo > $outFile1 ;
echo > $outFile2 ;
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "################################################################################" ;
echo "## Listing existing inbound links for given keyword ... (= $myKeyword_hyphen)" ;
cat $inbound_links_counts_file | grep -i "$myKeyword_hyphen" ;
echo "################################################################################" ;
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Finding mdfiles containing the given keyword
basename $(ag -l "$myKeyword" "$REPO_MGGK/content/") | cut -d'-' -f5-100 >> $outFile1 ;
for mymdfile in $(cat $outFile1) ; do 
    #echo "FILE FOUND = $mymdfile"; 
    grep -irh "$mymdfile" "$outbound_links_counts_file" >> $outFile2
done 
##
echo "################################################################################" ;
echo; echo "## FINAL LISTING OF mdfiles with their OUTBOUND LINKS COUNTS (containing keyword = $myKeyword)"; 
echo; echo ">> CHOOSE YOUR FILES FROM BELOW // [VALID RECIPES]" ; echo; 
sort -n $outFile2 | grep -i 'validrecipe' ;
echo; echo ">> CHOOSE YOUR FILES FROM BELOW // [NON RECIPES]" ; echo; 
sort -n $outFile2 | grep -i 'nonrecipe' ;
echo "################################################################################" ;
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

