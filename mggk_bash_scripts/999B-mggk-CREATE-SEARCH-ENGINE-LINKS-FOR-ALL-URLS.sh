#!/bin/bash
################################################################################ 
SCRIPT_NAME=$(basename $0) ;
SCRIPT_NAME_SANS_EXTENSION=$(basename $0 | sed 's/.sh//g') ;
################################################################################ 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## THIS PROGRAM CREATES AN HTML FILE WITH ALL THE SEARCH ENGINE LINKS 
    ## FOR ALL THE MGGK URLS. THE USER CAN THEN CHECK THE PAGE TITLES SEARCHES ON
    ## THOSE SEARCH ENGINES.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: NOV 06, 2020
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

####################### ADDING COLOR TO OUTPUT ON CLI ##########################
echo "Currently sourcing the bash color script, which outputs chosen texts in various colors ..." ;

source $REPO_SCRIPTS/2000_vendor_programs/color-logger.sh

info "This enables use of keywords for coloring, such as: debug, info, error, success, warn, highlight." ;
debug "Read it's help by running: >> bash $DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/color-logger.sh -h"
##############################################################################

##############################################################################
## SETTING VARIABLES
SEARCHDIR="$REPO_MGGK/content" ;
WORKDIR="$DIR_Y" ;
OUTPUT_HTML="$DIR_DROPBOX_SCRIPTS_OUTPUT/OUTPUT_HTML_$SCRIPT_NAME_SANS_EXTENSION.html" ;
##
echo ;
warn "## PRESENT WORKING DIRECTORY = $WORKING_DIR" ;
##############################################################################

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

echo "<h1>All MGGK URLs + Post Titles with their search engines URLs</h1>" >> $OUTPUT_HTML ;
echo "<br>Page updated by script: $SCRIPT_NAME</p>" >> $OUTPUT_HTML ;
echo "<p>Page last updated: $(date)<hr>" >> $OUTPUT_HTML ;

#SEARCH_ENGINES
COUNT=0 ;
#while IFS= read -r line
for mdfile in $(find $SEARCHDIR -type f -name "*.md")
do
    (( COUNT++ )) ;
    echo ">> Currently making search engline links for file => $COUNT " ; 
    ##
    ## Getting Post URL + Title
    mytitle=$( grep -irh '^title:' $mdfile | sed 's/title://g' | sed 's/"//g' | sed "s+'++g" ) ;
    myurl=$( grep -irh '^url:' $mdfile | tr -d [[:space:]] | sed 's+url:+https://www.mygingergarlickitchen.com+g' | sed 's/"//g' ) ;
    ##
    SEARCHTERM="$mytitle" ;
    ##
    echo "<h5>$COUNT) $mytitle</h5>" >> $OUTPUT_HTML
    echo "<p><a target='_blank' href='$myurl'>$myurl</a></p>" >> $OUTPUT_HTML
    ##
    echo "<p>" >> $OUTPUT_HTML
    echo "<a class='btn btn-primary' role='button' target='_blank' href='https://www.google.com/search?q=$SEARCHTERM'>Google</a>" >> $OUTPUT_HTML
    echo "// <a class='btn btn-primary' role='button' target='_blank' href='https://duckduckgo.com/?q=$SEARCHTERM'>DuckDuckGo</a>" >> $OUTPUT_HTML
    echo "// <a class='btn btn-primary' role='button' target='_blank' href='https://www.bing.com/search?q=$SEARCHTERM'>Bing</a>" >> $OUTPUT_HTML
    echo "// <a class='btn btn-primary' role='button' target='_blank' href='https://www.youtube.com/search?q=$SEARCHTERM'>YouTube</a>" >> $OUTPUT_HTML
    echo "</p>" >> $OUTPUT_HTML
done

echo "<!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src='https://code.jquery.com/jquery-3.2.1.slim.min.js' integrity='sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN' crossorigin='anonymous'></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js' integrity='sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q' crossorigin='anonymous'></script>
    <script src='https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js' integrity='sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl' crossorigin='anonymous'></script>
  </div>  
  </body>
</html>"  >> $OUTPUT_HTML ;

#################################### SUMMARY ####################################
echo;
echo "################################## SUMMARY #####################################" ;
success ">>>> SUCCESS // OUTPUT HTML FILE CREATED AT => $OUTPUT_HTML" ;
echo;
success ">>>> You can check it online here: https://downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs/OUTPUT_HTML_999B-mggk-CREATE-SEARCH-ENGINE-LINKS-FOR-ALL-URLS.html" ;
echo "################################################################################" ;
