
#!/bin/bash
################################################################################ 
SCRIPT_NAME=$(basename $0) ;
SCRIPT_NAME_SANS_EXTENSION=$(basename $0 | sed 's/.sh//g') ;
################################################################################ 
SEARCHDIR="$REPO_MGGK/content" ;
WORKDIR="$DIR_Y" ;
FILE_ALL_URLS="$WORKDIR/_tmp_all_urls_$SCRIPT_NAME_SANS_EXTENSION.txt" ;
OUTPUT_HTML="$DIR_DROPBOX_SCRIPTS_OUTPUT/TMP_OUTPUT_HTML_$SCRIPT_NAME_SANS_EXTENSION.html" ;

################################################################################ 

echo "<!doctype html>
<html lang='en'>
  <head>
    <!-- Required meta tags -->
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
    <!-- Bootstrap CSS -->
    <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css' integrity='sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm' crossorigin='anonymous'>
    <title>$SCRIPT_NAME_SANS_EXTENSION - OUTPUT</title>
  </head>
  <body><div class='container'>" > $OUTPUT_HTML

echo "<h1>All MGGK post titles and their search engines URLs</h1>" >> $OUTPUT_HTML ;
echo "<p>Page last updated: $(date)" >> $OUTPUT_HTML ;
echo "<br>Page updated by script: $SCRIPT_NAME</p><hr>" >> $OUTPUT_HTML ;


## Getting all URLS
grep -irh '^title:' $SEARCHDIR/** | sort | sed 's/title://g' | sed 's/"//g' | sed "s+'++g"  > $FILE_ALL_URLS

#SEARCH_ENGINES
COUNT=0 ;
while IFS= read -r line
do
    (( COUNT++ )) ;
    echo "<h5>$COUNT) $line</h5>" >> $OUTPUT_HTML
    ##
    SEARCHTERM="$line" ;
    ##
    echo "<p>" >> $OUTPUT_HTML
    echo "<a class='btn btn-primary' role='button' target='_blank' href='https://www.google.com/search?q=$SEARCHTERM'>Google</a>" >> $OUTPUT_HTML
    echo "// <a class='btn btn-primary' role='button' target='_blank' href='https://duckduckgo.com/?q=$SEARCHTERM'>DuckDuckGo</a>" >> $OUTPUT_HTML
    echo "// <a class='btn btn-primary' role='button' target='_blank' href='https://www.bing.com/search?q=$SEARCHTERM'>Bing</a>" >> $OUTPUT_HTML
    echo "// <a class='btn btn-primary' role='button' target='_blank' href='https://www.youtube.com/search?q=$SEARCHTERM'>YouTube</a>" >> $OUTPUT_HTML
    echo "</p>" >> $OUTPUT_HTML
done < "$FILE_ALL_URLS"

echo "<!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src='https://code.jquery.com/jquery-3.2.1.slim.min.js' integrity='sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN' crossorigin='anonymous'></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js' integrity='sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q' crossorigin='anonymous'></script>
    <script src='https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js' integrity='sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl' crossorigin='anonymous'></script>
  </div>  
  </body>
</html>"  >> $OUTPUT_HTML ;