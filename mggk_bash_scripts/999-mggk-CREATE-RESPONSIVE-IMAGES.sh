#!/bin/bash

#IMAGES_ROOTDIR="$REPO_MGGK/static/wp-content/youtube_video_cover_image"
IMAGES_ROOTDIR="$REPO_MGGK/content/" ;

tmp1="$DIR_Y/tmp1.txt" ;
tmp2="$DIR_Y/tmp2.txt" ;
echo "## Created by script: " > $tmp1

## In all md-files, find all lines with hugo figure tags and parse it
for x in $(grep -irl "{{< figure" $IMAGES_ROOTDIR  ) ; 
do 
    url_var=$(grep -i "^url: " $x) ; 
    grep -i "{{< figure" $x | sd ' ' '\n' | grep 'src' | sd '"' '' | sd 'src=' '' >> $tmp1
done

##
cat $tmp1 | sd "https://www.mygingergarlickitchen.com" "$REPO_MGGK/static" > $tmp2

##################################################################################


function FUNC_create_responsive_images_for_each_line () {
    ## FUNCTION TO CREATE RESPONSIVE IMAGES
    imagePath="$1" ;
    imagePath_basename=$(basename $imagePath) ;
    echo "$imagePath // BASENAME = $imagePath_basename)" ;
    ## 
    myarray=(300px 425px 550px 675px 800px)
    ##
    for i in "${myarray[@]}"; do
        echo; 
        echo "#### CURRENT SIZE => $i" ;
        imageRes="$i" ;
        resizeTo="$(echo $i | sed 's/px//g')"
        resizeDir="$DIR_Y/$imageRes" ;
        ##
        if [[ -d "$resizeDir" ]] ; then
            echo "Directory already exists => $resizeDir"
        else
            echo "Directory does not exist. Will be created => $resizeDir" ; 
            mkdir $resizeDir ;
        fi
        ##
        ## final resizing of jpg images
        echo "// $i => resizing is about to begin ..." ;
        # fdfind --search-path="$IMAGES_ROOTDIR" -a -e jpg -x convert {} -resize "$resizeTo" -quality 80 "$resizeDir/$imageRes-{/.}.jpg" ;
        convert $imagePath -resize "$resizeTo" -quality 80 "$resizeDir/$imageRes-$imagePath_basename" ;
    done
}

##################################################################################

## Creating responsive images corresponding to each image path
while read -r line;
do
    echo "$line" ;
    if [[ -f "$line" ]] ; then 
        echo "OK = Image Found" ; 
        ## Call function
        FUNC_create_responsive_images_for_each_line "$line"
    else 
        echo "NOT OK = Image Not Found" ;
    fi
done < $tmp2
