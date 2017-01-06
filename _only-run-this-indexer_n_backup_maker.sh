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

#### MAC BACKUPS ####
echo "creating MACFILES backups in Onedrive......"
sh $BASEPATH/5-abhishek_create_MACFILES_backup.sh
