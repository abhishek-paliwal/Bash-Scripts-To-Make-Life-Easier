#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
## This bash script creates the backups of all the important files on our Macs. ##
## Just run this script on any Mac, and it will create that $USER's backup folder automatically.
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

######################################################
## FULL BACKUP OF IMPORTANT MAC FILES             ####
######################################################

#------------------------------------------------------------------------------
echo "Currently sourcing the bash color script, which outputs chosen texts in various colors ..." ;

source $DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/color-logger.sh

info "This enables use of keywords for coloring, such as: debug, info, error, success, warn, highlight." ;
debug "Read it's help by running: >> bash $DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/color-logger.sh -h"
#------------------------------------------------------------------------------


##################################################################################
## VARIABLE INITIALIZATION
## IF THE HOME USER IS UBUNTU, CHANGE THE HOME PATH (BCOZ WE ARE USING WSL)
if [ "$USER" == "ubuntu" ] ; then 
	BACKUP_HOMEDIR="$HOME/Desktop/00_BACKUPS_WSL/$USER" ;
	mkdir -p $BACKUP_HOMEDIR ;
elif [ "$USER" == "abhishek" ] ; then 
	BACKUP_HOMEDIR="$HOME/Dropbox/APPS-CONFIGS/_MAC_APPS/MBP15_dotfiles_backups/$USER" ;
else 
	BACKUP_HOMEDIR="$HOME/OneDrive/Apps2Sync/dotfiles_backups/$USER" ;
fi 

BACKUP_SUBDIR="$BACKUP_HOMEDIR/latest-rsync-MAC-backups" ;

CHOSEN_HOMEDIR_MSG="=====> Since, the user is $USER, the HOME is set as $HOME AND HOME_WINDOWS will be set as $HOME_WINDOWS"
echo; warn  "$CHOSEN_HOMEDIR_MSG" ; echo; 
##################################################################################

## BEFORE MAKING ANY BACKUPS, LET'S FIRST MAKE THE REQUIRED BACKUP DIRECTORIES
DIR_DOTFILES="$BACKUP_SUBDIR/1_backup_dotfiles"
DIR_PACKAGES="$BACKUP_SUBDIR/2_backup_packages"
DIR_ZIPS="$BACKUP_SUBDIR/3_backup_zips"

mkdir -p $DIR_DOTFILES $DIR_PACKAGES $DIR_ZIPS ;

######################################################
## RUNNING RSYNC FOR INCREMENTAL BACKUPS ##
## -a = It stands for "archive" and syncs recursively and preserves all permissions and everything
## -v = verbose
## -z = enables compression for less bandwidth usage
## -P = The first of these gives you a progress bar for the transfers
## --delete = Deletes everything at destination which has been deleted from the source
######################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Backing up important dotfiles and directories
declare -a DOTFILES_TO_BACKUP=("$HOME/.bashrc" "$HOME/.profile" "$HOME/.bash_profile" "$HOME/.bash_aliases" "$HOME/.zshrc" "$HOME/.vimrc" "$HOME/.tmux.conf" "$HOME/.p10k.zsh" "$HOME/.config/nvim/init.vim" "$HOME/.gitconfig" "$HOME/.aspell.en.pws") ;

for file in "${DOTFILES_TO_BACKUP[@]}"; do 
	echo ">>>> Currently working with => $file" ;
	rsync -avzP --delete $file $DIR_DOTFILES/ ;
done

## SINCE THE FOLLOWING DIRS HAVE SO MANY FILES, WHICH MAKES SYNCING TIME-CONSUMING, WE WILL
## MAKE A SINGLE TAR.GZ ARCHIVE FROM THOSE DIRECTORIES. ADD AS MANY DIRECTORIES AS YOU LIKE.
echo ">>>> Currently making a tar.gz archive from muliple directories ..." ;
tar -czvf $DIR_ZIPS/MULTIPLE_DIRECTORIES_BACKUP.tar.gz "$HOME/.ssh" "$HOME/.config" "$HOME/.aws"  

echo "BASH + ZSH Profiles + CONFIG_DIRS ....................... BACKUP DONE!"
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

