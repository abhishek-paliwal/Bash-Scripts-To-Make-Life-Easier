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
    ## THIS PROGRAM READS ALL MD FILES IN CURRENT DIRECTORY RECURSIVELY, AND THEN 
    ## EXTRACTS THEIR URLS AND CREATES AN HTML OUTPUT FILE WITH THEIR LOCALHOST AND
    ## MGGK URLS.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-08-29
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
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

##############################################################################
function FUNC_CREATE_HYPERLINKS_FROM_MDFILES_IN_ALL_SUBDIRS () {
    myDir="$1" ; 
    myDir_basename=$(basename $myDir) ;
    echo ">> CURRENT DIR => $myDir_basename" ; 
    ##
    htmlfile="$WORKDIR/_output-hyperlinks_DIR-$myDir_basename.html" ; 
    echo "<h1>Dir = $myDir_basename</h1>" > $htmlfile ; 
    echo "<p><strong>Date created = $(date)</strong></p>" >> $htmlfile ; 
    #3
    urls_found_in_mdfiles="$WORKDIR/_tmp_urls_found_in-DIR-$myDir_basename.txt" ; 
    ag --no-filename "url:" "$myDir" | sd " " "" | sd "url:" "" | grep -iv '^$' |sort > $urls_found_in_mdfiles ;
    total_count="$(cat $urls_found_in_mdfiles | wc -l | sd ' ' '')" ;
    ##
    url1="http://localhost:1313" ; 
    url2="https://www.mygingergarlickitchen.com" ; 
    count=0 ; 
    for x in $(cat $urls_found_in_mdfiles) ; do 
        ((count++)) ; 
        echo ">> CURRENTLY READING URL => $count of $total_count => $x" ;
        echo "<p>$count = <a href=\"$url2$x\">MGGK</a> // <a href=\"$url1$x\">LOCALHOST</a> // $x </p>" >> $htmlfile ;
    done 
    ####
    echo; echo ">> SUMMARY => HTML output created => $htmlfile" ;
}
##############################################################################

## CALLING FUNCTION
currentDir="$(pwd)" ;
for subdirFound in $(fd -I -t d --search-path="$currentDir") ; do 
    FUNC_CREATE_HYPERLINKS_FROM_MDFILES_IN_ALL_SUBDIRS "$subdirFound" ;
done 