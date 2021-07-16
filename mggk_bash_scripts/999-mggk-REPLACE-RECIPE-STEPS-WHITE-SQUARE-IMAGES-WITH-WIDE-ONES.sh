#!/bin/bash

tmp1="$DIR_Y/tmp_recipe_steps_images_dimensions_ALL.txt" ;
tmp2="$DIR_Y/tmp_recipe_steps_images_dimensions_ALL_1x1.txt" ;

##
searchPath="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/wp-content/recipe-steps-images" ;
for x in $(fd --search-path="$searchPath" -e jpg) ; do var=$(identify -format "%wx%h\n" $x) ; echo "$var=$x" ; done > $tmp1 ;
##
cat $tmp1 | ag 1x1= > $tmp2 | sd '1x1=' '' | sort > $tmp2 ;

######
function FUNC_copy_white_images() {
    ## Create custom white image using imagemagick convert command
    whiteImage="$DIR_Y/imagemagick_white.jpg" ;
    convert -size 1280x1 canvas:white $whiteImage ;
    ## Copy image one by one at current line path
    input="$tmp2" ;
    while IFS= read -r line
    do
        echo ">> CURRENT LINE: $line" ; 
        cp $whiteImage $line ;
    done < "$input"
}
FUNC_copy_white_images
######