FUNC_BACKUP_GITHUB_DIR () {
	## ALL GitHub Files backup ##
	mkdir -p $DIR_GITHUB $BACKUP_SUBDIR/3_backup_All_My_Github-Files/ ;
	RSYNC_EXCLUDE_FILE="$DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/0000-pali-rsync-exclude-file-list.txt"
	rsync -avzP --exclude-from "$RSYNC_EXCLUDE_FILE" --delete $DIR_GITHUB $BACKUP_SUBDIR/3_backup_All_My_Github-Files/
	echo ">> PS: Backup of HUGO-MGGK-OFFICIAL-WEBSITE/static/wp-content/uploads/ directory is not done. Modify the RSYNC_EXCLUDE_FILE = $RSYNC_EXCLUDE_FILE to include that directory too." ;
	echo "$HOME/Github ....................... BACKUP DONE!" ;
}
#RUNNING THE ABOVE FUNCION (UNCOMMENT IF NEEDED)
#FUNC_BACKUP_GITHUB_DIR

##################################################################################
echo; echo ">>>> BACKING UP THE INSTALLED APPS LIST FOR VARIOUS PACKAGE MANAGERS (homebrew, node, gem, python, etc.)" ; echo ;
info ">> Brew bundle dump ... running" ;
brew bundle dump --force --file="$DIR_PACKAGES/BREW_INSTALLS_FILENAME.TXT" ; 
info ">> Pip3 freeze ... running" ;
pip3 freeze > "$DIR_PACKAGES/PIP3_INSTALLED_requirements.txt" ; 
info ">> NPM package listing ... running" ;
npm -g ls --long --depth=0 > "$DIR_PACKAGES/NODE_NPM_GLOBALLY_INSTALLED_MODULES.txt" ; 
info ">> Pyenv Versioins and virtual environments listing ..." ; 
pyenv versions > "$DIR_PACKAGES/PYENV_VERSION_AND_VENVS.txt" ; 
success ">>>> ALL PACKAGE LISTINGS BACKUPS CREATED." ; echo ; 

##################################################################################

#######################################################
## ZIPPING EVERYTHING AND CREATING ZIPS WITH DATE-PREFIX
#######################################################

## If the weekday is Sunday=0, then make weekly backup:
if [ `date +%w` = 0 ] ; then
	# CREATING WEEKLY BACKUP
	tar -czvf  $BACKUP_HOMEDIR/`date +%Y%m%d`_WEEKLY_Full_backup_for_user_$USER.tar.gz $BACKUP_SUBDIR
	echo "Last Weekly backup created on Sunday, `date`"
else
	# CREATING DAILY BACKUP
	tar -czvf  $BACKUP_HOMEDIR/`date +%Y%m%d`_DAILY_Full_backup_for_user_$USER.tar.gz $BACKUP_SUBDIR
	echo "Dude, WEEKLY backups are only made on Sundays (Day=0), and today is `date +Day=%w=%A`!"
	echo "So, DAILY backup is created."
fi

## If the date of the month is 01 (first day of month), then make monthly backup:
if [ "$(date +%d)" = "01" ] ; then
	# CREATING MONTHLY BACKUP
	tar -czvf $BACKUP_HOMEDIR/`date +%Y%m%d`_MONTHLY_Full_backup_for_user_$USER.tar.gz $BACKUP_SUBDIR
	echo " >> Last monthly backup created on, `date`" ;
else
    echo " >> Today is not first of month, so NO monthly backup created on, `date`" ;
fi

#######################################################
########### Do not edit anything below this ###########
echo "" ;
echo "############### ALL DONE #################" ;
echo "Opening Backup directory now, after rsync'ing ............" ;
## IF THE HOME USER IS UBUNTU, CHANGE THE HOME PATH (BCOZ WE ARE USING WSL)
if [ "$USER"=="ubuntu" ] ; then 
	ONEDRIVE_DIR="$HOME_WINDOWS/OneDrive/Apps2Sync/dotfiles_backups/" ;
	echo; echo ">>>> Rsync'ing this backup directory (=> $BACKUP_HOMEDIR )to the Onedrive directory (=> $ONEDRIVE_DIR ) ..." ; echo ; 
	rsync -avzP $BACKUP_HOMEDIR $ONEDRIVE_DIR
	echo ; echo "##################################################################################" ;
	success ">>>> SHOWING DIRECTORY TREE FOR => $ONEDRIVE_DIR" ; tree $ONEDRIVE_DIR ;
	#explorer.exe . 
else 
	open $BACKUP_HOMEDIR;
fi 

## Printing final directory tree
echo ; echo "##################################################################################" ;
success ">>>> SHOWING DIRECTORY TREE FOR => $BACKUP_HOMEDIR" ; tree $BACKUP_HOMEDIR ;
echo; warn  "$CHOSEN_HOMEDIR_MSG" ; echo; 
