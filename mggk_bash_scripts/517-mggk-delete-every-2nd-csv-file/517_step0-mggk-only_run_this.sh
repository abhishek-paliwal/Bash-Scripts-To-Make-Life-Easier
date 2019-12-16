#!/bin/bash
##########################################################################################
## Only run this script and it will take care of everything in sequence.
## Created on: Monday December 16, 2019
## Coded by: Pali
#########################################################################################

################################################################################
## ASSIGNING THE MAIN PWD DEPENDING UPON WHETHER THIS PROGRAM IS RUN ON VPS SERVER
## OR ELSEWHERE LOCALLY
################################################################################
if [ $USER = "ubuntu" ]; then
  MY_PWD="$HOME/scripts-made-by-pali/600-mggk-ai-nlp-scripts"
  echo "USER = $USER // USER is ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
else
  MY_PWD="$HOME/Desktop/Y"
  echo "USER = $USER // USER is not ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
fi

cd $MY_PWD ;
################################################################################

BASH_SCRIPT_TO_DOWNLOAD="517-mggk-delete-every-2nd-csv-file-and-keep-max-15-csv-files-in-subdirs.sh"

echo ">>>> DOWNLOADING => $BASH_SCRIPT_TO_DOWNLOAD" ; echo;
curl -O https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/mggk_bash_scripts/600-mggk-artificial-intelligence-nlp-programs/601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls/$BASH_SCRIPT_TO_DOWNLOAD

## Moving to correct directory
mv $BASH_SCRIPT_TO_DOWNLOAD $MY_PWD/$BASH_SCRIPT_TO_DOWNLOAD

echo ">>>> RUNNING => $BASH_SCRIPT_TO_DOWNLOAD" ; echo;
bash $MY_PWD/$BASH_SCRIPT_TO_DOWNLOAD
