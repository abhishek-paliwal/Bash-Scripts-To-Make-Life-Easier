#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
##
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## USAGE:
    #### > bash $THIS_SCRIPT_NAME
    ################################################################################
    ## THIS SCRIPT MAKES AN INDEX HTML FILE FROM RECIPE-STEPS-IMAGES DIRECTORY. THIS 
    ## CONTAINS LINKS TO OTHER INDEX FILES CORRESPONDING TO SUB-DIRECTORIES. THESE INDEX
    ## HTML FILES SHOWS ALL JPG IMAGES IN THOSE SUB-DIRECTORIES, FOR CHECKING. 
    #### NOTES: This program uses python-yq and jq utilities.
    #### Installation instructions: https://pypi.org/project/yq/
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: JAN 13, 2021
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
## SETTING VARIABLES
MAIN_DIR="$REPO_MGGK/static/wp-content/recipe-steps-images" ;
BASE_URL="https://www.mygingergarlickitchen.com/wp-content/recipe-steps-images" ;
MGGK_URL="https://www.mygingergarlickitchen.com" ;
MAIN_INDEX_HTMLFILE_URL="$BASE_URL/index-recipe-steps-images.html" ;
##
main_index_htmlfile="$REPO_MGGK/static/wp-content/recipe-steps-images/index-recipe-steps-images.html" ;

##------------------------------------------------------------------------------
## BEGIN: FUNCTION TO OUTPUT THE MARKDOWN FILE PATH FOR AN ENTERED MGGK URL
## AS COMMAND LINE ARGUMENT
function FUNCTION_OUTPUT_MDFILE_FULLPATH () {
  SEARCHDIR="$REPO_MGGK/content" ;
  ## CREATING SEARCH_URL FROM THE USER INPUT
  SEARCHURL=$(echo $1 | sed 's|https://www.mygingergarlickitchen.com||g')
  ## EXIT THE SCRIPT IF THE ENTERED URL IS NOT PROPER
  if [[ "$SEARCHURL" == "/" ]] || [[ "$SEARCHURL" == "" ]] ; then exit 1; fi
  ## COUNT THE NUMBER OF FILES WITH CURRENT URL IN YAML FRONTMATTER.
  ## THE ANSWER SHOULD ONLY BE 1. BUT JUST TO MAKE SURE, RUN THE FOLLOWING COMMAND.
  NUM_FILES=$(grep -irl "url: $SEARCHURL" $SEARCHDIR | wc -l | tr -d '[:space:]') ;
  ## Check, how many files with this url are returned. Exit, if more than 1.
  if [[ "$NUM_FILES" -eq 0 ]] || [[ "$NUM_FILES" -gt 1 ]] ; then exit 1; fi
  ## SEARCH FOR THE MD FILE WHERE THE URL LIES IN THE YAML FRONTMATTER
  grep -irl "url: $SEARCHURL" $SEARCHDIR | head -1 ;
}
## END: FUNCTION
#MDFILE_WITH_CHOSEN_URL=$(FUNCTION_OUTPUT_MDFILE_FULLPATH "YOUR-CHOSEN-URL") ;
##------------------------------------------------------------------------------

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SETTING HTML HEADER AND FOOTER
html_header="<html lang='en' >
<head>
    <!-- Required meta tags -->
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
	<meta http-equiv='refresh' content='60'> <!-- Refresh every 60 seconds -->
	<!-- Loading moment.js from CDN -->
	<script src='https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js'></script>
	<title>INDEX OF RECIPE STEPS IMAGES</title>
  </head>
<body>" ;

date_var=$(date +%Y%m%d" "%H:%M:%S) ;

