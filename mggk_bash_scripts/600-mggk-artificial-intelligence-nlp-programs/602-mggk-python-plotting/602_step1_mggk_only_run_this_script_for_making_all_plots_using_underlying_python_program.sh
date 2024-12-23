#!/bin/bash
THIS_SCRIPT_NAME="602_step1_mggk_only_run_this_script_for_making_all_plots_using_underlying_python_program.sh" ;
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ################################################################################
  ## RUN THIS SCRIPT FOR MAKING PLOTS USING THE UNDERLYING 602... PYTHON FILE.
  ## IT WILL USE ALL THE CSV FILES FOR THE DATA, AND MAKE ONE PLOT FOR EACH CSV FILE.
  ################################################################################
  ## USAGE: bash $THIS_SCRIPT_NAME
  ################################################################################
  ## CREATED ON: Friday November 22, 2019
  ## CREATED BY: Pali
  ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################
#PYTHON_SCRIPT_FILE="$HOME/Github/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/600-mggk-artificial-intelligence-nlp-programs/602-mggk-python-plotting/602-mggk-plotting-601-outputs-csv-data-using-matplotlib-pandas-in-python.py"

GIT_REPO_PATH="https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/mggk_bash_scripts/600-mggk-artificial-intelligence-nlp-programs/602-mggk-python-plotting"
PYTHON_SCRIPT_FILE="602-mggk-plotting-601-outputs-csv-data-using-matplotlib-pandas-in-python.py"

## DOWNLOADING CURRENT PYTHON_SCRIPT_FILE FROM GITHUB REPORT
echo ">>>> DOWNLOADING => $GIT_REPO_PATH/$PYTHON_SCRIPT_FILE" ; echo;
curl -O $GIT_REPO_PATH/$PYTHON_SCRIPT_FILE

################################################################################
## GET THE CSV FILES FOR PLOTTING FROM ANOTHER FOLDER ON VPS (ONLY IF THE USER IS ubuntu)
if [ $USER = "ubuntu" ]; then
  BASEDIR="$HOME/scripts-made-by-pali/602-mggk-python-plotting"
  CSVDIR="$HOME/scripts-made-by-pali/600-mggk-ai-nlp-scripts"
  echo "USER = $USER // USER is ubuntu. Hence, CSVDIR will be: $CSVDIR " ;
  ## Removing all existing CSVs + PNGs
  rm $BASEDIR/*.png
  rm $BASEDIR/*.CSV 
  ## Finding today's created CSV files in the CSVDIR and copying them to BASEDIR
  find $CSVDIR/ -name $(date +%Y%m%d)*CSV -exec cp "{}" $BASEDIR/  \;
  ######
  ## Finding the latest produced CSV file in the CSVDIR and copying them to BASEDIR
  echo ">> Finding the latest produced CSV files ..." ; 
  TMPFILE0="$DIR_Y/_tmp_602_csv_files.txt" ; 
  echo "##List_of_CSVs" > $TMPFILE0 ;
  for x in $(fd -td --search-path="$CSVDIR") ; do 
    fd -e csv --search-path="$x" 'FUTURE_ANALYSES.CSV' | sort -rn | head -1 >> $TMPFILE0 ; 
  done ; 
  echo ">> LISTING THE CSV FILES TO COPY ..." ; 
  cat $TMPFILE0 ;
  ## Read the tmp file and copy each line as a CSV file into $BASEDIR
  for y in $(cat $TMPFILE0 | grep -i 'csv') ; do cp "$y" $BASEDIR/ ; done
  ######
else
  MY_PWD="$(pwd)"
  echo "USER = $USER // USER is not ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
fi

##------------------------------------------------------------------------------
## PLOT PNG CREATION BEGINS
for csvfile in *.CSV ; do
  python3 $PYTHON_SCRIPT_FILE $csvfile
done
## MOVING ALL TMP CSV FILES THUS GENERATED TO A DIFFERENT FOLDER
## SO THAT THEY ARE NOT USED IN MAKING ANY PLOTS. THEY ARE JUST FOR REFERENCE.
TMP_CSVDIR=_TMP_FINAL_CSVs
mkdir $BASEDIR/$TMP_CSVDIR
mv _TMP_FINAL*.CSV $BASEDIR/$TMP_CSVDIR
##------------------------------------------------------------------------------

echo ">>>> WRITING TO HTML FILE OUTPUT ... " ;
HTML_OUTPUT_FILE="_TMP_602_PYTHON_PLOTS_PROGRAM_OUTPUT.html"
##
echo "<!doctype html>
<html lang='en'>
  <head>
    <!-- Required meta tags -->
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>

    <!-- Bootstrap CSS -->
    <link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css'>

    <title>PROJ602 Data Analysis/Plotting Output</title>
  </head>
  <body>
  <div class='container'><!-- BEGIN: main containter div -->" > $HTML_OUTPUT_FILE
##------------------------------------------------------------------------------
echo "<div class='row' style='color: grey;'> Webpage created: $(date) </div>" >> $HTML_OUTPUT_FILE
echo "<hr style='background-color: grey; height: 3px;' >" >> $HTML_OUTPUT_FILE
echo "<div class='row'> <h1>[Concepro Client- 2022] MGGK - Competitor Analysis</h1> </div>" >> $HTML_OUTPUT_FILE
echo "<div class='row'> <h2>List of DATA Files Used For Data Analysis and Reporting:</h2> </div>" >> $HTML_OUTPUT_FILE
#for csvfile in $(date +%Y%m%d)*.CSV ; do
for csvfile in *.CSV ; do
  csvfile_data=$(cat $csvfile | grep 'http' | wc -l)
  echo "<div class='row'>$csvfile_data = Number of URLs // CSV-FILE = $csvfile</div>" >> $HTML_OUTPUT_FILE
done
echo "<hr style='background-color: grey; height: 3px;' >" >> $HTML_OUTPUT_FILE
##
echo "<div class='row'> <h2>LIST OF PLOTS:</h2> </div>" >> $HTML_OUTPUT_FILE
for plotfile in *.png ; do
  echo "<div class='row'> <strong>CURRENT IMAGE = $plotfile</strong> </div>" >> $HTML_OUTPUT_FILE
  echo "<div class='row'> <img src='$plotfile' width='100%'></img> </div>" >> $HTML_OUTPUT_FILE
  echo "<hr style='background-color: grey; height: 3px;' >" >> $HTML_OUTPUT_FILE
done
##------------------------------------------------------------------------------
echo "   </div> <!-- END: main containter div -->
    <!-- Optional Bootstrap JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src='https://code.jquery.com/jquery-3.3.1.slim.min.js'></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js'></script>
    <script src='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js'></script>
  </body>
</html>" >> $HTML_OUTPUT_FILE

################################################################################
## COPY THE OUTPUT PNG + HTML FILES TO WWWDIR_602 ON VPS (MEANING, IF THE USER IS ubuntu)
if [ $USER = "ubuntu" ]; then
  WWWDIR_602="/var/www/vps.abhishekpaliwal.com/html/scripts-html-outputs/602-mggk-plotting-outputs"
  #cp $BASEDIR/*.CSV $WWWDIR_602/
  cp $BASEDIR/*.png $WWWDIR_602/
  cp $BASEDIR/*.html $WWWDIR_602/
else
  echo "USER = $USER // USER is not ubuntu. Hence, no further processing is required." ;
fi
