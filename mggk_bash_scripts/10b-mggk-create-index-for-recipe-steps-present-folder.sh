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
main_index_htmlfile="$MAIN_DIR/index-recipe-steps-images.html" ;
## Creating some intermediate tmp files 
tmp1="$DIR_Y/_tmp10b_1.txt"
tmp2="$DIR_Y/_tmp10b_2.txt"
tmp3="$DIR_Y/_tmp10b_3.txt"
tmp4="$DIR_Y/_tmp10b_4.txt"
# Initializing these tmp files
echo "" > $tmp1 ;
echo "" > $tmp2 ;
echo "" > $tmp3 ;
echo "" > $tmp4 ;
## Create and initialize summary file
TMPFILE="$DIR_Y/mggk_summary_$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "## Summary file created: $(date) // by script => $THIS_SCRIPT_NAME" > $TMPFILE ;
## Print another line to check whether steps couting is done or not.
if [[ "$1" == "calculate_steps_count_TRUE" ]] ; then
    echo "## Recipe Steps calculated during last run = YES." >> $TMPFILE ;
else
    echo "## Recipe Steps calculated during last run = NO. Hence, empty block below." >> $TMPFILE ;
fi
##

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SETTING HTML HEADER AND FOOTER
date_var=$(date +%Y%m%d" "%H:%M:%S) ;

html_header="<html lang='en' >
<head>
    <!-- Required meta tags -->
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
	<meta http-equiv='refresh' content='60'> <!-- Refresh every 60 seconds -->
	<!-- Loading moment.js from CDN -->
	<script src='https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js'></script>
        <!-- Bootstrap CSS -->
    <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css' integrity='sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm' crossorigin='anonymous'>
    <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js'></script>

	<title>INDEX OF RECIPE STEPS IMAGES</title>
  </head>
<body><div class='container-fluid'>" ;

