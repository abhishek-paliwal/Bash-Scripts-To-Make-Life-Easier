#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ##########################################################################################
    ## Only run this script and it will take care of everything in sequence.
    ## Created on: Monday December 16, 2019
    ## Coded by: Pali
    #########################################################################################
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
  MY_PWD="$HOME/scripts-made-by-pali/517-mggk-delete-every-2nd-csv-file"
  echo "USER = $USER // USER is ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
else
  MY_PWD="$HOME/Desktop/Y"
  echo "USER = $USER // USER is not ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
fi

cd $MY_PWD ;
################################################################################

BASH_SCRIPT_TO_DOWNLOAD="517-mggk-delete-every-2nd-csv-file-and-keep-max-15-csv-files-in-subdirs.sh"

echo ">>>> DOWNLOADING => $BASH_SCRIPT_TO_DOWNLOAD" ; echo;
curl -O https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/mggk_bash_scripts/517-mggk-delete-every-2nd-csv-file/$BASH_SCRIPT_TO_DOWNLOAD

## Moving to correct directory
mv $BASH_SCRIPT_TO_DOWNLOAD $MY_PWD/$BASH_SCRIPT_TO_DOWNLOAD

echo ">>>> RUNNING => $BASH_SCRIPT_TO_DOWNLOAD" ; echo;
bash $MY_PWD/$BASH_SCRIPT_TO_DOWNLOAD
