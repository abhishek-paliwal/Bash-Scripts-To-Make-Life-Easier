#/bin/bash

cdy; linkchecker_results_url="https://vps.abhishekpaliwal.com//scripts-html-outputs/20221207-linkchecker-out-mggk.html" ; curl -k "$linkchecker_results_url" | grep -i 'parent' | grep -ioE 'http.*"' | sd '"' ''  > _OUTPUT_00215-extract_parent_urls_from_linkchecker_html_RESULTS_page_on_VPS.txt
