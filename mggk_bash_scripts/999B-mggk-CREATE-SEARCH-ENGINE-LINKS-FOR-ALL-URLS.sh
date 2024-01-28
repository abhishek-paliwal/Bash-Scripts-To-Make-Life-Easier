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

    <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js'></script>
    <link rel='stylesheet' type='text/css' href='https://cdn.datatables.net/v/bs4/dt-1.10.22/datatables.min.css' />
    <script type='text/javascript' src='https://cdn.datatables.net/v/bs4/dt-1.10.22/datatables.min.js'></script>
    <script>
        \$(document).ready(function () {
            \$('#mytable').DataTable();
        });
    </script>

    <title>$SCRIPT_NAME_SANS_EXTENSION - OUTPUT</title>
  </head>
  <body>" > $OUTPUT_HTML

echo "<div class='jumbotron jumbotron-fluid'>
        <div class='container'>
          <h1>All MGGK URLs + Post Titles with their search engines URLs</h1>
          <br>Page updated by script: $SCRIPT_NAME
          <br>Page last updated: $(date)
        </div>
      </div> <div class='container-fluid'> " >> $OUTPUT_HTML ;

echo "<table class='table table-striped' id='mytable' class='display' style='width:100%'>
    <thead>
        <tr>
            <th>Count</th>
            <th>Recipe Title</th>
            <th>URL</th>
            <th>Search Engine Links</th>
        </tr>
    </thead>
    <tbody>"  >> $OUTPUT_HTML ;

#SEARCH_ENGINES
COUNT=0 ;
#while IFS= read -r line
for mdfile in $(find $SEARCHDIR -type f -name "*.md")
do
    (( COUNT++ )) ;
    echo ">> Currently making search engine links for file => $COUNT " ; 
    ##
    ## Getting Post URL + Title
    mytitle=$( grep -irh '^title:' $mdfile | sed 's/title://g' | sed 's/"//g' | sed "s+'++g" ) ;
    myurl=$( grep -irh '^url:' $mdfile | tr -d [[:space:]] | sed 's+url:+https://www.mygingergarlickitchen.com+g' | sed 's/"//g' ) ;
    ##
    SEARCHTERM="$mytitle" ;
    ##
    echo "<tr>" >> $OUTPUT_HTML
    ##
    echo "<td>$COUNT</td>" >> $OUTPUT_HTML
    echo "<td><strong><a target='_blank' href='$myurl'>$mytitle</a></strong></td>" >> $OUTPUT_HTML
    echo "<td><a target='_blank' href='$myurl'>$myurl</a></td>" >> $OUTPUT_HTML
    ##
    echo "<td>" >> $OUTPUT_HTML
    echo "<a class='btn btn-success' role='button' target='_blank' href='https://www.google.com/search?q=$SEARCHTERM'>Google</a>" >> $OUTPUT_HTML
    echo "<br><a class='btn btn-warning' role='button' target='_blank' href='https://duckduckgo.com/?q=$SEARCHTERM'>DuckDuckGo</a>" >> $OUTPUT_HTML
    echo "<br><a class='btn btn-primary' role='button' target='_blank' href='https://www.bing.com/search?q=$SEARCHTERM'>Bing</a>" >> $OUTPUT_HTML
    echo "<br><a class='btn btn-danger' role='button' target='_blank' href='https://www.youtube.com/search?q=$SEARCHTERM'>YouTube</a>" >> $OUTPUT_HTML
    echo "</td>" >> $OUTPUT_HTML
    ##
    echo "</tr>" >> $OUTPUT_HTML

done

echo "</tbody></table>" >> $OUTPUT_HTML ;

echo "</body></html>"  >> $OUTPUT_HTML ;

#################################### SUMMARY ####################################
echo;
echo "################################## SUMMARY #####################################" ;
success ">>>> SUCCESS // OUTPUT HTML FILE CREATED AT => $OUTPUT_HTML" ;
echo;
success ">>>> You can check it online here: https://downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs/OUTPUT_HTML_999B-mggk-CREATE-SEARCH-ENGINE-LINKS-FOR-ALL-URLS.html" ;
echo "################################################################################" ;
