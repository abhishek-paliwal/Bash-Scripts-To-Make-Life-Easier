#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

######################################################################
## THIS PROGRAM FINDS FOR SEO, THE COUNTS OF EACH OF PARTICULAR KEYWORDS IN
## A COMPETITOR RECIPE URLS, WHICH SHOULD BE PRESENT BEGINNING WITH HTTPS IN 
## THE KEYWORDS FILE. COMPETITOR RECIPE URLS CAN BE AS MANY AS YOU WOULD LIKE.
## KEYWORDS FILE SHOULD HAVE ONE KEYWORD PER LINE.
## DATE: 2024-02-11
## BY: PALI
######################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_SOURCE_SCRIPTS () {
    ####
    source "$REPO_SCRIPTS_MINI/00200a_source_script_to_print_fancy_divider.sh" ;
    # This enables => 'palidivider' command, which prints a fancy divider on cli 
    # Eg. palidivider "THIS IS A TEST STRING." "$palihline | $palialine | $palibline | $palimline | $palipline | $palixline"
    palidivider "Running $FUNCNAME" ;
}
FUNC_SOURCE_SCRIPTS ; 
palidivider ; 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## SETTING VARIABLES
DATEVAR=$(date +%Y%m%d-%H%M%S) ;
WORKDIR="$DIR_Y/_OUTPUT_${THIS_SCRIPT_NAME_SANS_EXTENSION}-${DATEVAR}" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

##
whichKeywordsFile="$WORKDIR/_tmpListOfKeywords.txt" ;
curledFile="$WORKDIR/_tmpcurlfile_00238.html" ; 
echo > "$curledFile" ; ## initialize
urlsToSearchFile="$WORKDIR/_tmpurlsToSearchFile_00238.html" ;
finalKeywordsCountsFile="$WORKDIR/_tmpFinalKeywordsCounts_00238.txt" ; 
echo > $finalKeywordsCountsFile ; ## initialize
##

