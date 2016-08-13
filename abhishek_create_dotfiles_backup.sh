#!/bin/bash
USERNAME="abhishek"
ROOT="/Users/$USERNAME";
BACKUP_DIR="$ROOT/OneDrive/Apps2Sync/dotfiles_backups/$USERNAME";
##################################
## Backup maker begins here ##
##################################
## Bash_Profile backup ##
today=`date "+%Y%m%d"`;

cp $ROOT/.bash_profile $BACKUP_DIR/$today-bash_profile.txt;
echo "$ROOT/.bash_profile ....................... COPYING DONE!"

## TextExpander backup ##
zip -rq $BACKUP_DIR/$today-TextExpander.zip $ROOT/Dropbox/TextExpander
echo "$ROOT/Dropbox/TextExpander ....................... ZIPPING and COPYING DONE!"

## ALL GitHub Files backup ##
zip -rq $BACKUP_DIR/$today-My-Github-Files.zip $ROOT/Github
echo "$ROOT/Github ....................... ZIPPING and COPYING DONE!"








########### do not edit anything below this ###########
echo "" ;
echo "############### ALL DONE #################" ;
echo "Opening Backup directory now ............" ;
open $BACKUP_DIR;
