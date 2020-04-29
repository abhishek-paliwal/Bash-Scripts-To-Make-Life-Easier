#!/bin/bash
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ##----------------------------------------------------------------------------
  ## IMPORTANT NOTE: ONLY RUN THIS SCRIPT IN THIS DIRECTORY TO CREATE ALL PYTHON PLOTS
  ## USING ALL THE CSV FILES IN THIS DIRECTORY.
  ## CREATED ON: Monday November 25, 2019
  ## CREATED BY: PALI
  ##----------------------------------------------------------------------------
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################
## ASSIGNING THE MAIN PWD DEPENDING UPON WHETHER THIS PROGRAM IS RUN ON VPS SERVER
## OR ELSEWHERE LOCALLY
################################################################################
if [ $USER = "ubuntu" ]; then
  MY_PWD="$HOME/scripts-made-by-pali/602-mggk-python-plotting"
  echo "USER = $USER // USER is ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
else
  MY_PWD="$HOME/Desktop/X"
  echo "USER = $USER // USER is not ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
fi

cd $MY_PWD ;

################################################################################
GIT_REPO_PATH="https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/mggk_bash_scripts/600-mggk-artificial-intelligence-nlp-programs/602-mggk-python-plotting"
BASH_SCRIPT_FILE="602_step1_mggk_only_run_this_script_for_making_all_plots_using_underlying_python_program.sh"
##
## DOWNLOADING CURRENT BASH_SCRIPT_FILE FROM GITHUB REPORT
echo ">>>> DOWNLOADING => $GIT_REPO_PATH/$BASH_SCRIPT_FILE" ; echo;
curl -O $GIT_REPO_PATH/$BASH_SCRIPT_FILE
################################################################################

## RUN THE DOWNLOADED SCRIPT
bash $MY_PWD/$BASH_SCRIPT_FILE