echo "##------------------------------------------------------------------------------" ; 
echo ">> Select which keywords file to use (txt, csv):" ; 
TMPKeywordsFile=$(fd --search-path="$WORKDIR" --search-path="$DIR_Y" -e txt -e csv | fzf) ; 
dos2unix "$TMPKeywordsFile" ;
##
## take only valid lines + convert all text to lowercase + double spaces to single spaces + only unique lines
grep -iv '^$' "$TMPKeywordsFile" | tr '[:upper:]' '[:lower:]' | sd '  ' ' ' | sort -u > "$whichKeywordsFile" ; 
echo "##------------------------------------------------------------------------------" ; 
read -p "Please enter your competitor URL for keywords count [OR, press ENTER key if URLS are present in keywords file]: " competitorURL ; 
echo "##------------------------------------------------------------------------------" ; 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_GET_URL_DATA_AND_COUNT_GIVEN_KEYWORDS () {
    palidivider "Currently running = $CURRENT_URL_OR_FILE" ; 
    INFILE="$1" ;
    MYCOUNT="$2" ; 
    CURRENT_URL_OR_FILE="$3" ; 
    tmpfile0="$WORKDIR/_tmpfile0.txt" ;
    resultsFileForThisURL="$WORKDIR/_tmpfile00238_URL_${MYCOUNT}.txt" ; 
    ##
    echo > "$tmpfile0" ; ## initialize
    ## read each keyword in that url data file
    while IFS="\n" read line; do 
        numTimes=$(grep -io "$line" "$INFILE" | wc -l | tr -d ' ') ; 
        echo "$numTimes = $line" >> $tmpfile0 ; 
    done < $whichKeywordsFile
    ##
    ## reverse sort numerically 
    palidivider "CURRENT_URL_OR_FILE = $CURRENT_URL_OR_FILE" >> $resultsFileForThisURL ; 
    sort -nr "$tmpfile0" | nl >> $resultsFileForThisURL ; 
    ##
    ## get counts for present and not-present keywords
    COUNT_KEYWORDS_NONZERO=$(grep -iv '^0 =' $tmpfile0 | wc -l | tr -d ' ' ) ; 
    COUNT_KEYWORDS_ZERO=$(grep -i '^0 =' $tmpfile0 | wc -l | tr -d ' ' ) ; 
    echo "$COUNT_KEYWORDS_NONZERO = TOTAL KEYWORDS PRESENT = $CURRENT_URL_OR_FILE " >> $finalKeywordsCountsFile ; 
    #echo "$COUNT_KEYWORDS_ZERO    = TOTAL KEYWORDS NOT-PRESENT = $CURRENT_URL_OR_FILE " >> $finalKeywordsCountsFile ; 
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Find any urls present in keywords file
grep -iE 'https|www' "$whichKeywordsFile" | tr -d ' ' > "$urlsToSearchFile"  ;
## 

## IF the user input provided a url, use that, else use the urls found in keywords file.
if [ -z "$competitorURL" ]; then
  echo "competitorURL is empty. URLS will be found from URLS file = $urlsToSearchFile (if any)" ;
  #### 
  count=0 ; 
  for thisUrl in $(cat "$urlsToSearchFile") ; do 
    ((count++)) ; 
    ## get that url data locally
    downloadedHTMLfile="$curledFile-$count.html" ; 
    curl -sk "$thisUrl" > "$downloadedHTMLfile"  ;
    FUNC_GET_URL_DATA_AND_COUNT_GIVEN_KEYWORDS "$downloadedHTMLfile" "$count" "$thisUrl" ; 
  done 
  ####
  ## Combine the html data of all file and run again
  combinedHTMLfile="$curledFile-99-COMBINED.html" ;
  fd --search-path="$WORKDIR" '_tmpcurlfile_00238' -e html -x cat {} > "$combinedHTMLfile" ; 
  FUNC_GET_URL_DATA_AND_COUNT_GIVEN_KEYWORDS "$combinedHTMLfile" "99" "COMBINED-URLS" ;
  ####
else
  echo "competitorURL is not empty. Keywords will be extracted now." ;
    ## get that url data locally
    downloadedHTMLfile="$curledFile" ; 
    curl -sk "$competitorURL" > "$downloadedHTMLfile"  ;
    FUNC_GET_URL_DATA_AND_COUNT_GIVEN_KEYWORDS "$downloadedHTMLfile" "00" "$competitorURL" ; 
fi

################################################################################

echo ">> DISPLAYING KEYWORD COUNTS SORTED ..." ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
resultsHTMLfile="$WORKDIR/_tmp_resultsHTMLFile.html" ; 
echo > $resultsHTMLfile ; ## initialize
echo "<pre>" >> $resultsHTMLfile ; 
##
## get final keywords counts for all urls
cat $finalKeywordsCountsFile | sort -nr >> $resultsHTMLfile ;

## get results from combined txt file
for myfile in $(fd --search-path="$WORKDIR" '_tmpfile00238_URL' -e txt | grep -i '_tmpfile00238_URL_99' | head -1) ; do 
    ## exlude lines with 0 = zero count for keyword 
    cat "$myfile" | grep -iv '	0 ='  >> "$resultsHTMLfile" ; ## non-zero count keywords
    cat "$myfile" | grep -i '	0 ='   >> "$resultsHTMLfile" ; ## zero count keywords
done 

## get results from other txt files
for myfile in $(fd --search-path="$WORKDIR" '_tmpfile00238_URL' -e txt | grep -iv '_tmpfile00238_URL_99' | sort -nr) ; do 
    ## exlude lines with 0 = zero count for keyword 
    cat "$myfile" | grep -iv '	0 ='  >> "$resultsHTMLfile" ; ## non-zero count keywords
    #cat "$myfile" | grep -i '	0 ='  >> "$resultsHTMLfile" ; ## zero count keywords
done 
echo "</pre>" >> $resultsHTMLfile ; 
##
echo ">> Opening Results HTML file in default browser..." ; 
open "$resultsHTMLfile" ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;  
