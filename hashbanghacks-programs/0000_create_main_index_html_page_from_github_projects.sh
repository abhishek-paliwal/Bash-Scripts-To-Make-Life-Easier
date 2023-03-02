#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
##################################################################################
OUTPUT_DIR="$DIR_GITHUB/HASHBANGHACKS-WEBAPP" ;
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
    ## CREATED ON: 2022-09-19
    ## CREATED BY: PALI
    ##################################################################################
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

##################################################################################
cd $OUTPUT_DIR
echo ">> PWD = $(pwd)" 
##################################################################################

##################################################################################
##################################################################################
outfile="$OUTPUT_DIR/index.html" ;


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

    <title>Current status of GitHub Projects</title>
  </head>" ;

HTML_LOGO_HEADER="<body>
  <div class='container-fluid'><!-- BEGIN: main containter div -->
  <nav class='navbar navbar-expand-lg navbar-light bg-light'>
    <div class='container-fluid'>
    <a class='navbar-brand' href='https://www.abhishekpaliwal.fi'>
      <img src='https://www.abhishekpaliwal.fi/favicons/apple-touch-icon.png' alt='logo-website' width='30' height='30' class='d-inline-block align-text-top'>
    </a>
    <button class='navbar-toggler' type='button' data-bs-toggle='collapse' data-bs-target='#navbarSupportedContent' aria-controls='navbarSupportedContent' aria-expanded='false' aria-label='Toggle navigation'>
      <span class='navbar-toggler-icon'></span>
    </button>
    <div class='collapse navbar-collapse' id='navbarSupportedContent'>
      <ul class='navbar-nav me-auto mb-2 mb-lg-0'>
        <li class='nav-item'>
          <a class='nav-link' href='https://www.abhishekpaliwal.fi'>Codebase created and maintained by Abhishek Paliwal</a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<div class='m-3 text-center'>
<img class='logo' src='https://www.hashbanghacks.tech/images/logo-hashbanghacks.png' alt='logo-website' width='250' height='75'>
</div>
<hr>

<div class='jumbotron jumbotron-fluid'>
  <div class='container-fluid'>
    <h1>Current status of all my Open-Source GitHub Projects</h1>
    <p>Updated on: $(date)</p>
    <h5 style='color:blue;'>Color coding info: Blue (bash/CLI/Linux programs) or green (python/CLI programs) color = Status (OK) // Red color = Status (Under Maintenance)</h5>
    <h5 style='color:red;'>IMPORTANT NOTE: Tests are performed periodically for desired outcomes for all the listed programs.</h5>
  </div>
</div>" ;   

HTML_BOOTSTRAP_FOOTER="</div> <!-- END: main containter div --> </body></html>" ;

DATATABLE_HEADER_SUCCESS="<table class='table' id='mytable' class='display' style='width:100%'>
  <thead>
    <tr>
      <th scope='col'>COUNT</th>
      <th scope='col'>PROGRAM_NAME (VALID)</th>
      <th scope='col'>PROGRAM_STATUS</th>
      <th scope='col'>USAGE_BLOCK_OUTPUT</th>
    </tr>
  </thead>
  <tbody>" ;

DATATABLE_HEADER_FAILURE="<table class='table' class='display' style='width:100%'>
  <thead>
    <tr>
      <th scope='col'>COUNT</th>
      <th scope='col'>PROGRAM_NAME (TO BE DEBUGGED)</th>
      <th scope='col'>PROGRAM_STATUS</th>
      <th scope='col'>USAGE_BLOCK_OUTPUT</th>
    </tr>
  </thead>
  <tbody>" ;

DATATABLE_FOOTER="</tbody></table>" ;

echo "$HTML_BOOTSTRAP_HEADER" > $outfile
echo "$HTML_LOGO_HEADER" >> $outfile

##------------------------------------------------------------------------------
################# BEGIN: PRINTING FOR SCRIPTS #########################
echo "$DATATABLE_HEADER_FAILURE" >> $outfile ;
##
PATHDIR="$DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier"
count=0;
## Print the bash script where usage function is not found.
echo "<tr class='table-dark'> <th scope='row'>COUNT</th> <td>SCRIPTS WHERE USAGE FUNCTION IS NOT FOUND (red rows)</td> <td>Needs debugging.</td> <td>Usage_Function_Output</td> </tr>" >> $outfile ;
echo "<tr> <th scope='row'>#</th> <td>Row left blank intentionally.</td> <td></td> </tr>" >> $outfile ;
for x in $(grep -irL --include \*.sh --include \*.py 'usage()' $PATHDIR/ | grep -iv '/venv/') ; do
    ((count++))
    replaceThis1="/home/ubuntu/GitHub/Bash-Scripts-To-Make-Life-Easier/" ;
    replaceThis2="/Users/abhishek/GitHub/Bash-Scripts-To-Make-Life-Easier/"
    #script_name=$(echo $x | sed -e "s|$replaceThis1||g" -e "s|$replaceThis2||g") ;  
    script_name=$(basename $x) ;
    warn "-- USAGE FUNCTION NOT FOUND IN ==> $script_name" ; 
    echo "<tr class='table-danger'> <th scope='row'>$count</th> <td>$script_name</td> <td>Under Maintenance.</td> <td>usage_output not found.</td> </tr>" >> $outfile ;
done
##
echo "$DATATABLE_FOOTER" >> $outfile ;

echo; echo;
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
    echo; success "++ USAGE FUNCTION FOUND IN ==> $script_name // EXTENSION = $file_extension" ; 
    
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

## PRINTING OUTPUT DIRECTORY FULL PATH
echo; echo "OUTPUT_DIRECTORY => $OUTPUT_DIR" ; echo ;   