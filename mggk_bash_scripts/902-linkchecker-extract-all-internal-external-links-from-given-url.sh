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
    ## This script runs linkchecker program and extracts all internal + extarnal + 
    ## images links into various text files for a given url via user input. 
    ## Ther user can also provide path to a local HTML file to extract the links from.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-08-13
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
##
cd $WORKDIR; 

################################################################################
################################################################################
function FUNC_checkValidUrl () { 
    ## This function checks if given url is valid or not
    ## The url needs to begin with http to be valid.
    url="$1" ; 
    url=$(echo $url | sd ' ' '') ;
    if [[ "$url" == http* ]] ; then 
        echo ">> URL is VALID. Program will extract links from it." ; 
    else 
        echo ">> URL is INVALID. Please enter a valid url beginning with http. Program will exit now." ; 
        exit 1 ; 
    fi
}
####
function FUNC_extractUrls () { 
    ## This function checks if given url is valid or not
    url="$1" ; 
    url2txt=$(echo "$url" | sed -e 's/[/:.]/_/g' -e 's/___/_/' ) ;
    urlDomain=$(echo "$url" | sd 'http://' '' | sd 'https://' '' | sd 'www.' '' | cut -d '/' -f1 ) ;
    ##
    outFile_all="$WORKDIR/linkchecker_ALL_$url2txt.txt" ;
    outFile_nondomainurls="$WORKDIR/linkchecker_NONDOMAINURLS_$url2txt.txt" ;
    outFile_domainurls="$WORKDIR/linkchecker_DOMAINURLS_$url2txt.txt" ;
    outFile_allimages="$WORKDIR/linkchecker_ALLIMAGES_$url2txt.txt" ;

    ## Running linkchecker program on given url
    linkchecker --verbose -F csv --ignore-url='$urlDomain' "$url" ;
    ##
    #### Parsing linkchecker csv file (when you cut, columns of interest are f1 and f8)
    ## Finding all links, sorted and unique
    cat linkchecker-out.csv | cut -d';' -f8 | grep -iv '^#' | grep -i 'http' | sort -u > $outFile_all ;
    ## Finding all non-domain links
    cat $outFile_all | grep -iv "$urlDomain" > $outFile_nondomainurls ;
    ## Finding all domain links only
    excludeThese="(.svg|.jpg|.png|.gif|.jpeg|.css|.js|.xml|.html|pinterest.com|facebook.com|youtube.com|wa.me)" ;
    cat $outFile_all | grep -ivE "$excludeThese" | grep -i "$urlDomain" > $outFile_domainurls ;
    ## Finding all images links only
    includeThese="(.svg|.jpg|.png|.gif|.jpeg)" ;
    cat $outFile_all | grep -iE "$includeThese" > $outFile_allimages ;
    ####
    ####
    echo "##------------------------------------------------------------------------------" ;
    echo ">> SUMMARY: "
    echo "URLVAR = $url2txt // URL_DOMAIN PART = $urlDomain" ;
    echo "OUTPUTS SAVED IN = $WORKDIR" ;
    echo "##------------------------------------------------------------------------------" ;
}
################################################################################
################################################################################

echo "Enter your url to extract links from: " ;
read urlVar ;
##
FUNC_checkValidUrl "$urlVar" ;
FUNC_extractUrls "$urlVar" ;