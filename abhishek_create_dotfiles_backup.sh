#!/bin/bash
## This bash script creates the backups of all the important DOTFILEs kinda files on our Macs. ##
BACKUP_DIR="$HOME/OneDrive/Apps2Sync/dotfiles_backups/$USER";
##################################
## Backup maker begins here ##
##################################
## Bash_Profile backup ##
today=`date "+%Y%m%d"`;

cp $HOME/.bash_profile $BACKUP_DIR/$today-bash_profile.txt;
echo "$HOME/.bash_profile ....................... COPYING DONE!"

## TextExpander backup ##
zip -rq $BACKUP_DIR/$today-TextExpander.zip $HOME/Dropbox/TextExpander
echo "$HOME/Dropbox/TextExpander ....................... ZIPPING and COPYING DONE!"

## ALL GitHub Files backup ##
zip -rq $BACKUP_DIR/$today-My-Github-Files.zip $HOME/Github
echo "$HOME/Github ....................... ZIPPING and COPYING DONE!"

## nvALT files backup ##
zip -rq $BACKUP_DIR/$today-nvALT_Notes_All.zip $HOME/Dropbox/_by_ABHISHEK/_NVnotes
echo "$HOME/Dropbox/_by_ABHISHEK/_NVnotes ....................... ZIPPING and COPYING DONE!"


#######################################################
########### do not edit anything below this ###########
echo "" ;
echo "############### ALL DONE #################" ;
echo "Opening Backup directory now ............" ;
open $BACKUP_DIR;
