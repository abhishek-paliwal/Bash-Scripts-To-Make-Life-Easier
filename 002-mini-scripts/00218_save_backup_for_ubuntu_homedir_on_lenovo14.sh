#/bin/bash

DIR_BACKUP="/home/00BACKUPS/";

## CREATE A BACKUPDIR FOR THE TIME OF THIS PROGRAM RUN
DIR_TODAY="$DIR_BACKUP/$(date +%Y%m%dT%H%M)_homedir" ; 
mkdir -p "$DIR_TODAY" ;


## RSYNC COMMAND TO RUN
echo ">> TIME_START: $(date)" ; 
rsync -a --info=progress2 --exclude-from="/home/ubuntu/rsync_exclusion_file.txt" /home/ubuntu/ $DIR_TODAY/ ;
echo ">> TIME_END: $(date)" ;

## CREATING A ZIP FILE FROM THIS ARCHIVE
echo ">> CREATING A ZIP FILE ..." ; 
zip -r $DIR_TODAY.zip $DIR_TODAY

## LIST CONTENTS OF BACKUP DIR
echo ">> LISTING CONTENTS OF BACKUP DIR ..." ; 
ls -al $DIR_BACKUP ; 
