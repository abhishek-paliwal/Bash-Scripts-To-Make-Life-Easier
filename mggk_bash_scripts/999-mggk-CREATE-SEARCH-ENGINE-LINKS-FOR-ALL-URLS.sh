
#!/bin/bash
################################################################################ 
SCRIPT_NAME_SANS_EXTENSION=$(basename $0 | sed 's/.sh//g') ;
################################################################################ 
SEARCHDIR="$REPO_MGGK/content" ;
WORKDIR="$DIR_Y" ;
FILE_ALL_URLS="$WORKDIR/_tmp_all_urls_$SCRIPT_NAME_SANS_EXTENSION.txt" ;
OUTPUT_HTML="$WORKDIR/_tmp_FINAL_HTML_$SCRIPT_NAME_SANS_EXTENSION.html"
echo "<html><head><title>$SCRIPT_NAME_SANS_EXTENSION - OUTPUT</title></head><body>" > $OUTPUT_HTML ;
echo "<h1>All MGGK post titles and their search engines URLs</h1>" >> $OUTPUT_HTML ;
echo "<h3>Page last updated: $(date)</h3><hr>" >> $OUTPUT_HTML ;

################################################################################ 

## Getting all URLS
grep -irh '^title:' $SEARCHDIR/** | sort | sed 's/title://g' | sed 's/"//g' | sed "s+'++g"  > $FILE_ALL_URLS

#SEARCH_ENGINES
COUNT=0 ;
while IFS= read -r line
do
    (( COUNT++ )) ;
    echo "$COUNT // $line" >> $OUTPUT_HTML
    ##
    SEARCHTERM="$line" ;
    ##
    echo "<br>" >> $OUTPUT_HTML 
    echo "// <a href='https://www.google.com/search?q=$SEARCHTERM'>Google</a>" >> $OUTPUT_HTML 
    echo "// <a href='https://duckduckgo.com/?q=$SEARCHTERM'>DuckDuckGo</a>" >> $OUTPUT_HTML
    echo "// <a href='https://www.bing.com/search?q=$SEARCHTERM'>Bing</a>" >> $OUTPUT_HTML
    echo "<br><br>" >> $OUTPUT_HTML
done < "$FILE_ALL_URLS"

echo "</body></html>" >> $OUTPUT_HTML ;
