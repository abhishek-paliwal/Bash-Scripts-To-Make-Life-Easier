#!/bin/bash
###############################################################################
THIS_FILENAME="506A-mggk-run-this-for-running-two-python-scripts-to-create-yaml-recipes.sh" ;
REQUIREMENT_FILE="_STEP2-INPUT-MGGK-GOOGLE-SHEETS-CSV.CSV"
###############################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ###############################################################################
  ## FILENAME: $THIS_FILENAME
  ## USAGE: sh $THIS_FILENAME
  ###############################################################################
  ## REQUIREMENT FILE (Make sure that this file is present in PWD):
  #### $REQUIREMENT_FILE
  ###############################################################################
  ## THIS PROGRAM RUNS TWO UNDERLYING PYTHON SCRIPTS, WHICH CREATE BULK YAML
  ## RECIPE FILES FROM GOOGLE SHEETS CSV + ONE OTHER CSV FILE
  ## SEE 506A*.py PYTHON SCRIPTS FOR MORE INFO.
  ###############################################################################
  ## CODED ON: MAY 10, 2019
  ## CODED BY: PALI
  ###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

###############################################################################

## SOME VARIABLES
MY_OUTPUT_DIR="$HOME/Desktop/Y/" ;
cd $MY_OUTPUT_DIR ;
##
PWD=$(pwd) ;
echo;
echo "Current working directory = $PWD" ;
echo;

## USER CONFIRMATION
read -p ">>>> If this working directory is OK, please press ENTER key to continue ..." ;
echo;

###############################################################################
## MULTIPLE PYTHON SCRIPTS WILL RUN BELOW

BASEDIR="$HOME/Github/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/506A-mggk-run-multiple-python-scripts" ;

## RUNNING STEP 1 PYTHON SCRIPT
python3 $BASEDIR/506A-step1-read-markdown-files-yaml-frontmatter-and-create-csv.py

## RUNNING STEP 2 PYTHON SCRIPT
python3 $BASEDIR/506A-step2-read-google-sheets-csv-and-merge-two-csv-files-to-create-recipe-yaml-files.py
################################################################################

## OPENING PWD
echo; echo "=====> Opening PWD = $PWD " ;
open $PWD
