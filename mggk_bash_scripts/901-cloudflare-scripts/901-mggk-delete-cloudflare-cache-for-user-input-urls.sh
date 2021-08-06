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
    ## THIS SCRIPT ASKS FOR USER INPUT FOR THE MGGK URLS FOR WHICH THE USER WANTS
    ## TO DELETES CLOUDFLARE CACHE.
    ## IF THE USER INPUT IS ONE LINE, THEN IT WILL BE TAKEN FROM INPUT, ELSE
    ## IN CASE OF MULTIPLE URLS, IT WILL BE READ FROM AN EXTERNAL TEXT FILE IN PWD
    ## WHICH WILL BE OPENED IN THE EDITOR AUTOMATICALLY.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-08-06
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################ 
WORKDIR="$DIR_Y/_TMP_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p "$WORKDIR" ;
cd $WORKDIR; 
echo ">> CURRENT WORKDIR = $WORKDIR" ;

prefixFileName="_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
tmpFile="$WORKDIR/_tmp.txt" ; 
tmpFile1="$WORKDIR/_tmp1.txt" ; 
step1File="$WORKDIR/$prefixFileName-step1.txt" ; 

################################################################################
## FUNCTION DEFINITIONS
################################################################################
function step3_FUNC_cloudflare_format_urls_for_api () {
    ## function takes no arguments 
    inFile="$1" ;
    outFile="$tmpFile1" ; 
    echo "##" > $tmpFile ; 
    for x in $(cat $inFile) ; do 
        echo "\"$x\"," >> $tmpFile ; 
    done ; 
    echo "\"$(head -1 $inFile)\"" >> $tmpFile ;
    cat $tmpFile | grep -iv '#' | sd '\n' '' > $outFile ;
    echo ">> DONE = step2_FUNC_cloudflare_format_urls_for_api (=> for this FILE: $inFile )" ;
}

function step4_FUNC_cloudflare_delete_cache_for_keyword_urls () {
    ## function takes one argument as texfile with less than 30 urls
    inFile="$1" ;
    echo ">> Deleting cache keyword urls ... max 30 urls are allowed per api purge call ..." ;
    url_array=$(cat $inFile) ;
    final_data="{ "'"files"'":[ $url_array ]}" ;
    #echo "FINAL DATA = $final_data" ; 
    curl -X POST "https://api.cloudflare.com/client/v4/zones/53b0327844e25ed872863f33e465bca0/purge_cache" -H "X-Auth-Email:$CLOUDFLARE_EMAIL" -H "X-Auth-Key:$API_KEY_CLOUDFLARE_PURGE" -H "Content-Type:application/json" --data "$final_data" ;
    ##
    echo ">> DONE = step4_FUNC_cloudflare_delete_cache_for_keyword_urls " ;
}
################################################################################
################################################################################

##------------------------------------------------------------------------------
## ASK FOR USER INPUT
##------------------------------------------------------------------------------
echo "Enter a single url (with http/https) to delete the cloudflare cache, OR ..." ;
echo "[Enter 0 (= zero) if you have multiple urls]: " ; 
read myKeyword ; 
##
if [ -z "$myKeyword" ] ; then 
    echo "CLI Argument is empty. Please try again. Program will exit now." ;
    exit 1 ; 
elif [ "$myKeyword" == "0" ]; then
    echo ">> Please enter all your urls in this file (one url per line // no limit on number of urls): $step1File" ;
    touch $step1File ; rm $step1File ;
    $EDITOR $step1File ; ## Opening file in default editor
else 
    echo ">> Cloudflare cache will be deleted for this URL: $myKeyword" ;
    echo "$myKeyword" > $step1File ; 
fi

##------------------------------------------------------------------------------

## ASK USER TO DELETE CACHE OR NOT
echo ;
echo ">> DO YOU WANT TO DELETE CLOUDFLARE CACHE, ENTER y OR n : " ;
read CacheDelete ;
if [ "$CacheDelete" == "y" ]; then
    echo ">> Alright, cache WILL BE DELETED." ;
    ##
    inFile="$step1File" ; ## step1File
    inFile_base=$(basename $inFile) ; 
    echo ">> Splitting file (= $inFile_base ) into multiple files with 28 lines each ..." ;
    fd 'xa' -t f --search-path="$WORKDIR" -x rm {} ; ## Deleting already present xa files
    split -l 28 $inFile ; ## Actual splitting
    ## SUMMARY OF OUTPUTS
    echo; echo ">> PRINTING WORD COUNTS ... " ;
    fd 'xa' -t f --search-path="$WORKDIR" -x wc {} ;
    ####
    ## Actual deletion of cache
    for myFile in $(fd 'xa' -t f --search-path="$WORKDIR"); do 
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><>>>>" ; 
        step3_FUNC_cloudflare_format_urls_for_api "$myFile" ;
        step4_FUNC_cloudflare_delete_cache_for_keyword_urls "$tmpFile1" ;
        echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ; 
    done
    ####
else 
    echo ">> Alright, cache WILL NOT BE DELETED." ;
fi

##------------------------------------------------------------------------------
## SUMMARY
echo; echo ">> CACHE DELETED FOR THESE URLS ... " ;
cat "$step1File" | nl

