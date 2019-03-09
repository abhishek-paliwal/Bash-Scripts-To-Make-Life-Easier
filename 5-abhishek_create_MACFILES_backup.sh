#!/bin/bash
## This bash script creates the backups of all the important files on our Macs. ##
## Just run this script on any Mac, and it will create that $USER's backup folder automatically.
######################################################
## FULL BACKUP OF IMPORTANT MAC FILES             ####
######################################################

BACKUP_HOMEDIR="$HOME/OneDrive/Apps2Sync/dotfiles_backups/$USER" ;
BACKUP_SUBDIR="$BACKUP_HOMEDIR/latest-rsync-MAC-backups" ;

######################################################
## RUNNING RSYNC FOR INCREMENTAL BACKUPS ##
## -a = It stands for "archive" and syncs recursively and preserves all permissions and everything
## -v = verbose
## -z = enables compression for less bandwidth usage
## -P = The first of these gives you a progress bar for the transfers
## --delete = Deletes everything at destination which has been deleted from the source
######################################################

## Backing up important directories
rsync -avzP --delete $HOME/.bash_profile $BACKUP_SUBDIR/1_backup_bash_profile/
rsync -avzP --delete $HOME/.bash_aliases $BACKUP_SUBDIR/1_backup_bash_profile/
rsync -avzP --delete $HOME/.zshrc $BACKUP_SUBDIR/1_backup_bash_profile/
rsync -avzP --delete $HOME/.oh-my-zsh $BACKUP_SUBDIR/1_backup_bash_profile/
## Renaming the file with Dot Name to see easily.
mv $BACKUP_SUBDIR/1_backup_bash_profile/.bash_profile $BACKUP_SUBDIR/1_backup_bash_profile/bash_profile.txt
mv $BACKUP_SUBDIR/1_backup_bash_profile/.bash_aliases $BACKUP_SUBDIR/1_backup_bash_profile/bash_aliases.txt
mv $BACKUP_SUBDIR/1_backup_bash_profile/.zshrc $BACKUP_SUBDIR/1_backup_bash_profile/zshrc.txt
mv $BACKUP_SUBDIR/1_backup_bash_profile/.oh-my-zsh $BACKUP_SUBDIR/1_backup_bash_profile/oh-my-zsh
echo "BASH + ZSH Profiles ....................... BACKUP DONE!"

## TextExpander backup ##
#rsync -avzP --delete $HOME/Dropbox/TextExpander $BACKUP_SUBDIR/2_backup_TextExpander/
#echo "$HOME/Dropbox/TextExpander ....................... BACKUP DONE!"

## ALL GitHub Files backup ##
## Uncomment the following line to resume GitHub files' backup
#rsync -avzP --delete $HOME/Github $BACKUP_SUBDIR/3_backup_All_My_Github-Files/
echo "File last updated: $(date)" > $BACKUP_SUBDIR/3_backup_All_My_Github-Files/_README.txt
echo "No backup of Github directory is made after March 09 2019." >> $BACKUP_SUBDIR/3_backup_All_My_Github-Files/_README.txt
echo ">> To resume backups, uncomment the rsync Github line in file 5-abhishek_create_MACFILES_backup.sh ." >> $BACKUP_SUBDIR/3_backup_All_My_Github-Files/_README.txt
echo "$HOME/Github ....................... BACKUP DONE!"

## nvALT files backup ##
rsync -avzP --delete $HOME/Dropbox/_by_ABHISHEK/_NVnotes $BACKUP_SUBDIR/4_backup_All_nvALT_Notes/
echo "$HOME/Dropbox/_by_ABHISHEK/_NVnotes ....................... BACKUP DONE!"


#######################################################
## ZIPPING EVERYTHING AND CREATING ZIPS WITH DATE-PREFIX
#######################################################

## If the weekday is Sunday=0, then make weekly backup:
if [ `date +%w` = 0 ] ; then
	# CREATING WEEKLY BACKUP
	zip -r $BACKUP_HOMEDIR/`date +%Y%m%d`_WEEKLY_Full_backup_for_user_$USER.zip $BACKUP_SUBDIR
	echo "Last Weekly backup created on Sunday, `date`"
else
	# CREATING DAILY BACKUP
	zip -r $BACKUP_HOMEDIR/`date +%Y%m%d`_DAILY_Full_backup_for_user_$USER.zip $BACKUP_SUBDIR
	echo "Dude, WEEKLY backups are only made on Sundays (Day=0), and today is `date +Day=%w=%A`!"
	echo "So, DAILY backup is created."
fi

## If the date of the month is 01 (first day of month), then make monthly backup:
if [ "$(date +%d)" = "01" ] ; then
	# CREATING MONTHLY BACKUP
	zip -r $BACKUP_HOMEDIR/`date +%Y%m%d`_MONTHLY_Full_backup_for_user_$USER.zip $BACKUP_SUBDIR
	echo " >> Last monthly backup created on, `date`" ;
else
    echo " >> Today is not first of month, so NO monthly backup created on, `date`" ;
fi

#######################################################
########### Do not edit anything below this ###########
echo "" ;
echo "############### ALL DONE #################" ;
echo "Opening Backup directory now ............" ;
open $BACKUP_HOMEDIR;
