#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ## This script makes backup of the home folder
    ## on raspberry pi computer in BACKUP_DIR.
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


IN_DIR="/home/pi" ;
BACKUP_DIR='/home/00-BACKUPS' ;

date_prefix="$(date +%Y%m%d)" ;

zip -r $BACKUP_DIR/$date_prefix-RPI4-BACKUP.zip $IN_DIR ;

echo "####################################################" ;
echo ">>>> BACKUP Done ..." ;
echo ">>>> Backup ZIP file created = $BACKUP_DIR/$date_prefix-RPI-BACKUP.zip" ; 
echo "####################################################" ;
