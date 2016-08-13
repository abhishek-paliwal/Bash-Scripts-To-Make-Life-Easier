#!bin/bash
####### only run this bash script to make ALL the indexes and backups on abhishek's Macbook #########
BASEPATH="/Users/abhishek/GitHub/Bash-Scripts-To-Make-Life-Easier";

echo "creating markdown books index in dropbox......"
sh $BASEPATH/_create_markdown_books_index.sh

echo "creating wallpapers index in github......"
sh $BASEPATH/_create_wallpapers_index.sh

echo "creating logos index in dropbox......"
sh $BASEPATH/_images2html-for-logos-indexing.sh

#### BACKUPS ####
echo "creating DOTfiles backups in Onedrive......"
sh $BASEPATH/abhishek_create_dotfiles_backup.sh
