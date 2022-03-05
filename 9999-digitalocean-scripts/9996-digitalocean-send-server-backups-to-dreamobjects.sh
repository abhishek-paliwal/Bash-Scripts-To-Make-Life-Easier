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
    ## This program copies all backup zip files to a dedicated dreamobjects bucket.
    ## This program uses rclone too. Install it via linuxbrew.
    #######################################
    ## IMPORTANT NOTE: This program should only be run on DIGITALOCEAN SERVER.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2022-02-11
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

DIR_LOCAL_BACKUP="/home/00-BACKUPS-BY-PALI/" ; 
BUCKET_REMOTE_BACKUP="dreamobjects:private-digitalocean-backups" ;

## Check for the presence of directory paths
if [ -d "$DIR_LOCAL_BACKUP" ] ; then 
    echo "SUCCESS = Directory exists => $DIR_LOCAL_BACKUP" ; 
else 
    echo "FAILURE = Directory does not exist => $DIR_LOCAL_BACKUP. Program will exit now." ;
    exit 1 ; 
fi 
##
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;

## COPYING ALL ZIP FILES ONE BY ONE TO REMOTE BUCKET
for myfile in $DIR_LOCAL_BACKUP/*.zip ; do
    echo ">> CURRENT FILE = $myfile" ;
    rclone copy -P "$myfile" "$BUCKET_REMOTE_BACKUP" ; 
done 
## LISTING REMOTE DIRECTORY STRUCTURE TO CHECK
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo ">> LISTING REMOTE DIRECTORY STRUCTURE TO CHECK" ; 
rclone ls "$BUCKET_REMOTE_BACKUP" ;
##############################################################################

