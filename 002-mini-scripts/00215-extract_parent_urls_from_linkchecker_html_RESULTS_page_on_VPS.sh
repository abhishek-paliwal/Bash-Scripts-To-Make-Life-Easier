#/bin/bash

cdy; 

linkchecker_results_url_page="https://vps.abhishekpaliwal.com//scripts-html-outputs/20221228-linkchecker-out-mggk.html" ; 

echo ">> CURRENT RESULTS URL PAGE IS: $linkchecker_results_url_page" ; 

curl -k "$linkchecker_results_url_page" | grep -i 'parent' | grep -ioE 'http.*"' | sd '"' ''  > $DIR_Y/_OUTPUT_00215-extract_parent_urls_from_linkchecker_html_RESULTS_page_on_VPS.txt
