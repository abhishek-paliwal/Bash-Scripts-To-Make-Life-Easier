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
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
time_taken="$WORKDIR/tmp-time-taken-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "$(date) = START-TIME" > $time_taken
##
cd $WORKDIR; 
echo ">> CURRENT WORKDIR = $WORKDIR" ;

prefixFileName="_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
tmpFile="$WORKDIR/_tmp.txt" ; 
tmpFile1="$WORKDIR/_tmp1.txt" ; 
step1File="$WORKDIR/$prefixFileName-step1.txt" ; 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Getting the correct cloudflare zone id based upon cli argument
case "$1" in
    leelasrecipes)
        CLOUDFLARE_ZONE_ID=$CLOUDFLARE_ZONE_ID_LEELASRECIPES ;
        XML_SITEMAP="https://www.leelasrecipes.com/sitemap.xml" ;
        ;;
    ado)
        CLOUDFLARE_ZONE_ID=$CLOUDFLARE_ZONE_ID_ADO ;
        XML_SITEMAP="https://www.adoria.xyz/sitemap.xml" ;
        ;;
    mggk)
        CLOUDFLARE_ZONE_ID=$CLOUDFLARE_ZONE_ID_MGGK ;
        XML_SITEMAP="https://www.mygingergarlickitchen.com/sitemap.xml" ;
        ;;
    *)
        CLOUDFLARE_ZONE_ID=$CLOUDFLARE_ZONE_ID_MGGK ;
        XML_SITEMAP="https://www.mygingergarlickitchen.com/sitemap.xml" ;
esac
echo ">> CHOSEN ZONE ID => $CLOUDFLARE_ZONE_ID" ; echo; 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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
    curl -X POST "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/purge_cache" -H "X-Auth-Email:$CLOUDFLARE_EMAIL" -H "X-Auth-Key:$API_KEY_CLOUDFLARE_PURGE" -H "Content-Type:application/json" --data "$final_data" ;
    ##
    echo ">> DONE = step4_FUNC_cloudflare_delete_cache_for_keyword_urls " ;
}

function step5_FUNC_cloudflare_find_cache_hit_status_for_keyword_urls () {
    ## function takes one argument as texfile containing urls
    inFile="$1" ;
    echo; echo ">> Finding cache hit status for keyword urls ... " ;
    ##
    TOTAL_COUNT=$(cat $inFile | wc -l | sd ' ' '') ;
    COUNT=0;
    for myurl in $(cat $inFile); do 
        ((COUNT++)) ;
        echo ">> ($COUNT of $TOTAL_COUNT) // CURRENT URL = $myurl" ; 
        curl -skI "$myurl" | grep -i 'cache-status' ; 
    done
    echo ">> DONE = step5_FUNC_cloudflare_find_cache_hit_status_for_keyword_urls " ;
}
################################################################################
################################################################################

##------------------------------------------------------------------------------
## ASK FOR USER INPUT
##------------------------------------------------------------------------------
echo "[Enter 0  (= zero) if you have a single url (with http/https): " ; 
echo "[Enter 1  (= one) if you want to delete cache for MGGK Homepage only: " ; 
echo "[Enter 2  (= two) if you want to delete cache for top 20 MGGK URLS only: " ;
echo "[Enter 3  (= three) if you want to delete cache for existing URLs containing new link [user provided keyword url]: " ; 
echo "[Enter 4  (= four) if you have multiple urls: " ; 
echo "[Enter 5  (= five) if you want to delete cache for latest 50 MGGK URLS only: " ;
echo "[Enter 99 if you want to delete cache for all urls in mggk sitemap.xml file: " ; 
##
read myKeyword ; 
##
if [ -z "$myKeyword" ] ; then 
    echo ">> ERROR NOTE: CLI Argument is empty. Please try again. Program will exit now." ;
    exit 1 ; 
elif [ "$myKeyword" == "0" ]; then
    echo "Enter a single url (with http/https) to delete the cloudflare cache ..." ;
    read singleUrl ; 
    echo ">> Cloudflare cache will be deleted for this URL: $singleUrl" ;
    echo "$singleUrl" > $step1File ; 
elif [ "$myKeyword" == "1" ]; then
    echo ">> The cache will be deleted for MGGK Homepage only ..." ;
    mggk_homepage="https://www.mygingergarlickitchen.com/"
    echo "$mggk_homepage" > $step1File ;
elif [ "$myKeyword" == "2" ]; then
    echo ">> The cache will be deleted for top 20 MGGK URLS only ..." ;
    grep -irh 'url: ' $REPO_MGGK/content/allrecipes/001-020/ | sd 'url: ' 'https://www.mygingergarlickitchen.com' > $step1File ; 
    echo ">> CACHE WILL BE DELETED FOR THESE URLs ..." ; 
    cat $step1File ; 
