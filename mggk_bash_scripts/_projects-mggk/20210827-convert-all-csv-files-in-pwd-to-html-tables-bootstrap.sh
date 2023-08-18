#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

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
    ## THIS PROGRAM CONVERTS CSV TO HTML TABLE FORMAT. 
    ## This program reads all the csv files in working directory and creates
    ## corresponding html table outputs as bootstrap tables.
    #########################################
    ## INFO: MAKE SURE TO HAVE THE FIRST ROW IN CSV FILES TO BE COLUMN HEADERS. 
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-08-27
    ################################################################################
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


##############################################################################
bootstrap_header="<!doctype html>
<html lang='en'>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We' crossorigin='anonymous'>
    <title>CSV to HTML Table</title>
  </head>
  <body><div class='container-fluid'>
    <h1>CSV to HTML Table</h1>" ;

bootstrap_footer="</div>
</body>
</html>" ;

##################################################################################

## Getting the first csv file found in current working directory
function func_convert_csv_to_html_table () {
    ##
    inFileCSV="$1" ;
    csvDelimiter="$2" ; 
    outFileHTML="$WORKDIR/$(basename $inFileCSV).html" ;
    ##
    echo ">> CURRENT CSV FILE         => $inFileCSV" ;
    echo ">> CURRENT HTML OUTPUT FILE => $outFileHTML" ;
    ##
    echo "$bootstrap_header" > $outFileHTML ;
    echo "<h2>CSV FILE = $(basename $inFileCSV)</h2>" >> $outFileHTML ;

    echo "<table class='table table-striped table-hover'>" >> $outFileHTML ;
    while read INPUT ; do
        echo "<tr><td>${INPUT//$csvDelimiter/</td><td>}</td></tr>" >> $outFileHTML ;
    done < $inFileCSV ;
    echo "</table>" >> $outFileHTML ;
    echo "$bootstrap_footer" >> $outFileHTML ;
}
##################################################################################

csvDir="$(pwd)" ;

echo ">> ENTER THE CSV DELIMITER TO USE: " ; 
read csvDelimiter;

## Calling function for every csv file found
for csvFile in $(fd --search-path="$csvDir" -e csv -e CSV) ; do
    func_convert_csv_to_html_table "$csvFile" "$csvDelimiter"
done

## final message
echo "################################################################################"
echo ">> NOTE: All html outputs have been saved in this dir => $WORKDIR" ;
echo "################################################################################"
echo; echo ">> TREE LIST FOR => $WORKDIR" ;
tree $WORKDIR ; 