html_body_script_footer="<!-- BEGIN: Scripts will load below -->
<script type='text/javascript'>
    // format TODAY
    let today = moment().format('MMMM Do YYYY, h:mm:ss a') ;
    document.getElementById('currentDateDisplay').innerHTML = today;
    // formatting: list of Event dates below, relative time from today
    let time_from_now = moment(\"$date_var\", \"YYYYMMDD h:mm:dd\").fromNow() ;
    document.getElementById('printTimeFromNow').innerHTML = time_from_now ;
</script>"
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Initializing main_index_htmlfile
echo "$html_header" > $main_index_htmlfile ;
##
echo "<h1>INDEX OF ALL HTML INDEX FILES IN DIR => recipe-steps-images</h1>" >> $main_index_htmlfile ;
echo "Page created by script: " >> $main_index_htmlfile ;
echo "Page Updated: <strong><span id='printTimeFromNow'></span></strong>, at $(date +%Y-%m-%d-T%H:%M:%S) // Currently it's <span id='currentDateDisplay'></span><hr>" >> $main_index_htmlfile ;

num_files=$(fd . $MAIN_DIR -t d | wc -l)
echo "<strong>Number of sub-directories found => $num_files</strong>" >> $main_index_htmlfile ;
echo "<hr>" >> $main_index_htmlfile ;

echo "<table border='1' width='100%'>" >> $main_index_htmlfile ;
echo "<tr> <td>#</td> <td>SUB-DIRECTORY (HTML INDEX FILE LINKED)</td> <td>NUMBER OF JPG IMAGES FOUND IN SUB-DIR</td> <td>ERROR MSG</td> <td>GOTO MGGK PAGE</td> </tr>" >> $main_index_htmlfile ;

##+++++++++++++++++++++++++++++++++++++++++
COUNT=1;
## Looping through all directories present in MAIN_DIR
for x in $(fd . $MAIN_DIR -t d); do 
##
    this_dirname="$(basename $x)" ;
    thisdir_index_htmlfile="index-$this_dirname.html" ; 
    htmlfile="$x/$thisdir_index_htmlfile" ; 
    
    #echo "$this_dirname // $htmlfile" ; 
    echo "  >> Creating HTML index file (recipe steps images directory) = $COUNT of $num_files " ;

    ## Initializing htmlfile
    num_files_in_this_dir=$(fd . $x -e jpg | wc -l | sed 's/ //g') ;
    echo "<h1>JPG images in this sub-directory = $num_files_in_this_dir <pre>$this_dirname</pre></h1>" > $htmlfile ;
    echo "Page updated: The same time when the main index page is updated. (<a href='$MAIN_INDEX_HTMLFILE_URL'>See here</a>)<hr>" >> $htmlfile ;

    ## Making links for all jpg files in current directory
    for fname in $(fd . $x -e jpg); do 
        this_fname="$(basename $fname)" ;
        echo "<img style='border: 2px solid #000000 ;' src='$BASE_URL/$this_dirname/$this_fname' width='300px'>" >> $htmlfile ;
    done
    ##
    ##################### BEGIN: yq + jq block #####################
    ## Getting mdfile name from dirname url + counting recipe steps in it (via yq and jq)
    url_from_dirname="/$this_dirname/" ;
    MDFILE_WITH_CHOSEN_URL=$(FUNCTION_OUTPUT_MDFILE_FULLPATH "$url_from_dirname") ;
    counted_images_via_yq=$(cat $MDFILE_WITH_CHOSEN_URL | sed -n '/^---/,/^---/p' | yq .recipeInstructions | sed 's/null//g'| jq '.[].recipeInstructionsList[]' | wc -l | sed 's/ //g' ) ; 
    ## Counting comparison
    echo ">> //$counted_images_via_yq//$num_files_in_this_dir" ;
    ERROR_MSG="" ;
    if [[ "$counted_images_via_yq" != "$num_files_in_this_dir" ]] ; then ERROR_MSG="FIX ERROR"; fi
    ##################### END: yq + jq block #####################    

    ## FINALLY APPENDING THIS DIRECTORY'S INDEX FILE LOCATION IN THE MAIN HTML FILE INDEX
    echo "<tr><td>$COUNT</td> <td><a target= '_blank' href='$BASE_URL/$this_dirname/$thisdir_index_htmlfile'>$this_dirname</a></td> <td>$num_files_in_this_dir (counted from mdfile=$counted_images_via_yq)</td> <td>$ERROR_MSG</td> <td><a target='_blank' href='$MGGK_URL/$this_dirname/'>MGGK-PAGE-URL</a></td> </tr>" >> $main_index_htmlfile ;
    ##
    ((COUNT++)) ;
 ##
done
##+++++++++++++++++++++++++++++++++++++++++

echo "</table>" >> $main_index_htmlfile ;
echo "$html_body_script_footer</body></html>" >> $main_index_htmlfile ;

##################################################################################
echo;
echo ">> SUMMARY: " ;
echo ">> INDEX HTML FILE SAVED AS => $main_index_htmlfile" ;
## COPY this file to Dropbox dir
cp $main_index_htmlfile $DIR_DROPBOX_SCRIPTS_OUTPUT/ ;
echo ">> INDEX HTML ALSO COPIED TO => $DIR_DROPBOX_SCRIPTS_OUTPUT" ;