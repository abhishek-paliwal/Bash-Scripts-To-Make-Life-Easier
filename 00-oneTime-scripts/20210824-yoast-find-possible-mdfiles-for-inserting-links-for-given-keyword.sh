#!/bin/bash

#### Find possible mdfiles for inserting links for given keyword
echo ">> Enter your keyword to find possible md files for linking => " ; 
read myKeyword ; 
##
outbound_linksFile="$DIR_DROPBOX_SCRIPTS_OUTPUT/_output-YOAST-ALLMGGKURLS-FOUND_OUTBOUND_LINKS_COUNTS.txt" ;
outFile1="$DIR_Y/_tmp1_found_possible_incoming_links_files.txt" ;
outFile2="$DIR_Y/_tmp2_found_possible_incoming_links_files.txt" ;
echo > $outFile1 ;
echo > $outFile2 ;
##
echo "## Finding mdfiles containing the given keyword (= $myKeyword)" ;
basename $(ag -l "$myKeyword" "$REPO_MGGK/content/") | cut -d'-' -f5-100 >> $outFile1 ;
##
echo; echo "## Found mdfiles containing the given keyword ..." ;
for mymdfile in $(cat $outFile1) ; do 
    echo "FILE FOUND = $mymdfile"; 
    grep -irh "$mymdfile" "$outbound_linksFile" >> $outFile2
done 
##
echo; echo "## FINAL LISTING OF mdfiles with their OUTBOUND LINKS COUNTS ..."; 
echo; echo ">> CHOOSE YOUR FILES FROM BELOW ... [valid recipes]" ; echo; 
sort -n $outFile2 | grep -i 'validrecipe' ;
echo; echo ">> CHOOSE YOUR FILES FROM BELOW ... [non recipes]" ; echo; 
sort -n $outFile2 | grep -i 'nonrecipe' ;
