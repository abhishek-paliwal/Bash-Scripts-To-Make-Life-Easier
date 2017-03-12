#!bin/bash
####### only run this bash script to make ALL the indexes and backups on PALI's Macbook #########
BASEPATH="$HOME/GitHub/Bash-Scripts-To-Make-Life-Easier";

echo "creating markdown books index in dropbox......"
sh $BASEPATH/1_create_markdown_books_index.sh

echo "creating wallpapers index in github......"
sh $BASEPATH/2_create_wallpapers_index.sh

echo "creating logos index in dropbox......"
sh $BASEPATH/3_images2html-for-logos-indexing.sh

echo "creating LOW POLY backgrounds index in dropbox......"
sh $BASEPATH/4_images2html-for-lowpoly-backgrounds-indexing.sh

#### BACKUPS of our MACs ####
echo "creating backup of MACFILES in Onedrive......"
sh $BASEPATH/5-abhishek_create_MACFILES_backup.sh

#### BACKUP TO-AND-FROM DREAMCOMPUTE SERVER ####
## Running system commands (as Aliases from .bash_profile)
shopt -s expand_aliases ## This has to be done, else, aliases are not expanded in scripts.
source $HOME/.bash_profile ## Then, this also has to be done to use aliases in this script.
#### Actual backup command aliases below ##
echo "     ++++++++ Getting backups to-and-from DREAMCOMPUTE Server......"
echo "     >>>>>>>> BEGINNING: Backup [FROM] DreamCompute DONE. <<<<<<<"
1_backup_from_dreamcompute_server
echo "     >>>>>>>> DONE: Backup [FROM] DreamCompute DONE. <<<<<<<"

echo " = = = = > Opening the DreamCompute Backup directory..."
open $HOME/OneDrive/Apps2Sync/DreamCompute-VPS-Backup ; ## Don't forget to add semicolon at the end.

echo "     ++++++++ BACKUPS TO CDN: Creating backups to CDNs @ Dreamhost Hosted Sites......"
## BACKUPS TO CDN
echo "     >>>>>>>> BEGINNING: Backup [TO] downloads.concepro.com <<<<<<<"
1_backup_to_dreamcompute_server
echo "     >>>>>>>> DONE: Backup [TO] downloads.concepro.com <<<<<<<"
####
echo "     >>>>>>>> BEGINNING: Backup [TO] cdn.mygingergarlickitchen.com <<<<<<<"
1_backup_to_cdn_mggk
echo "     >>>>>>>> DONE: Backup [TO] cdn.mygingergarlickitchen.com <<<<<<<"

#########################################################
