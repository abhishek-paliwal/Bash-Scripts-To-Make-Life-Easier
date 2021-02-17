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
  ## THIS SCRIPT DOWNLOADS THE LATEST VERSIONS OF SCRIPTS FROM GITHUB REPOS.
  ## Add more functions as needed.
  ################################################################################
  ## Created on: Feb 17, 2021
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
function FUNCTION_DOWNLOAD_LATEST_SCRIPT_1 () {
  DIR_TO_MOVE="/home/ubuntu/scripts-made-by-pali" ;
  GIT_REPO_PATH="https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/9999-digitalocean-scripts" ;
  BASH_SCRIPT_FILE="9999-show-files-to-delete-for-space-cleanup-digitalocean.sh" ;
  ## Deleting existing version of this script
  rm $DIR_TO_MOVE/$BASH_SCRIPT_FILE ;
  ## Downloading ...
  wget $GIT_REPO_PATH/$BASH_SCRIPT_FILE ;
  ## Moving THIS SCRIPT to our desired directory
  mv $BASH_SCRIPT_FILE $DIR_TO_MOVE/$BASH_SCRIPT_FILE ;
}
## RUN THE FUNCTION
FUNCTION_DOWNLOAD_LATEST_SCRIPT_1
################################################################################

