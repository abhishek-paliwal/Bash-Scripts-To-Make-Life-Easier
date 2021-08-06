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
    ## THIS SCRIPT ASKS FOR USER INPUT FOR KEYWORDS TO SEARCH FOR ALL IMAGES CONTAINING 
    ## THAT KEYWORD. IT THEN DELETES CLOUDFLARE CACHE CORRESPONDING TO THOSE IMAGE URLS
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-08-04
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
step0File="$WORKDIR/$prefixFileName-step0.txt" ; 
step1File="$WORKDIR/$prefixFileName-step1.txt" ; 
step2File="$WORKDIR/$prefixFileName-step2.txt" ;
step3FileHTML="$WORKDIR/$prefixFileName-step3.html" ;

##------------------------------------------------------------------------------
echo "Enter your keyword to find images for: " ; 
read myKeyword ; 
##
if [ -z "$myKeyword" ] ; then 
    echo "CLI Argument is empty. Please try again. Program will exit now." ;
    exit 1 ; 
fi
##------------------------------------------------------------------------------

function step0_FUNC_cloudflare_search_image_paths_containing_keyword () {
    ## function takes no arguments 
    outFile="$step0File" ; ## step0File
    echo "#" > $tmpFile ;
    fd -I -t f -e jpg -e png -e jpeg -e gif --search-path="$REPO_MGGK/static/wp-content/" "$myKeyword" | sort >> $tmpFile
    cat $tmpFile | grep -iv '#' > $outFile ;
    echo ">> DONE = step0_FUNC_cloudflare_search_image_paths_containing_keyword " ;
}

function step1_FUNC_cloudflare_search_image_urls_containing_keyword () {
    ## function takes no arguments 
    inFile="$step0File" ## step0File
    outFile="$step1File" ; ## step1File
    replaceThis1="/Users/abhishek/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/" ; 
    replaceThis2="/home/ubuntu/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/" ; 
    replaceTo="https://www.mygingergarlickitchen.com/" ; 
    ##
    echo "##" > $tmpFile ;
    cat $inFile | sd "$replaceThis1" "$replaceTo"| sd "$replaceThis2" "$replaceTo" | sort | grep -iv '#' >> $tmpFile ;
    cat $tmpFile | grep -iv '#' > $outFile ;
    echo ">> DONE = step1_FUNC_cloudflare_search_image_urls_containing_keyword " ;
}

function step2_FUNC_cloudflare_create_html_page_with_keyword_urls () {
    ## function takes no arguments 
    #### mggk create a html page showing all images with names with given keyword
    inFile="$step1File" ;
    outFile="$step3FileHTML" ;
    echo "<h1>Images for this keyword: $myKeyword</h1>" > $outFile
    for x in $(cat $inFile) ; do 
        echo "<div style='display: inline-block; width: 65px; height: auto; border-style: solid; border-color: black; border-width: 1px; padding: 2px; '><img src='$x' width='100%'><br>$(basename $x)</div>"  >> $outFile ;
    done
    ##
    echo ">> DONE = step2_FUNC_cloudflare_create_html_page_with_keyword_urls " ;
}

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

## CALLING FUNCTIONS
step0_FUNC_cloudflare_search_image_paths_containing_keyword
step1_FUNC_cloudflare_search_image_urls_containing_keyword ;
step2_FUNC_cloudflare_create_html_page_with_keyword_urls ;

## SUMMARY OF OUTPUTS
echo; echo ">> PRINTING WORD COUNTS ... " ;
fd "$prefixFileName" -t f --search-path="$WORKDIR" -x wc {} ;

## ASK USER TO DELETE CACHE OR NOT
echo ;
echo ">> ALSO WANT TO DELETE CLOUDFLARE CACHE, ENTER y OR n : " ;
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
        step3_FUNC_cloudflare_format_urls_for_api "$myFile" ;
        step4_FUNC_cloudflare_delete_cache_for_keyword_urls "$tmpFile1" ;
    done
    ####
else 
    echo ">> Alright, cache WILL NOT BE DELETED." ;
fi

##------------------------------------------------------------------------------
## SUMMARY
echo; 
echo ">> CHECK OUT THE HTML OUTPUT: $step3FileHTML " ;
