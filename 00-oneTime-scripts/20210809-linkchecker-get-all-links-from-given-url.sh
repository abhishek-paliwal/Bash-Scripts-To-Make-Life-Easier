#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## USAGE:
    #### > bash $THIS_SCRIPT_NAME
    ################################################################################
    ## This script runs linkchecker program and extracts all links into a text file
    ## for a given url via user input. Ther user can also provide path to a local 
    ## HTML file to extract the links from.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-08-09
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_tmp_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
##

##################################################################################
## Defining main function
function FUNC_run_linkchecker_for_this_url () {
    inFile="$1" ;
    fileNameSuffix=$(echo $inFile | sd ':' '' | sd '/' '_' | sd '\.' '_' | sd '__' '_' ) ;
    outFile_ALLURLS="$WORKDIR/linkchecker-output-$fileNameSuffix-ALLURLS.txt" ;
    outFile_FILTERED="$WORKDIR/linkchecker-output-$fileNameSuffix-FILTERED.txt" ;
    outFile_ALLIMAGES="$WORKDIR/linkchecker-output-$fileNameSuffix-ALLIMAGES.txt" ;
    tmpFile="$WORKDIR/tmp.txt" ;
    ####
    echo; 
    echo "$inFile // $outFile"
    ## Running linkchecker
    linkchecker --verbose -F text/"$tmpFile" "$inFile" ;
    ## Print all urls
    ag --nonumber 'real url' $tmpFile | sd -f i 'real url' '' | sd ' ' '' | sort -u > $outFile_ALLURLS ;
    ## Filter some urls
    echo ">> Filtering urls and discarding the following ..." ;
    discardThese="(.png|.jpg|.js|.css|.svg|.xml|.html|wa.me|facebook.com|instagram.com|pinterest.com)" ;
    ag --nonumber 'real url' $tmpFile | sd -f i 'real url' '' | sd ' ' '' | grep -ivE "$discardThese" | grep 'myginger' | sort -u > $outFile_FILTERED ;
    ## 
    ## Print only images urls
    echo ">> Filtering urls and discarding the following ..." ;
    includeThese="(.png|.jpg|.jpeg|.gif|.svg)" ;
    ag --nonumber 'real url' $tmpFile | sd -f i 'real url' '' | sd ' ' '' | grep -iE "$includeThese" | sort -u > $outFile_ALLIMAGES ;
    ####
    echo ">> Printing wordcount in outputs ..." ; 
    wc -l $outFile_ALLURLS ;
    wc -l $outFile_FILTERED ;
    wc -l $outFile_ALLIMAGES ;
}
##################################################################################


echo "Enter full URL you want to extract all links for: " ; 
echo ">> OR, you can also enter the filepath to a local html file: "
read myURL ; 

## Calling main function
FUNC_run_linkchecker_for_this_url "$myURL"
