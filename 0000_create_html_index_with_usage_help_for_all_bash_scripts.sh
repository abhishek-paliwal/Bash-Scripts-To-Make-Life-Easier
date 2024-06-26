#!/bin/bash
################################################################################
## SOURCE OTHER SCRIPTS FIRST, SO THAT IT DOES NOT OVERWRITE THE VARIABLES
################################################################################
FUNC_SOURCE_SCRIPTS () {
    ####
    source "$REPO_SCRIPTS_MINI/00200a_source_script_to_print_fancy_divider.sh" ;
    echo ">> This enables => 'palidivider' command, which prints a fancy divider on cli." ; 
    ####
    source "$REPO_SCRIPTS_MINI/00200b_source_script_to_delete_chosen_files_and_dirs.sh" ; 
    echo ">> This enables => 'palidelete' command, which moves files into a _trashed_directory instead of deleting completely." ; 
    ####
    ####################### ADDING COLOR TO OUTPUT ON CLI ##########################
    echo "Currently sourcing the bash color script, which outputs chosen texts in various colors ..." ;
    source $REPO_SCRIPTS/2000_vendor_programs/color-logger.sh
    info "This enables use of keywords for coloring, such as: debug, info, error, success, warn, highlight." ;
    debug "Read it's help by running: >> bash $DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/color-logger.sh -h"
    ##############################################################################
}
FUNC_SOURCE_SCRIPTS ; 
palidivider "BEGIN: $(basename $0)" ; 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## VARIABLES SETTING 
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="${THIS_SCRIPT_NAME%.*}" ;
THIS_SCRIPT_NAME_EXTENSION="${THIS_SCRIPT_NAME##*.}" ;
##################################################################################
WORKDIR="$DIR_Y/$THIS_SCRIPT_NAME_SANS_EXTENSION" ; 
mkdir -p $WORKDIR ;
##
OUTPUT_DIR="$DIR_DROPBOX_SCRIPTS_OUTPUT" ; 
echo ">> Currently running => $THIS_SCRIPT_NAME" ; 
echo ">> OUTPUT_DIR = $OUTPUT_DIR" ;
##################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCTION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ## THIS SCRIPT CREATES AN HTML OUTPUT FILE in THIS OUTPUT DIR ==>
    ## $OUTPUT_DIR 
    ## LISTING ALL THE BASH_SCRIPT NAMES IN $DIR_GITHUB
    ## AND ALSO WHETHER THEY HAVE THE USAGE HELP FUNCTION BLOCK IN THEM OR NOT.
    ##################################################################################
    ## USAGE_HOWTO ON CLI > bash $(basename $0)
    ##################################################################################
    ## If that usage function is not found, then you will have to manually create it.
    ## >> The idea here is that all bash scripts ending in *.sh extension should have 
    ## >> the usage help function in them, so that if that script is called as 
    ## >> bash SCRIPT_NAME --help , it should return the usage help.
    ##################################################################################
    ## CREATED ON: 2020-03-21 22:08
    ## CREATED BY: PALI
    ##################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
cd $OUTPUT_DIR ; 
echo ">> PWD = $(pwd)" 
echo ">>>> Calculating the usage functions for all scripts (might take a while) ..." ; 
##
outfile="$OUTPUT_DIR/OUTPUT_0000_create_html_index_with_usage_help.html" ;
log_outfile="$WORKDIR/OUTPUT_LOG_0000_create_html_index_with_usage_help.txt" ;
DATE_NOW=$(date +"%Y-%m-%d-%H-%M-%S") ;
echo ">> ## Created on = $DATE_NOW" > "$log_outfile" ; ## initializing the log file
####
####

HTML_BOOTSTRAP_HEADER="<!doctype html>
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

    <title>0000 HELP-USAGE SCRIPT OUTPUT // Help Usage Bash and Python Scripts</title>
  </head>
  <body>
  <div class='jumbotron jumbotron-fluid'>
  <div class='container-fluid'>
    <h1>List of my Bash and Python Scripts with help usage function defined</h1>
    <p>Autocreated on: $(date)<br>This html file is autogenerated by this script: $THIS_SCRIPT_NAME</p>
    <h5 style='color:blue;'>Blue (bash script) OR Green (python script) color = Usage function found. // Red color = Usage function not found.</h5>
    <h5 style='color:red;'>IMPORTANT NOTE: Fix those files which don't have the usage function in them.</h5>
  </div>
</div>
  <div class='container-fluid'><!-- BEGIN: main containter div -->" ;

HTML_BOOTSTRAP_FOOTER="</div> <!-- END: main containter div --> </body></html>" ;

DATATABLE_HEADER_SUCCESS="<table class='table' id='mytable' class='display' style='width:100%'>
  <thead>
    <tr>
      <th scope='col'>COUNT</th>
      <th scope='col'>SCRIPT_NAME (VALID)</th>
      <th scope='col'>USAGE_FUNCTION FOUND OR NOT</th>
      <th scope='col'>USAGE_BLOCK_OUTPUT</th>
    </tr>
  </thead>
  <tbody>" ;

DATATABLE_HEADER_FAILURE="<table class='table' class='display' style='width:100%'>
  <thead>
    <tr>
      <th scope='col'>COUNT</th>
      <th scope='col'>SCRIPT_NAME (INVALID)</th>
      <th scope='col'>USAGE_FUNCTION FOUND OR NOT</th>
      <th scope='col'>USAGE_BLOCK_OUTPUT</th>
    </tr>
  </thead>
  <tbody>" ;

