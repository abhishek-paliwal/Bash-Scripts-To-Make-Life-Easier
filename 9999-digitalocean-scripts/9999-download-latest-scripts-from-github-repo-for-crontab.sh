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
  ## Add more scripts as needed.
  ################################################################################
  ## IMPORTANT NOTE: Please dont include this script to download itself.
  ################################################################################
  ## Created on: July 21, 2021
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

WORKDIR="/home/ubuntu/scripts-made-by-pali" ; 
#WORKDIR="$DIR_Y" ; 
echo ">> WORKDIR = $WORKDIR" ;

## ADD FULL GITHUB SCRIPT PATH TO FOLLOWING ARRAY (one on each line)
ARRAY_download_these_scripts=(https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/9999-digitalocean-scripts/9999-show-files-to-delete-for-space-cleanup-digitalocean.sh
https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/mggk_bash_scripts/901-mggk-GET-CLOUDFLARE-CACHE-STATUS.sh) ;

for i in "${ARRAY_download_these_scripts[@]}"; do
    echo "#################################################" ;
    echo ">> Current Script => $i" ;
    script_basename=$(basename $i) ;
    ## Deleting existing version of this script
    rm $WORKDIR/$script_basename ;
    ## Downloading ...
    wget $i ;
    ## Moving THIS SCRIPT to our desired directory
    mv $script_basename $WORKDIR/$script_basename ;
done