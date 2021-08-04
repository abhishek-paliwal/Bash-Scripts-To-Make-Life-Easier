#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

WORKDIR="$DIR_Y/_tmp_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ;
tmpFile1="$WORKDIR/tmp1.txt" ;
tmpFile2="$WORKDIR/tmp2.txt" ;
tmpFile3="$WORKDIR/tmp3.txt" ;
rm $tmpFile1 ; 
rm $tmpFile2 ;
rm $tmpFile3 ;
################################################################################

## getting all uncategorized md files paths with first published during 2013-2019
ag 'first_published' $REPO_MGGK/content/ | ag uncategorized | awk '{print $2 "=" $1}' | sort -n | grep -ivE "(2021-|2020-)" | cut -d'=' -f2 | cut -d':' -f1 > $tmpFile1

################################################################################

for x in $(cat $tmpFile1); do 
    grep -i 'url:' $x | sd ' ' '' | sd 'url:' 'https://www.mygingergarlickitchen.com' >> $tmpFile2
done 


function FUNC_find_non-mggk-hyperlinks-from-these-urls () { 
##
outFile="$tmpFile3-0" ;
rm $outFile ;
for URL in $(cat $tmpFile2); do 
    ## get links with double quotes in href
    wget -q "$URL" -O - | grep -o -E 'href="([^"#]+)"' >> $outFile
    #### get links with single quotes in href
    wget -q "$URL" -O - | grep -o -E "href='([^'#]+)'" >> $outFile
    ## finding uniques non-mggk urls
    sort -u $outFile | sd 'href=' '' | sd '"' '' | sd "'" "" | grep -iv 'mygingergarlic' >> $tmpFile3
done 
}

FUNC_find_non-mggk-hyperlinks-from-these-urls