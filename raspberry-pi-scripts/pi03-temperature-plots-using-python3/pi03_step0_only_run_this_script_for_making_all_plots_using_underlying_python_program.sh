#!/bin/bash
THIS_SCRIPT_NAME="pi03_step0_only_run_this_script_for_making_all_plots_using_underlying_python_program.sh" ;
################################################################################
cat << EOF
  ################################################################################
  ## RUN THIS SCRIPT FOR MAKING PLOTS USING THE UNDERLYING pi03... PYTHON FILE.
  ## IT WILL USE ALL THE CSV FILES FOR THE DATA, AND MAKE ONE PLOT FOR EACH CSV FILE.
  ################################################################################
  ## USAGE: bash $THIS_SCRIPT_NAME
  ################################################################################
  ## CREATED ON: January 16, 2020
  ## CREATED BY: Pali
  ################################################################################
EOF
################################################################################

GIT_REPO_PATH="https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/raspberry-pi-scripts/pi03-temperature-plots-using-python3/"
PYTHON_SCRIPT_FILE="pi03_step1_temperature_plots_using_python.py"

## DOWNLOADING CURRENT PYTHON_SCRIPT_FILE FROM GITHUB REPO
echo ">>>> DOWNLOADING => $GIT_REPO_PATH/$PYTHON_SCRIPT_FILE" ; echo;
curl -O $GIT_REPO_PATH/$PYTHON_SCRIPT_FILE

################################################################################
## GET THE CSV FILES FOR PLOTTING FROM ANOTHER FOLDER ON VPS (ONLY IF THE USER IS ubuntu)
if [ $USER = "pi" ]; then
  BASEDIR="$HOME/pali_personal/my-pi-scripts/pi03-temperature-plots-using-python3"
  CSVDIR="$HOME/pali_personal/my-pi-scripts/_output_data_from_scripts"
  echo "USER = $USER // USER is pi. Hence, CSVDIR will be: $CSVDIR " ;
  ## Removing all existing CSVs + PNGs
  rm $BASEDIR/*.png
  rm $BASEDIR/*.csv
  ## Finding today's created CSV files in the CSVDIR and copying them to BASEDIR
  find $CSVDIR/ -name *pi01-data_temperature_output.csv -exec cp "{}" $BASEDIR/  \;
else
  MY_PWD="$(pwd)"
  echo "USER = $USER // USER is not pi. Hence, MY_PWD will be: $MY_PWD " ;
fi

##------------------------------------------------------------------------------
## PLOT PNG CREATION BEGINS
for csvfile in *.csv ; do
  python3 $PYTHON_SCRIPT_FILE $csvfile
done
##------------------------------------------------------------------------------

echo ">>>> WRITING TO HTML FILE OUTPUT ... " ;
HTML_OUTPUT_FILE="_TMP_PI03_PYTHON_TEMPERATURE_PLOTS_PROGRAM_OUTPUT.html"
##
echo "<!doctype html>
<html lang='en'>
  <head>
    <!-- Required meta tags -->
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>

    <!-- Bootstrap CSS -->
    <link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css'>

    <title>PI03 Plotting - Program output</title>
  </head>
  <body>
  <div class='container'><!-- BEGIN: main containter div -->" > $HTML_OUTPUT_FILE
##------------------------------------------------------------------------------
echo "<div class='row' style='color: grey;'> Webpage created: $(date) </div>" >> $HTML_OUTPUT_FILE
echo "<hr style='background-color: grey; height: 3px;' >" >> $HTML_OUTPUT_FILE
echo "<div class='row'> <h1>List of CSV Files Used For Plotting:</h1> </div>" >> $HTML_OUTPUT_FILE
for csvfile in *.csv ; do
  csvfile_data=$(cat $csvfile | wc -l)
  echo "<div class='row'>$csvfile_data = Number of Temperature data-points // CSV-FILE = $csvfile</div>" >> $HTML_OUTPUT_FILE
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
## COPY THE OUTPUT PNG + HTML FILES TO WWWDIR_PI03 ON SERVER (MEANING, IF THE USER IS pi)
if [ $USER = "pi" ]; then
  WWWDIR_PI03="/var/www/html/pi03-plotting-outputs"
  #cp $BASEDIR/*.csv $WWWDIR_PI03/
  cp $BASEDIR/*.png $WWWDIR_PI03/
  cp $BASEDIR/*.html $WWWDIR_PI03/
else
  echo "USER = $USER // USER is not pi. Hence, no further processing is required." ;
fi
