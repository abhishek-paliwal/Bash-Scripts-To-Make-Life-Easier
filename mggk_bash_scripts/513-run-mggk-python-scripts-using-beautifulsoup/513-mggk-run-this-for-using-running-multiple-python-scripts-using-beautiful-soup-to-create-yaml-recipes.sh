#!/bin/bash
###############################################################################
THIS_FILENAME="513-mggk-run-this-for-using-running-multiple-python-scripts-using-beautiful-soup-to-create-yaml-recipes.sh" ;
REQUIREMENT_FILE1="_TMP_513_STEP1_OUTPUT.CSV"
REQUIREMENT_FILE2="_TMP_513_STEP2_OUTPUT_FILE_AFTER_SUCCESS.CSV"
###############################################################################
cat<<EOF
  ###############################################################################
  ## FILENAME: $THIS_FILENAME
  ## USAGE: sh $THIS_FILENAME
  ###############################################################################
  ## REQUIREMENT FILE (Make sure that this file is present in PWD):
  #### $REQUIREMENT_FILE1
  #### $REQUIREMENT_FILE2
  ###############################################################################
  ## THIS PROGRAM RUNS TWO UNDERLYING PYTHON SCRIPTS, WHICH CREATE BULK YAML
  ## RECIPE FILES FROM GOOGLE SHEETS CSV + ONE OTHER CSV FILE
  ## SEE 513-mggk-*.py PYTHON SCRIPTS FOR MORE INFO.
  ###############################################################################
  ## CODED ON: MAY 25, 2019
  ## CODED BY: PALI
  ###############################################################################
EOF

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

BASEDIR="$HOME/Github/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/513-run-mggk-python-scripts-using-beautifulsoup" ;

## RUNNING STEP 1 PYTHON SCRIPT
python3 $BASEDIR/513-mggk-step1-read-markdown-files-yaml-frontmatter-and-create-csv.py

## RUNNING STEP 2 PYTHON SCRIPT
python3 $BASEDIR/513-mggk-step2-python-script-using-beautifulsoup-for-easyrecipe-html-variable-extraction-from-md-files.py

## RUNNING STEP 3 PYTHON SCRIPT
python3 $BASEDIR/513-mggk-step3-read-and-merge-two-csv-files-to-create-recipe-yaml-files.py
################################################################################

## OPENING PWD
echo; echo "=====> Opening PWD = $PWD " ;
open $PWD

################################################################################
