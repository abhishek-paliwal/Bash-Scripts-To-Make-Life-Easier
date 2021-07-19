#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
##
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## USAGE:
    #### > bash $THIS_SCRIPT_NAME
    ################################################################################
    ## This script reads all figure shortcodes from all md files and creates 
    ## responsive images to be read by the srcset html image tags by the browser.
    ## Example image resolutions include: 300px, 425px, 550px, 675px, 800px, etc.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: July 18, 2021
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
## FUNCTION DEFINITIONS
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

################################################################################
IMAGES_ROOTDIR="$REPO_MGGK/content/" ;
RESPONSIVE_IMAGES_ROOTDIR="$REPO_MGGK/static/wp-content/responsive-images" ;
##
IMAGES_ROOTDIR_STEPS="$REPO_MGGK/static/wp-content/recipe-steps-images/" ;
RESPONSIVE_IMAGES_ROOTDIR_STEPS="$REPO_MGGK/static/wp-content/responsive-steps-images" ;

##
tmp1="$DIR_Y/tmp1-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
tmp2="$DIR_Y/tmp2-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "## Created by script: " > $tmp1
################################################################################

##------------------------------------------------------------------------------
## Image addition part 1 = Adding all images with hugo figure tags
echo ">> Image addition part 1 = Adding all images with hugo figure tags ... " ;     
for x in $(grep -irl "{{< figure" $IMAGES_ROOTDIR  ) ; 
do 
    grep -i "{{< figure" $x | sd ' ' '\n' | grep 'src' | sd '"' '' | sd 'src=' '' >> $tmp1
done

## Image addition part 2 = Adding all featured images to the list of images
echo ">> Image addition part 2 = Adding all featured images to the list of images ... " ;
grep -irh 'featured_image' $IMAGES_ROOTDIR | sd 'featured_image:' '' | sd ' ' '' | sd '"' '' | sd '^' 'https://www.mygingergarlickitchen.com' >> $tmp1

## Image addition part 3 = Adding all recipe steps imagesto the list of images
echo ">> Image addition part 3 = Adding all recipe steps imagesto the list of images ... " ;
replaceThis1="/Users/abhishek/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static" ;
replaceThis2="/home/ubuntu/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static" ;
fd --search-path="$IMAGES_ROOTDIR_STEPS" -a -e jpg | sd '$replaceThis1' ''| sd '$replaceThis2' '' | sd '^' 'https://www.mygingergarlickitchen.com' >> $tmp1

##------------------------------------------------------------------------------

########################################
## Converting urls to local file paths
cat $tmp1 | grep -iv '#' | sort | uniq | sd "https://www.mygingergarlickitchen.com" "$REPO_MGGK/static" > $tmp2

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
