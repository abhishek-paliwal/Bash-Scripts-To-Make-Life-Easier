#/bin/bash
################################################################################
## THIS SCRIPT EXTRACTS PARENT URLS FROM LINKCHECKER RESULTS PAGE PRESENT ON THE VPS
################################################################################

cd $DIR_Y ; 

## SELECT THE RESULTS PAGE FROM THE FZF DROPDOWN
#linkchecker_results_url_page="https://vps.abhishekpaliwal.com//scripts-html-outputs/20221228-linkchecker-out-mggk.html" ; 
linkchecker_results_url_page=$(curl -k https://vps.abhishekpaliwal.com/tree.html |  grep -i 'linkchecker' | grep -io 'https.*.html"' | sd '"' '' | fzf) ; 

## FINALLY EXTRACTING PARENT URLS FROM CHOSEN RESULTS PAGE
echo; echo; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"; 
echo ">> CURRENT RESULTS URL PAGE IS: $linkchecker_results_url_page" ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"; 
OUTPUT_FILE="$DIR_Y/_OUTPUT_00215-extract_parent_urls_from_linkchecker_html_RESULTS_page_on_VPS.txt" ; 
curl -k "$linkchecker_results_url_page" | grep -i 'parent' | grep -ioE 'http.*"' | sd '"' ''  > "$OUTPUT_FILE"
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"; 
echo ">> OUTPUT FILE SAVED AT: $OUTPUT_FILE" ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"; 

echo ">> OUTPUT IS ALSO PRINTED BELOW ..." ; 
cat "$OUTPUT_FILE"  ;