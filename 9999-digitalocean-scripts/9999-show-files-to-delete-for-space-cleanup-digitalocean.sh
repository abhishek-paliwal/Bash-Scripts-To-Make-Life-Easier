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

## DELETE ALL FILES WITH USER CONFIRMATION
echo;
echo ">> RUN THE FOLLOWING COMMAND TO DELETE ALL UNNCECESSARY FILES AT ONCE ..." ;
echo "
delete_CSVs_older_than_2_days ; 
delete_LOG_files_older_than_2_days ; 
delete_PNGs_older_than_2_days ; 
delete_ZIPs_older_than_3_days ; 
delete_TMPSUMMARY_files_older_than_2_days ;
" ; 
echo; echo;