html_body_script_footer="<!-- BEGIN: Scripts will load below -->
<script type='text/javascript'>
    // format TODAY
    let today = moment().format('MMMM Do YYYY, h:mm:ss a') ;
    document.getElementById('currentDateDisplay').innerHTML = today;
    // formatting: list of Event dates below, relative time from today
    let time_from_now = moment(\"$date_var\", \"YYYYMMDD h:mm:dd\").fromNow() ;
    document.getElementById('printTimeFromNow').innerHTML = time_from_now ;
</script>
</div></body></html>" ;

TABLE_HEADER="<table class='table table-striped'>
    <thead>
        <tr>
            <th>File-Seq</th>
            <th>SUB-DIRECTORY (HTML INDEX FILE LINKED)</th>
            <th>IMAGES FOUND IN SUB-DIR // STEPS FOUND IN MDFILE</th>
            <th>ERROR MSG</th>
            <th>GOTO MGGK PAGE</th>
        </tr>
    </thead>
    <tbody>"

TABLE_FOOTER="</tbody></table>" ;
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
## INITIALIZING HTML OUTPUT
##################################################################################
echo "$html_header" > $main_index_htmlfile ; ## Initializing HTML output
##
echo "<h1>INDEX OF ALL HTML INDEX FILES IN DIR => recipe-steps-images</h1>" >> $main_index_htmlfile ;
echo "Page created by script: $THIS_SCRIPT_NAME" >> $main_index_htmlfile ;
echo "<br>Page Updated: <strong><span id='printTimeFromNow'></span></strong>, at $(date +%Y-%m-%d-T%H:%M:%S) // Currently it's <span id='currentDateDisplay'></span><hr>" >> $main_index_htmlfile ;

num_files=$(fd . $MAIN_DIR -t d | wc -l)
echo "<strong>Number of sub-directories found => $num_files</strong>" >> $main_index_htmlfile ;
echo "<hr>" >> $main_index_htmlfile ;

echo "$TABLE_HEADER" >> $main_index_htmlfile ;
##################################################################################

##+++++++++++++++++++++++++++++++++++++++++
COUNT=0;
COUNT_STEPSERROR=0;
COUNT_IMAGESSERROR=0;
COUNT_NOERROR=0;
## Looping through all directories present in MAIN_DIR
for x in $(fd . $MAIN_DIR -t d); do 
##
    this_dirname="$(basename $x)" ;
    thisdir_index_htmlfile="index-$this_dirname.html" ; 
    htmlfile="$x/$thisdir_index_htmlfile" ; 
    ##
    ((COUNT++)) ;   
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
            ((COUNT_STEPSERROR++)) ;
            ERROR_MSG="Steps extra" ; 
            echo "$ERROR_MSG || $PRINT_MSG" >> $TMPFILE ;
            echo "$ERROR_MSG || $PRINT_MSG" ;
            echo "<tr><td>S: $COUNT_STEPSERROR</td> <td><a target= '_blank' href='$BASE_URL/$this_dirname/$thisdir_index_htmlfile'>$this_dirname</a></td> <td> Images_found = $num_files_in_this_dir // $counted_images_via_yq = Steps_found</td> <td>$ERROR_MSG</td> <td><a target='_blank' href='$MGGK_URL/$this_dirname/'>$MGGK_URL/$this_dirname/</a></td> </tr>" >> $tmp1 ;
            ##
        elif [[ "$counted_images_via_yq" -lt "$num_files_in_this_dir" ]] ; then 
            ((COUNT_IMAGESERROR++)) ;
            ERROR_MSG="Images extra" ; 
            echo "$ERROR_MSG || $PRINT_MSG" >> $TMPFILE ;
            echo "$ERROR_MSG || $PRINT_MSG" ;
            echo "<tr><td>I: $COUNT_IMAGESERROR</td> <td><a target= '_blank' href='$BASE_URL/$this_dirname/$thisdir_index_htmlfile'>$this_dirname</a></td> <td> Images_found = $num_files_in_this_dir // $counted_images_via_yq = Steps_found</td> <td>$ERROR_MSG</td> <td><a target='_blank' href='$MGGK_URL/$this_dirname/'>$MGGK_URL/$this_dirname/</a></td> </tr>" >> $tmp2 ;
            ##
        else
            ((COUNT_NOERROR++)) ;
            ERROR_MSG="OK" ;
            echo "$ERROR_MSG || $PRINT_MSG" ;
            echo "<tr><td>C: $COUNT_NOERROR</td> <td><a target= '_blank' href='$BASE_URL/$this_dirname/$thisdir_index_htmlfile'>$this_dirname</a></td> <td> Images_found = $num_files_in_this_dir // $counted_images_via_yq = Steps_found</td> <td>$ERROR_MSG</td> <td><a target='_blank' href='$MGGK_URL/$this_dirname/'>$MGGK_URL/$this_dirname/</a></td> </tr>" >> $tmp3 ;
            ##
        fi
        ##
    fi
    ##################### END: yq + jq block ##################### 
##
done
##+++++++++++++++++++++++++++++++++++++++++

## FINAL CALCULATIONS
total_count=$(($COUNT_STEPSERROR + $COUNT_IMAGESERROR + $COUNT_NOERROR)) ;
print_msg0="## SUMMARY =>" ; 
print_msg1="## STEPS EXTRA       : $COUNT_STEPSERROR" ; 
print_msg2="## IMAGES EXTRA      : $COUNT_IMAGESERROR" ; 
print_msg3="## ALL OK            : $COUNT_NOERROR" ;
print_msg4="## TOTAL FILES COUNT : $total_count" ;       
##
echo "<p>$print_msg0
<br>$print_msg1
<br>$print_msg2
<br>$print_msg3
<br>$print_msg4
</p>" > $tmp4 ;
## FINALLY APPENDING THIS DIRECTORY'S INDEX FILE LOCATION IN THE MAIN HTML FILE INDEX
cat $tmp4 $tmp1 $tmp2 $tmp3 >> $main_index_htmlfile ;

## Finalizing html
echo "$TABLE_FOOTER" >> $main_index_htmlfile ;
echo "$html_body_script_footer" >> $main_index_htmlfile ;

##################################################################################
echo;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo ">> SUMMARY: " ;
total_count=$(($COUNT_STEPSERROR + $COUNT_IMAGESERROR + $COUNT)) ;
##
echo ">>>>
$print_msg0
$print_msg1
$print_msg2
$print_msg3
$print_msg4" >> $TMPFILE ;
##
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
## COPY files to Dropbox dir
cp $main_index_htmlfile $DIR_DROPBOX_SCRIPTS_OUTPUT/ ;
cp $TMPFILE $DIR_DROPBOX_SCRIPTS_OUTPUT/ ;
##
echo ; 
echo ">> OUTPUT FILES COPIED TO => $DIR_DROPBOX_SCRIPTS_OUTPUT" ;
echo "  main_index_htmlfile (ORIGINAL) = $main_index_htmlfile" ;
echo "  TMPFILE (ORIGINAL)             = $TMPFILE" ;
echo "  main_index_htmlfile (COPIED)   = $DIR_DROPBOX_SCRIPTS_OUTPUT/$main_index_htmlfile" ;
echo "  TMPFILE (COPIED)               = $DIR_DROPBOX_SCRIPTS_OUTPUT/$TMPFILE" ;
####
echo "Check URL here: $MAIN_INDEX_HTMLFILE_URL" ;
echo "##------------------------------------------------------------------------------"
## Output final counts
cat $TMPFILE ; 
echo "##------------------------------------------------------------------------------"