elif [ "$myKeyword" == "3" ]; then
    echo ">> The cache will be deleted for existing URLs containing new link [user provided keyword url] ..." ;
    echo ">>>> ENTER NEW URL KEYWORD: ";
    read newURLKeyword ; 
    ####
    if [ -z "$newURLKeyword" ] ; then 
        echo "*** ERROR NOTE: NEW URL KEYWORD is empty. Please try again. Program will exit now. ***" ;
        exit 1 ; 
    else
        for x in $(ag -l "$newURLKeyword" "$REPO_MGGK/content/" ); do grep -irh 'url: ' $x ; done | sed -e 's/url: //g' -e 's|^|https://www.mygingergarlickitchen.com|g' > $step1File ; 
        echo ">> CACHE WILL BE DELETED FOR THESE URLs ..." ; 
        cat $step1File ; 
    fi
    ####
elif [ "$myKeyword" == "4" ]; then
    echo ">> Please enter all your urls in this file (one url per line // no limit on number of urls): $step1File" ;
    touch $step1File ; rm $step1File ;
    $EDITOR $step1File ; ## Opening file in default editor
    sleep 4; ## wait for 4 seconds
elif [ "$myKeyword" == "5" ]; then
    echo ">> The cache will be deleted for latest 50 posts from sitemap.xml ..." ;
    curl -sk "$XML_SITEMAP" | grep -o '<loc>.*</loc>' | sed -E 's/<\/?loc>//g' | grep -iv 'categories' | head -50 > "$step1File" ;
    echo ">> CACHE WILL BE DELETED FOR THESE URLs ..." ; 
    cat $step1File ; 
elif [ "$myKeyword" == "99" ]; then
    echo ">> The cache will be deleted for all current urls in SITEMAP.XML file [meaning about 1000 URLs ...]" ;
    echo ">> DO YOU WANT TO DELETE CLOUDFLARE CACHE, ENTER y OR n : " ;
    read CacheToDelete ;
    ####
    if [ "$CacheToDelete" == "y" ]; then
        curl -sk "$XML_SITEMAP" | grep -i '<loc>' | sed -e 's|<loc>||g' -e 's|</loc>||g' -e 's| ||g' | sort > "$step1File" ;
    else
        echo "*** NOTE: Very well! Looks like you don't want to delete the cache for about 1000 URLs. Program will exit now. ***" ;
        exit 1 ;      
    fi
    ####    
else 
    echo "*** ERROR NOTE: Invalid choice, Prorgram will exit now. Run it again if desired. ***" ;
    exit 1 ; 
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
    ## Add these urls => Delete cache for these two urls everytime ...
    echo "** Adding sitemap.xml + index.xml urls to the delete list ...**" ;
    echo "https://www.mygingergarlickitchen.com/" >> $inFile ;
    echo "https://www.mygingergarlickitchen.com/index.xml" >> $inFile ;
    echo "https://www.mygingergarlickitchen.com/sitemap.xml" >> $inFile ;
    ##
    echo ">> Splitting file (= $inFile_base ) into multiple files with 28 lines each ..." ;
    fd 'xa|xb|xc|xd|xe' -t f --search-path="$WORKDIR" -x rm {} ; ## Deleting already present x** files
    split -l 28 $inFile ; ## Actual splitting
    ## SUMMARY OF OUTPUTS
    echo; echo ">> PRINTING WORD COUNTS ... " ;
    fd 'xa|xb|xc|xd|xe' -t f --search-path="$WORKDIR" -x wc {} ;
    ####
    ## Actual deletion of cache
    for myFile in $(fd 'xa|xb|xc|xd|xe' -t f --search-path="$WORKDIR"); do 
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><>>>>" ; 
        step3_FUNC_cloudflare_format_urls_for_api "$myFile" ;
        step4_FUNC_cloudflare_delete_cache_for_keyword_urls "$tmpFile1" ;
        echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ; 
    done
    ####
    ## Finding cache hit status two times (because in case of MISS, it will be a HIT 2nd time)
    step5_FUNC_cloudflare_find_cache_hit_status_for_keyword_urls "$step1File" ;
    step5_FUNC_cloudflare_find_cache_hit_status_for_keyword_urls "$step1File" ;
    ####
else 
    echo "*** IMPORTANT NOTE: Alright, cache WILL NOT BE DELETED. ***" ;
fi

##------------------------------------------------------------------------------
## SUMMARY
echo; echo ">> CACHE DELETED FOR THESE URLS ... " ;
cat "$step1File" | nl

################################################################################
############################### PROGRAM ENDS ###################################
################################################################################
echo;
echo "##------------------------------------------------------------------------------" ;
echo ">> RUNTIME SUMMARY: " ; 
echo "$(date) = END-TIME" >> $time_taken
cat $time_taken
