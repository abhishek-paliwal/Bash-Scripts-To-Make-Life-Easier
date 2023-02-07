#/bin/bash

DIR_BACKUP="/home/00BACKUPS/";

## CREATE A BACKUPDIR FOR THE TIME OF THIS PROGRAM RUN
DIR_TODAY="$DIR_BACKUP/$(date +%Y%m%dT%H%M)_homedir" ; 
mkdir -p "$DIR_TODAY" ;


## RSYNC COMMAND TO RUN
echo ">> TIME_START: $(date)" ; 
rsync -a --info=progress2 --exclude="lost+found" --exclude=".cache" --exclude="GitHub" --exclude=".vscode-server" /home/ubuntu/ $DIR_TODAY/ ;
echo ">> TIME_END: $(date)" ;
