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
    #### CLI ARGUMENTS OPTINONAL => \$1 = calculate_steps_count_TRUE
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
## Create a mdfilepaths summary file, and initialize it.
PATHS_FILE="$REPO_MGGK_SUMMARY/summary_mggk_current_mdfilepaths.txt" ;
echo "## File created on: $(date) by script: $THIS_SCRIPT_NAME" > $PATHS_FILE ;
fd --search-path="$REPO_MGGK/content/" -e md >> $PATHS_FILE ;
##
main_index_htmlfile="$REPO_MGGK/static/wp-content/recipe-steps-images/index-recipe-steps-images.html" ;
## Create and initialize summary file
TMPFILE="$DIR_Y/mggk_summary_$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "## Summary file created: $(date) // by script => $THIS_SCRIPT_NAME" > $TMPFILE ;
## Print another line to check whether steps couting is done or not.
if [[ "$1" == "calculate_steps_count_TRUE" ]] ; then
    echo "## Recipe Steps calculated during last run = YES." >> $TMPFILE ;
else
    echo "## Recipe Steps calculated during last run = NO. Hence, empty block below." >> $TMPFILE ;
fi

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
echo "Page created by script: $THIS_SCRIPT_NAME" >> $main_index_htmlfile ;
echo "<br>Page Updated: <strong><span id='printTimeFromNow'></span></strong>, at $(date +%Y-%m-%d-T%H:%M:%S) // Currently it's <span id='currentDateDisplay'></span><hr>" >> $main_index_htmlfile ;

num_files=$(fd . $MAIN_DIR -t d | wc -l)
echo "<strong>Number of sub-directories found => $num_files</strong>" >> $main_index_htmlfile ;
echo "<hr>" >> $main_index_htmlfile ;

echo "<table border='1' width='100%'>" >> $main_index_htmlfile ;
echo "<tr> <td>#</td> <td>SUB-DIRECTORY (HTML INDEX FILE LINKED)</td> <td>IMAGES FOUND IN SUB-DIR // STEPS FOUND IN MDFILE</td> <td>ERROR MSG</td> <td>GOTO MGGK PAGE</td> </tr>" >> $main_index_htmlfile ;

##+++++++++++++++++++++++++++++++++++++++++
COUNT=1;
## Looping through all directories present in MAIN_DIR
for x in $(fd . $MAIN_DIR -t d); do 
##
    this_dirname="$(basename $x)" ;
    thisdir_index_htmlfile="index-$this_dirname.html" ; 
    htmlfile="$x/$thisdir_index_htmlfile" ; 
    
    echo; echo "  >> Creating HTML index file (recipe steps images directory) = $COUNT of $num_files " ;

    ## Initializing htmlfile
    num_files_in_this_dir=$(fd . $x -e jpg | wc -l | sed 's/ //g') ;
    echo "<h1>JPG images in this sub-directory = $num_files_in_this_dir <pre>$this_dirname</pre></h1>" > $htmlfile ;
    echo "Page updated: The same time when the main index page is updated. (<a href='$MAIN_INDEX_HTMLFILE_URL'>See here</a>)<hr>" >> $htmlfile ;

    ## Making links for all jpg files in current directory
    for fname in $(fd . $x -e jpg); do 
        this_fname="$(basename $fname)" ;
        echo "<img style='border: 2px solid #000000 ;' src='$BASE_URL/$this_dirname/$this_fname' width='300px'>" >> $htmlfile ;
    done
    #####################
    ERROR_MSG="" ;
    counted_images_via_yq="not-caculated" ;

    ##################### BEGIN: yq + jq block #####################
    ## CALCULATING STEPS COUNT IF CHOSEN CLI ARGUMENT PRESENT
    if [[ "$1" == "calculate_steps_count_TRUE" ]] ; then
        ## Getting mdfile name from dirname url + counting recipe steps in it (via yq and jq)
        url_from_dirname="/$this_dirname/" ;
        MDFILE_WITH_CHOSEN_URL=$(grep "$this_dirname" $PATHS_FILE) ;
        counted_images_via_yq=$(cat $MDFILE_WITH_CHOSEN_URL | sed -n '/^---/,/^---/p' | yq .recipeInstructions | sed 's/null//g'| jq '.[].recipeInstructionsList[]' | wc -l | sed 's/ //g' ) ; 
        ######
        ## Counting comparison
        PRINT_MSG="Images_found = $num_files_in_this_dir || Steps_found = $counted_images_via_yq || $url_from_dirname" ;
        ##
        if [[ "$counted_images_via_yq" -gt "$num_files_in_this_dir" ]] ; then 
            ERROR_MSG="Steps extra" ; 
            echo "$ERROR_MSG || $PRINT_MSG" >> $TMPFILE ;
        elif [[ "$counted_images_via_yq" -lt "$num_files_in_this_dir" ]] ; then 
            ERROR_MSG="Images extra" ; 
            echo "$ERROR_MSG || $PRINT_MSG" >> $TMPFILE ;
        else
            ERROR_MSG="" ;
            echo "$ERROR_MSG || $PRINT_MSG" ;
        fi
        ##
    fi
    ##################### END: yq + jq block #####################    

    ## FINALLY APPENDING THIS DIRECTORY'S INDEX FILE LOCATION IN THE MAIN HTML FILE INDEX
    echo "<tr><td>$COUNT</td> <td><a target= '_blank' href='$BASE_URL/$this_dirname/$thisdir_index_htmlfile'>$this_dirname</a></td> <td> Images_found = $num_files_in_this_dir // $counted_images_via_yq = Steps_found</td> <td>$ERROR_MSG</td> <td><a target='_blank' href='$MGGK_URL/$this_dirname/'>MGGK-PAGE-URL</a></td> </tr>" >> $main_index_htmlfile ;
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
echo "  main_index_htmlfile = $main_index_htmlfile" ;
echo "  TMPFILE             = $TMPFILE" ;
##
cp $main_index_htmlfile $DIR_DROPBOX_SCRIPTS_OUTPUT/ ;
cp $TMPFILE $DIR_DROPBOX_SCRIPTS_OUTPUT/ ;
##
echo ">> INDEX HTML + SUMMARY FILE COPIED TO => $DIR_DROPBOX_SCRIPTS_OUTPUT" ;