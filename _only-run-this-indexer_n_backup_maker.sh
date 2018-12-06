#!bin/bash
####### only run this bash script to make ALL the indexes and backups on PALI's Macbook #########
BASEPATH="$HOME/GitHub/Bash-Scripts-To-Make-Life-Easier";

echo "creating markdown books index in dropbox......"
sh $BASEPATH/1_create_markdown_books_index.sh

echo "creating wallpapers index in github......"
sh $BASEPATH/2_create_wallpapers_index.sh

echo "creating logos index in dropbox......"
sh $BASEPATH/10D_create_OUR_LOGOS_indexes.sh

echo "creating LOW POLY backgrounds index in dropbox......"
sh $BASEPATH/10C_create_LOWPOLY_indexes.sh

echo "creating JSON Wallpaper Templates index file in dropbox......"
sh $BASEPATH/10A_create_JSON_plus_image_indexes.sh

echo "creating SOCIAL MEDIA images index file in dropbox......"
sh $BASEPATH/10B_create_SOCIAL_MEDIA_image_indexes.sh

#### BACKUPS of our MACs ####
echo "creating backup of MACFILES in Onedrive......"
sh $BASEPATH/5-abhishek_create_MACFILES_backup.sh

#######################################################
#### CREATING SITEMAPS ####
echo "CREATING SITEMAPS..."
sh $BASEPATH/11-sitemap-for-website-generator.sh
#######################################################

########## KEEP THIS BLOCK AT THE END TO BACKUP ALL FILES TO SERVERS ############
#### BACKUP TO-AND-FROM DREAMCOMPUTE SERVER ####
## Running system commands (as Aliases from .bash_profile)
shopt -s expand_aliases ## This has to be done, else, aliases are not expanded in scripts.
source $HOME/.bash_profile ## Then, this also has to be done to use aliases in this script.
#### Actual backup command aliases below ##
echo "     ++++++++ Getting backups to-and-from DREAMCOMPUTE and KVM ARCH Server......"
#echo "     >>>>>>>> BEGINNING: Backup [FROM] DreamCompute DONE. <<<<<<<"
#echo
# 1_backup_from_dreamcompute_server
#echo "          Dreamcompute server has been discontinued. HENCE, NO BACKUP IS DONE. "
#echo "     >>>>>>>> DONE: Backup [FROM] DreamCompute DONE. <<<<<<<"
#echo

# 1_backup_from_kvmarch_server
echo "     >>>>>>>> BEGINNING: Backup [FROM] KVM ARCH Server DONE. <<<<<<<"
1_backup_from_kvmarch_server
echo "     >>>>>>>> DONE: Backup [FROM] KVM ARCH Server DONE. <<<<<<<"
echo

echo " = = = = > Now opening the DreamCompute + KVM ARCH VPS Backup directory..."
open $HOME/OneDrive/Apps2Sync/DreamCompute-VPS-Backup ; ## Don't forget to add semicolon at the end.

echo "     ++++++++ BACKUPS TO CDN: Creating backups to CDNs @ Dreamhost Hosted Sites......"
echo

## BACKUPS TO CDN
echo "     >>>>>>>> BEGINNING: Backup [TO] downloads.concepro.com <<<<<<<"
echo

1_backup_to_concepro_cdn
echo "     >>>>>>>> DONE: Backup [TO] downloads.concepro.com <<<<<<<"echo

####
echo "     >>>>>>>> BEGINNING: Backup [TO] cdn.mygingergarlickitchen.com <<<<<<<"
echo

1_backup_to_mggk_cdn
echo "     >>>>>>>> DONE: Backup [TO] cdn.mygingergarlickitchen.com <<<<<<<"
echo


########################## SCRIPT ENDS ########################
