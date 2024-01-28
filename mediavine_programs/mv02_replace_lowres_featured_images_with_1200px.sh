#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

## SETTING VARIABLES
ROOTDIR="$REPO_MGGK/content/allrecipes" ;  # use this dir for reading files with frontmatter
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
DIR_TMPIMAGES="$WORKDIR/_OUTPUT_IMAGES"
##
## create dirs if not present
mkdir -p "$WORKDIR" ;
mkdir -p "$DIR_TMPIMAGES" ; 
## 
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 


## GETTING ALL FEATURED IMAGES
ag '^featured_image:' "$ROOTDIR" | awk -F ':' '{print $4}' | sd '^ ' "$REPO_MGGK/static" | xargs -I {} cp {} "$DIR_TMPIMAGES/"

## PRINTING THE IMAGES DIMENSIONS
cd "$DIR_TMPIMAGES/" ; 
bash "$REPO_SCRIPTS_MINI"/00225_print_images_dimensions_and_filesizes_jpg_png_using_imagemagick_in_pwd.sh ; 
