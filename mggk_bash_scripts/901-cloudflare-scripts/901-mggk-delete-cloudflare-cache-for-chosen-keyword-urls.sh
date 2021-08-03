################################################################################ 
## mggk delete cloudflare cache for these urls in array
prefixFileName="_OUTPUT_9999_cloudflare_delete_cache_for_custom_keyword_urls" ;

WORKDIR="$DIR_Y" ;
echo ">> CURRENT WORKDIR = $WORKDIR" ;

tmpFile="$WORKDIR/_tmp.txt" ; 
step0File="$WORKDIR/$prefixFileName-step0.txt" ; 
step1File="$WORKDIR/$prefixFileName-step1.txt" ; 
step2File="$WORKDIR/$prefixFileName-step2.txt" ;
step4FileHTML="$WORKDIR/$prefixFileName-step4.html" ;

##------------------------------------------------------------------------------
echo "Enter your keyword to find images for: " ; 
read myKeyword ; 
##
if [ -z "$myKeyword" ] ; then 
    echo "CLI Argument is empty. Please try again." ; 
fi
##------------------------------------------------------------------------------

function step0_FUNC_cloudflare_search_image_paths_containing_keyword () {
    ## function takes no arguments 
    outFile="$step0File" ; ## step0File
    echo "#" > $tmpFile ;
    fd -I -t f --search-path="$REPO_MGGK/static/wp-content/" "$myKeyword" | sort >> $tmpFile
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

function step2_FUNC_cloudflare_format_urls_for_api () {
    ## function takes no arguments 
    inFile="$step1File" ; ## step1File
    outFile="$step2File" ; ## step2File
    echo "##" > $tmpFile ; 
    for x in $(cat $inFile) ; do 
        echo "\"$x\"," >> $tmpFile ; 
    done ; 
    echo "\"$(head -1 $inFile)\"" >> $tmpFile ;
    cat $tmpFile | grep -iv '#' > $outFile ;
    echo ">> DONE = step2_FUNC_cloudflare_format_urls_for_api " ;
}

function step3_FUNC_cloudflare_delete_cache_for_keyword_urls () {
    ## function takes no arguments 
    inFile="$step1File" ; ## step1File
    for line in $(cat $inFile) ; do
        final_data='{\"files\":[ \"$line\" ]}' ;
        echo "FINAL DATA = $final_data" ; 
        curl -X POST "https://api.cloudflare.com/client/v4/zones/53b0327844e25ed872863f33e465bca0/purge_cache" -H "X-Auth-Email:abhishek+cloudflare@concepro.com" -H "X-Auth-Key:d9072603dee58a63ebac3e3b81fdf9c15d8f8" -H "Content-Type:application/json" --data "$final_data" ;
    done
    ##
    echo ">> DONE = step3_FUNC_cloudflare_delete_cache_for_keyword_urls " ;
}

function step4_FUNC_cloudflare_create_html_page_with_keyword_urls () {
    ## function takes no arguments 
    #### mggk create a html page showing all images with names with given keyword
    inFile="$step1File" ;
    outFile="$step4FileHTML" ;
    for x in $(cat $inFile) ; do 
        echo "<div style='display: inline-block; width: 100px; height: 150px;'><img src='$x' width='100%'><br>$(basename $x)</div>" ; 
    done > $outFile
    ##
    echo ">> DONE = step4_FUNC_cloudflare_create_html_page_with_keyword_urls " ;
}
################################################################################
################################################################################

step0_FUNC_cloudflare_search_image_paths_containing_keyword
step1_FUNC_cloudflare_search_image_urls_containing_keyword ;
step2_FUNC_cloudflare_format_urls_for_api ;
#step3_FUNC_cloudflare_delete_cache_for_keyword_urls; 
step4_FUNC_cloudflare_create_html_page_with_keyword_urls ; 