#/bin/bash

#############################################################################
## THIS PROGRAM RENAMES ALL JPG IMAGES PRESENT IN SUB-DIRECTORIES IN A GIVEN 
## DIRECTORY BASED UPON THEIR PARENT DIRECTORY NAME. 
#############################################################################

DIR="/mnt/d/OneDrive/00-MGGK-ARCHIVED-VIDEOS-PHOTOS/2019-2021-recipe-photos-videos/2019-ALL-ENGLISH-RECIPE-VIDEOS/20190701-Ghee-Mysore-Pak/Mysore-Pak-Final" ; 
INFILE="$DIR_Y/tmp.txt" ; 

## listing dirs with the desired images names
fd -tf 'img|dsc|anu-' --search-path="$DIR"  ; 
fd -tf 'img|dsc|anu-' --search-path="$DIR" -x dirname {} | sort -u > $INFILE ; 

echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
cat $INFILE ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_ACTUALLY_RENAME_FILES () {
####
    for x in $(cat $INFILE | head -100) ; do 
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>";  
        cd $x ; 
        ls $x/* ; 
        bash $REPO_SCRIPTS/1005_rename_jpg_png_images_sequentially_based_upon_parent_directory.sh ; 
        ls $x/* ; 
        cd $DIR ; 
        sleep 2; 
done
####
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Call function
FUNC_ACTUALLY_RENAME_FILES