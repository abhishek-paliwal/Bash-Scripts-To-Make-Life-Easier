#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ###############################################################################
  ## THIS PROGRAM EXTRACTS 490 TOP URLS FROM LIVE SITEMAP.XML WHICH ARE LATEST UPDATED, 
  ## AND SUBMITS THEM TO BING SEARCH USING BING WEBMASTER API, USING CURL.
  ###############################################################################
  ## Coded by: PALI
  ## On: October 30, 2020
  ###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 
##
MAIN_HUGO_CONTENT_DIR="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content"
FILE_TMP_0="$WORKDIR/_tmp0_bing_sitemap.txt" ;
FILE_TMP_1="$WORKDIR/_tmp1_bing_submission.txt" ;
FILE_TMP_2="$WORKDIR/_tmp2_bing_submission.txt" ;
## API VARIABLES
API_KEY="$API_KEY_MICROSOFT_BING" ; ## from env variable
################################################################################

################################################################################
## BEGIN: FUNCTION DEFINITIONS
################################################################################
function FUNCTION_BING_GETQUOTA () {
    echo; echo ">> BING WEBMASTER TOOLS (STEP 1) => Getting daily + monthly quota ..." ; echo; 
    curl "https://ssl.bing.com/webmaster/api.svc/json/GetUrlSubmissionQuota?siteUrl=https://www.mygingergarlickitchen.com&apikey=$API_KEY"
}
####
function FUNCTION_BING_SUBMIT_BATCH () {
    echo; echo ">> BING WEBMASTER TOOLS (STEP 2) => Batch submitting URLs through CURL API ... " ; echo; 
    echo; echo ">> NOTE: d:null in JSON response means SUCCESSFUL SUBMISSION." ; echo; 
    TMP_BATCH_SUBMIT_TEXT_FINAL="$1" ;
    curl -X POST "https://ssl.bing.com/webmaster/api.svc/json/SubmitUrlBatch?apikey=$API_KEY" -H "Content-Type: application/json" -H "charset: utf-8" -d '{"siteUrl":"https://www.mygingergarlickitchen.com", "urlList":['"$TMP_BATCH_SUBMIT_TEXT_FINAL"']}'
}
################################################################################
## END: FUNCTION DEFINITIONS
################################################################################

##################################################################################
echo; echo ">> Working directory: $WORKDIR" ;
echo "------------------------------------------------------" ;  

##------------------------------------------------------------------------------
## EXTRACTING LATEST UPDATED URLs FROM CURRENT SITEMAP.XML FROM LIVE WEBSITE.
## Because Bing API can only submit 500 URLs at a time, so ...
## ... we will take the first (latest updated) 490 URLs at this time.
#### Downloading sitemap 
wget https://www.mygingergarlickitchen.com/sitemap.xml -O $FILE_TMP_0 ;
#### Extracting top urls
cat $FILE_TMP_0 | grep -i '<loc>' | sed 's+<loc>++g' | sed 's+</loc>++g' | tr -d ' ' | grep -v '/tags/' | grep -v '/categories/' | head -490 > $FILE_TMP_1 ;
## Creating a text variable required for Bing's batch submission
cat $FILE_TMP_1 | sed 's/^/"/g' | sed 's/$/"/g' | tr '\n' ',' > $FILE_TMP_2 ;
echo "\"https://www.mygingergarlickitchen.com/\"" >> $FILE_TMP_2  ;
##------------------------------------------------------------------------------

## CALLING FUNCTIONS
echo; echo "########################### BEFORE SUBMISSION : QUOTA REMAINING #########################"; 
FUNCTION_BING_GETQUOTA
echo; echo; echo "############################### BATCH SUBMISSION ##############################"; 
echo "  >> NUMBER OF URLs TO SUBMIT = $(cat $FILE_TMP_1 | wc -l)" ; echo; 
echo; echo ">> Please note that you can not submit more than 500 URLs at a time using this API. " ; echo; 
TMP_BATCH_SUBMIT_TEXT=$(cat $FILE_TMP_2) ;
FUNCTION_BING_SUBMIT_BATCH $TMP_BATCH_SUBMIT_TEXT
echo; echo; echo "########################### AFTER SUBMISSION : QUOTA REMAINING ##########################"; 
FUNCTION_BING_GETQUOTA
echo; echo;echo "##------------------------------------------------------------------------------"; 
