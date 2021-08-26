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
    ## This script runs linkchecker program and extracts all internal + external + 
    ## images links into various text files for a given url via user input. 
    ## Ther user can also provide path to a local HTML file to extract the links from.
    #########################################
    ## IF THE USER INPUT IS ONE LINE, THEN IT WILL BE TAKEN FROM INPUT, ELSE
    ## IN CASE OF MULTIPLE URLS, IT WILL BE READ FROM AN EXTERNAL TEXT FILE IN PWD.
    ## THIS FILE WILL BE OPENED IN THE EDITOR AUTOMATICALLY FOR EDITING.
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
#######################################
function FUNC_extractUrls () { 
    ## This function checks if given url is valid or not
    url="$1" ; 
    echo ">> Extracting links for this url: $url" ;
    ##
    url2txt=$(echo "$url" | sed -e 's/[/:.]/_/g' -e 's/___/_/' ) ;
    urlDomain=$(echo "$url" | sd 'http://' '' | sd 'https://' '' | sd 'www.' '' | cut -d '/' -f1 ) ;
    ##
    outFile_all="$WORKDIR/linkchecker_step1_ALLLINKS_$url2txt.txt" ;
    outFile_externalurls="$WORKDIR/linkchecker_step2_EXTERNALURLS_$url2txt.txt" ;
    outFile_domainurls="$WORKDIR/linkchecker_step3_DOMAINURLS_$url2txt.txt" ;
    outFile_allimages="$WORKDIR/linkchecker_step4_ALLIMAGES_$url2txt.txt" ;
    outFile_allimages_filtered="$WORKDIR/linkchecker_step5_ALLIMAGES_FILTERED_$url2txt.txt" ;
    ####
    ## Running linkchecker program on given url (creates a linkchecker-out.csv file)
    #linkchecker --verbose -F csv --ignore-url='$urlDomain' "$url" ;
    linkchecker --verbose -F csv -r1 --ignore-url="$urlDomain" --no-follow-url="$urlDomain" "$url" ;
    ##
    #### Parsing linkchecker csv file (when you cut, columns of interest are f1 and f8)
    ## Finding all links, sorted and unique
    cat linkchecker-out.csv | cut -d';' -f8 | grep -iv '^#' | grep -i 'http' | sort -u > $outFile_all ;
    
    ## Finding all non-domain links
    excludeTheseDomains="(pinterest.com|facebook.com|youtube.com|wa.me|instagram.com|twitter.com|gravatar.com)" ;
    cat $outFile_all | grep -iv "$urlDomain" | grep -ivE "$excludeTheseDomains" > $outFile_externalurls ;
    
    ## Finding all domain links only
    excludeThese="(.svg|.jpg|.png|.gif|.jpeg|.css|.js|.xml|.html|pinterest.com|facebook.com|youtube.com|wa.me|twitter.com|instagram.com)" ;
    cat $outFile_all | grep -ivE "$excludeThese" | grep -i "$urlDomain" > $outFile_domainurls ;
    
    ## Finding all images links only
    includeThese="(.svg|.jpg|.png|.gif|.jpeg)" ;
    cat $outFile_all | grep -iE "$includeThese" | grep -ivE "$excludeTheseDomains" > $outFile_allimages ;
    
    ## Selecting only some images
    grep -ivE "[[:digit:]]{2}x[[:digit:]]{2}" $outFile_allimages | grep -i 'uploads/' > $outFile_allimages_filtered 
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

## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
##
cd $WORKDIR; 
echo ">> CURRENT WORKDIR = $WORKDIR" ;

prefixFileName="_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
linksFile="$WORKDIR/$prefixFileName-linksFile.txt" ; 

##------------------------------------------------------------------------------
## ASK FOR USER INPUT
##------------------------------------------------------------------------------
echo "Enter a single url to extract links from (with http/https), OR ..." ;
echo "[Enter 0 (= zero) if you have multiple urls: " ; 
echo "[Enter 99 if you want to extract links for all urls in mggk sitemap.xml file: " ; 
##
read urlVar ; 
##
if [ -z "$urlVar" ] ; then 
    echo "CLI Argument is empty. Please try again. Program will exit now." ;
    exit 1 ; 
elif [ "$urlVar" == "0" ]; then
    echo ">> Please enter all your urls in this file (one url per line // no limit on number of urls): $linksFile" ;
    touch $linksFile ; rm $linksFile ;
    $EDITOR $linksFile ; ## Opening file in default editor
elif [ "$urlVar" == "99" ]; then
    echo ">> The links will be extracted from all current urls in MGGK sitemap.xml file." ;
    allUrlsFile="https://downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs/mggk_summary_cloudflare_AllValidSiteUrls.txt" ;
    curl -s "$allUrlsFile" --output "$linksFile" ;
else 
    echo ">> Links will be extracted for this URL: $urlVar" ;
    echo "$urlVar" > $linksFile ; 
fi
##------------------------------------------------------------------------------

##------------------------------------------------------------------------------
## ASK USER INPUT TO EXTRACT LINKS OR NOT
echo ;
echo ">> DO YOU WANT TO EXTRACT LINKS OR NOT? ENTER y OR n : " ;
read extractLinks ;
##
if [ "$extractLinks" == "y" ]; then
    echo ">> Alright, links WILL BE EXTRACTED." ;
    inFile="$linksFile" ;
    ####
    for singleURL in $(cat $inFile); do 
        FUNC_checkValidUrl "$singleURL" ;
        FUNC_extractUrls "$singleURL" ;
    done 
    ####
else 
    echo ">> Alright, links WILL NOT BE EXTRACTED." ;
fi

##------------------------------------------------------------------------------

##------------------------------------------------------------------------------
## SUMMARY
echo; echo ">> LINKS EXTRACTED FOR THESE URLS ... " ;
cat "$linksFile" | nl
