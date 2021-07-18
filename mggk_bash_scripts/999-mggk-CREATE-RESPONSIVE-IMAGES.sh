#!/bin/bash

IMAGES_ROOTDIR="$REPO_MGGK/content/" ;
RESPONSIVE_IMAGES_ROOTDIR="$REPO_MGGK/static/wp-content/responsive-images" ;

##
tmp1="$DIR_Y/tmp1.txt" ;
tmp2="$DIR_Y/tmp2.txt" ;
echo "## Created by script: " > $tmp1

## In all md-files, find all lines with hugo figure tags and parse it
echo ">> Finding hugo figure tags in all md files in $IMAGES_ROOTDIR ... " ;     
for x in $(grep -irl "{{< figure" $IMAGES_ROOTDIR  ) ; 
do 
    #url_var=$(grep -i "^url: " $x) ; 
    grep -i "{{< figure" $x | sd ' ' '\n' | grep 'src' | sd '"' '' | sd 'src=' '' >> $tmp1
done

## Converting urls to local file paths
cat $tmp1 | grep -iv '#' |sort | uniq | sd "https://www.mygingergarlickitchen.com" "$REPO_MGGK/static" > $tmp2

##################################################################################


function FUNC_create_responsive_images_for_each_line () {
    ## FUNCTION TO CREATE RESPONSIVE IMAGES
    imagePath="$1" ;
    imagePath_basename=$(basename $imagePath) ;
    echo "Image = $imagePath"
    echo "BASENAME = $imagePath_basename" ;
    originalImageDir="$RESPONSIVE_IMAGES_ROOTDIR/original" ;
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
        if [[ -d "$resizeDir" ]] && [[ -d "$originalImageDir" ]] ; then
            echo "  Responsive Image directory already exists => $resizeDir" ;
            echo "  Original Image directory already exists   => $originalImageDir" ;
        else
            echo "  Responsive Image directory does not exist => $resizeDir" ;
            echo "  Original Image directory does not exist   => $originalImageDir" ;
            mkdir $resizeDir ;
            mkdir $originalImageDir ;
        fi
        ##
        ## Copy original image + only create responsive image if it does not exist
        if [[ -f "$outputImage" ]] && [[ -f "$CopiedOriginalImage" ]] ; then
            echo "  Output Image already exists => $outputImage" ; 
            echo "  Copied Original Image already exists => $CopiedOriginalImage" ; 
        else
            echo "These Images will be created ..." ; 
            echo "  Output image = $outputImage" ; 
            echo "  Copied original image = $CopiedOriginalImage" ; 
            cp "$imagePath" "$CopiedOriginalImage" ;
            convert $imagePath -resize "$resizeTo" -quality 80 "$outputImage" ;
        fi
    done
}

##################################################################################

## Creating responsive images corresponding to each image path
## but only if the original image file exists
while read -r line;
do
    echo ; 
    if [[ -f "$line" ]] ; then 
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
        echo ">> CURRENT LINE = $line" ; 
        echo "OK = Image Found" ; 
        FUNC_create_responsive_images_for_each_line "$line" ; ## Call function
    else 
        echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"; 
        echo "NOT OK = Image Not Found" ;
    fi
done < $tmp2