DATATABLE_FOOTER="</tbody></table>" ;

echo "$HTML_BOOTSTRAP_HEADER" > $outfile

##------------------------------------------------------------------------------
################# BEGIN: PRINTING FOR SCRIPTS #########################
echo "$DATATABLE_HEADER_FAILURE" >> $outfile ;
##
PATHDIR="$DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier"
count=0;
## Print the bash script where usage function is not found.
echo "<tr class='table-dark'> <th scope='row'>COUNT</th> <td>SCRIPTS WHERE USAGE FUNCTION IS NOT FOUND (red rows)</td> <td>They need fixing. Please put a valid usage function.</td> <td>Usage_Function_Output</td> </tr>" >> $outfile ;
echo "<tr> <th scope='row'>#</th> <td>Row left blank intentionally.</td> <td></td> </tr>" >> $outfile ;
for x in $(grep -irL --include \*.sh --include \*.py 'usage()' $PATHDIR/ | grep -iv '/venv/') ; do
    ((count++))
    replaceThis1="/home/ubuntu/GitHub/Bash-Scripts-To-Make-Life-Easier/" ;
    replaceThis2="/Users/abhishek/GitHub/Bash-Scripts-To-Make-Life-Easier/"
    #script_name=$(echo $x | sed -e "s|$replaceThis1||g" -e "s|$replaceThis2||g") ;  
    script_name=$(basename $x) ;
    echo "-- $count // USAGE FUNCTION NOT FOUND IN ==> $script_name" >> "$log_outfile" ; 
    echo "<tr class='table-danger'> <th scope='row'>$count</th> <td>$script_name</td> <td>Usage function not found. Fix it.</td> <td>usage_output not found.</td> </tr>" >> $outfile ;
done
##
echo "$DATATABLE_FOOTER" >> $outfile ;

#echo; echo;
echo "<hr>" >> $outfile ;
echo "$DATATABLE_HEADER_SUCCESS" >> $outfile ;
##
## Print the bash script where usage function is found.
echo "<tr class='table-dark'> <th scope='row'>COUNT</th> <td>SCRIPTS WHERE USAGE FUNCTION IS FOUND (blue/green rows)</td> <td>They do not need fixing.</td> <td>Usage_Function_Output</td> </tr>" >> $outfile ;
for x in $(grep -irl --include \*.sh --include \*.py 'usage()' $PATHDIR/ | grep -iv '/venv/') ; do
    ((count++))
    ## Get file extension (sh OR py)
    file_extension="${x##*.}";
    replaceThis1="/home/ubuntu/GitHub/Bash-Scripts-To-Make-Life-Easier/" ;
    replaceThis2="/Users/abhishek/GitHub/Bash-Scripts-To-Make-Life-Easier/"
    #script_name=$(echo $x | sed -e "s|$replaceThis1||g" -e "s|$replaceThis2||g") ;  
    script_name=$(basename $x) ;
    #echo; 
    echo "++ $count // USAGE FUNCTION FOUND IN ==> $script_name // EXTENSION = $file_extension" >> "$log_outfile" ; 
    
    ## Check the file extension and run corresponding help command 
    if [ "$file_extension" == "sh" ] ; then 
      usage_output=$(bash $x --help | sed 's/</\&lt;/g' | sed 's/>/\&gt;/g') ;
      echo "<tr class='table-primary'> <th scope='row'>$count</th> <td>$script_name</td> <td>Usage function found</td> <td> <pre><code>$usage_output</code></pre> </td> </tr>" >> $outfile ;
    elif [ "$file_extension" == "py" ] ; then
      usage_output=$(python3 $x --help | sed 's/</&lt;/g' | sed 's/>/&gt;/g' | sed 's|/home/ubuntu/GitHub/Bash-Scripts-To-Make-Life-Easier/||g' ) ;
      echo "<tr class='table-success'> <th scope='row'>$count</th> <td>$script_name</td> <td>Usage function found</td> <td> <pre><code>$usage_output</code></pre> </td> </tr>" >> $outfile ;
    else
     usage_output="NOT A VALID *.sh OR *.py file." ;
     echo "<tr class='table-warning'> <th scope='row'>$count</th> <td>$script_name</td> <td>Usage function found</td> <td> <pre><code>$usage_output</code></pre> </td> </tr>" >> $outfile ;
    fi    
  
done
##------------------------------------------------------------------------------
################# END: PRINTING FOR SCRIPTS #########################
echo "$DATATABLE_FOOTER" >> $outfile ;
##
echo "$HTML_BOOTSTRAP_FOOTER" >> $outfile

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## PRINTING SUMMARY
echo "#---------------------------------------------------------------" ;
echo "SUMMARY:" ; 
echo "#---------------------------------------------------------------" ;
echo "TOTAL NUMBER OF SCRIPTS FOUND = $count" ; echo ;
echo "LOG FILE = $log_outfile" ; echo ;
echo "OUTPUT FILE = $outfile" ; echo ;
echo "OUTPUT_DIRECTORY = $OUTPUT_DIR" ; echo ;
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

palidivider "END: $(basename $0)" ;
