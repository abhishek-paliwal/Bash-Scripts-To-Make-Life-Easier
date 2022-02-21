#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## USAGE:
    #### > bash $THIS_SCRIPT_NAME
    ################################################################################
    ## This program deletes all temporary unnecessary files on digitalocean server.
    #######################################
    ## IMPORTANT NOTE: This program should only be run on DIGITALOCEAN SERVER.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2022-02-21
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 
##############################################################################

function delete_CSVs_older_than_2_days () {
    echo ">>>>>>>>>>> CURRENT FUNCTION => ${FUNCNAME[0]} <<<<<<<<<<<" ; 
    MYDIR="/home/ubuntu/scripts-made-by-pali/602-mggk-python-plotting/_TMP_FINAL_CSVs/" ; 
    files_to_delete=$(fd . $MYDIR -d1 -t f -e csv --change-older-than 2days) ; 
    echo; 
    echo $files_to_delete | sed "s/ /\n/g" ; 
    read -p "If OKAY, press ENTER to DELETE ..." ; 
    if [ -z "$files_to_delete" ] ; then echo "NOTE: No files to delete." ; else echo "NOTE: Files will be deleted." ; rm $files_to_delete ; fi
}

function delete_LOG_files_older_than_2_days () {
    MYDIR="/home/ubuntu/scripts-made-by-pali/517-mggk-delete-every-2nd-csv-file/" ; 
    files_to_delete=$(fd LOGFILE $MYDIR -d1 -t f -e txt --change-older-than 2days) ; 
    echo; 
    echo $files_to_delete | sed "s/ /\n/g" ; 
    read -p "If OKAY, press ENTER to DELETE ..." ; 
    rm $files_to_delete ;
}

function delete_PNGs_older_than_2_days () { 
    MYDIR="/var/www/vps.abhishekpaliwal.com/html/scripts-html-outputs/602-mggk-plotting-outputs/" ; 
    files_to_delete=$(fd . $MYDIR -d1 -t f -e png --change-older-than 2days) ; 
    echo; 
    echo $files_to_delete | sed "s/ /\n/g" ; 
    read -p "If OKAY, press ENTER to DELETE ..." ; 
    rm $files_to_delete ;
}

function delete_TMPSUMMARY_files_older_than_2_days () { 
    MYDIR="/home/ubuntu/scripts-made-by-pali/600-mggk-ai-nlp-scripts/" ; 
    files_to_delete=$(fd TMP_SUMMARY_FOR_LAST_RUN $MYDIR -d1 -t f -e txt --change-older-than 2days) ; 
    echo; echo $files_to_delete | sed "s/ /\n/g" ; 
    read -p "If OKAY, press ENTER to DELETE ..." ; 
    rm $files_to_delete ;
}

function delete_ZIPs_older_than_3_days () { 
    MYDIR="/home/00-BACKUPS-BY-PALI/" ; 
    files_to_delete=$(fd DAILY $MYDIR -d1 -t f -e zip --change-older-than 3days) ; 
    echo; echo $files_to_delete | sed "s/ /\n/g" ; 
    read -p "If OKAY, press ENTER to DELETE ..." ; 
    rm $files_to_delete ;
}

function delete_all_TMP_FILEs () {
delete_ZIPs_older_than_3_days ; 
delete_PNGs_older_than_2_days ; 
delete_CSVs_older_than_2_days ; 
delete_LOG_files_older_than_2_days ; 
delete_TMPSUMMARY_files_older_than_2_days ;
}
################################################################################

## Calling the main function
delete_all_TMP_FILEs ;

