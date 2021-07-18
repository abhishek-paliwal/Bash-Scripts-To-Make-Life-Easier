#!/bin/bash

IMAGES_ROOTDIR="$REPO_MGGK/content/" ;
RESPONSIVE_IMAGES_ROOTDIR="$DIR_Y" ;

##
tmp1="$DIR_Y/tmp1.txt" ;
tmp2="$DIR_Y/tmp2.txt" ;
echo "## Created by script: " > $tmp1

## In all md-files, find all lines with hugo figure tags and parse it
for x in $(grep -irl "{{< figure" $IMAGES_ROOTDIR  ) ; 
do 
    url_var=$(grep -i "^url: " $x) ; 
    grep -i "{{< figure" $x | sd ' ' '\n' | grep 'src' | sd '"' '' | sd 'src=' '' >> $tmp1
done

## Converting urls to local file paths
cat $tmp1 | sd "https://www.mygingergarlickitchen.com" "$REPO_MGGK/static" > $tmp2

##################################################################################


function FUNC_create_responsive_images_for_each_line () {
    ## FUNCTION TO CREATE RESPONSIVE IMAGES
    imagePath="$1" ;
    imagePath_basename=$(basename $imagePath) ;
    echo "Image = $imagePath"
    echo "BASENAME = $imagePath_basename" ;
    originalImageDir="$RESPONSIVE_IMAGES_ROOTDIR/original" ;
    mkdir $originalImageDir ;
    ## 
    myarray=(300px 425px 550px 675px 800px)
    ##
    for i in "${myarray[@]}"; do
        echo; 
        echo "#### CURRENT SIZE => $i" ;
        imageRes="$i" ;
        resizeTo="$(echo $i | sed 's/px//g')"
        resizeDir="$RESPONSIVE_IMAGES_ROOTDIR/$imageRes" ;
        outputImage="$resizeDir/$imageRes-$imagePath_basename"
        CopiedOriginalImage="$originalImageDir/$imagePath_basename"
        ##
        if [[ -d "$resizeDir" ]] ; then
            echo "Directory already exists => $resizeDir"
        else
            echo "Directory does not exist. Will be created => $resizeDir" ; 
            mkdir $resizeDir ;
        fi
        ##
        ## Copy original image + only create responsive image if it does not exist
        if [[ -f "$outputImage" ]] ; then
            echo "Image already exists => $outputImage" ; 
        else
            echo "($imageRes) Image will be created (+ original image copied)" ; 
            echo "Output image = $outputImage" ; 
            echo "Copied original image = $CopiedOriginalImage" ; 
            cp "$imagePath" "$CopiedOriginalImage" ;
            convert $imagePath -resize "$resizeTo" -quality 80 "$outputImage" ;
        fi
    done
}

##################################################################################

## Creating responsive images corresponding to each image path
while read -r line;
do
    echo "$line" ;
    if [[ -f "$line" ]] ; then 
        echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"; 
        echo "OK = Image Found" ; 
        FUNC_create_responsive_images_for_each_line "$line" ; ## Call function
    else 
        echo "NOT OK = Image Not Found" ;
    fi
done < $tmp2
