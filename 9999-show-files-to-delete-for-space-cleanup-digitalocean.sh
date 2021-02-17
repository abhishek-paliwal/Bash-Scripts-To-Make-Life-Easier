#!/bin/bash
################################################################################
THIS_SCRIPT_NAME=$(basename $0) ;
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ################################################################################
  ## This is the script you need to run for housecleaning of the server.
  ################################################################################
  ## Created on: Feb 16, 2021
  ## Last updated on: Feb 17, 2021
  ## Coded by: Pali
  ###############################################################################
  # USAGE (run the following command):
  # > bash $THIS_SCRIPT_NAME
  ############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
################################################################################

################################################################################
## ASSIGNING THE MAIN PWD DEPENDING UPON WHETHER THIS PROGRAM IS RUN ON VPS SERVER
## OR ELSEWHERE LOCALLY
## GETTING THE LATEST COPY OF THIS SCRIPT FROM THE GITHUB REPO
################################################################################
if [ $USER = "ubuntu" ]; then
  MY_PWD="/home/ubuntu/scripts-made-by-pali" ;
  echo "USER = $USER // USER is ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
  ##
  echo ">> First things first .. getting the latest copy of this script (=>  $THIS_SCRIPT_NAME ) from the GitHub Repo ..." ;
  ##
  GIT_REPO_PATH="https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/" ;
  BASH_SCRIPT_FILE="$THIS_SCRIPT_NAME" ;
  ##
  ## DOWNLOADING CURRENT SCRIPT_FILE FROM GITHUB REPORT
  echo ">>>> DOWNLOADING => $GIT_REPO_PATH/$BASH_SCRIPT_FILE" ; echo;
  curl -O $GIT_REPO_PATH/$BASH_SCRIPT_FILE
  ##
  ## Moving THIS SCRIPT to our desired directory
  mv $BASH_SCRIPT_FILE $MY_PWD/ ;
else
  MY_PWD="$HOME_WINDOWS/Desktop/Y"
  echo "USER = $USER // USER is not ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
fi

cd $MY_PWD ;
################################################################################

################################################################################
## SHOWING THE NEXT STEPS FOR THE USER
################################################################################
echo "##------------------------------------------------------------------------------" ;
echo ">> Go to each of the following directories one by one by running the following cd commands, and delete unncessary files there, as you wish ..." ;
echo "##------------------------------------------------------------------------------" ;

echo; echo "cd /home/ubuntu/scripts-made-by-pali/600-mggk-ai-nlp-scripts" ;
echo; echo "cd /var/www/vps.abhishekpaliwal.com/html/scripts-html-outputs/602-mggk-plotting-outputs" ;
echo; echo "cd /home/ubuntu/scripts-made-by-pali/602-mggk-python-plotting/_TMP_FINAL_CSVs" ;
echo; echo "cd /home/ubuntu/scripts-made-by-pali/517-mggk-delete-every-2nd-csv-file" ;
echo; echo "cd /home/00-BACKUPS-BY-PALI" ;
################################################################################
