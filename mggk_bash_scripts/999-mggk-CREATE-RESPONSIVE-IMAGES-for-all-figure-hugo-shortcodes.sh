#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
##
time_taken="$DIR_Y/tmp-time-taken-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "$(date) = START-TIME" > $time_taken

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
    RESPONSIVE_IMAGES_ROOTDIR="$2" ;
    imagePath_basename=$(basename $imagePath) ;
    #echo "Image = $imagePath"
    #echo "BASENAME = $imagePath_basename" ;
    originalImageDir="$RESPONSIVE_IMAGES_ROOTDIR/original" ;
    #### 
    myarray=(300px 425px 550px 675px 800px)
    ####
    for i in "${myarray[@]}"; do
        #echo; 
        #echo "#### CURRENT SIZE => $i" ;
        imageRes="$i" ;
        resizeTo="$(echo $i | sed 's/px//g')"
        resizeDir="$RESPONSIVE_IMAGES_ROOTDIR/$imageRes" ;
        outputImage="$resizeDir/$imageRes-$imagePath_basename"
        CopiedOriginalImage="$originalImageDir/$imagePath_basename"
        ##
        if [[ -d "$resizeDir" ]] && [[ -d "$originalImageDir" ]] ; then
            echo;
            #echo "  Responsive Image directory already exists => $resizeDir" ;
            #echo "  Original Image directory already exists   => $originalImageDir" ;
        else
            #echo "  Responsive Image directory does not exist => $resizeDir" ;
            #echo "  Original Image directory does not exist   => $originalImageDir" ;
            mkdir $resizeDir ;
            mkdir $originalImageDir ;
        fi
        ##
        ## Copy original image + only create responsive image if it does not exist
        ## Also, compare md5sums of the two files to check that the content has not changed.
        m1sum=$(md5sum "$imagePath" | cut -d' ' -f1) ; 
        ##
        if [[ -f "$CopiedOriginalImage" ]] ; then 
            #echo "  Copied Original Image already exists => $CopiedOriginalImage" ; 
            m2sum=$(md5sum "$CopiedOriginalImage" | cut -d' ' -f1) ; 
        else 
            m2sum="XXXXXXXXXX" ; 
        fi
        ##
        if [[ "$m1sum"=="$m2sum" ]] ; then
            echo "md5sum comparison = OK // m1sum = $m1sum // m2sum = $m2sum";
        else
            #echo "These Images will be created ..." ; 
            #echo "  Output image = $outputImage" ; 
            #echo "  Copied original image = $CopiedOriginalImage" ; 
            cp "$imagePath" "$CopiedOriginalImage" ;
            convert $imagePath -resize "$resizeTo" -quality 80 "$outputImage" ;
        fi
    done
}
##################################################################################

##------------------------------------------------------------------------------
## BEGIN: BLOCK 1 = Creating responsive images for all figure images + all featured images
##------------------------------------------------------------------------------
IMAGES_ROOTDIR="$REPO_MGGK/content/" ;
RESPONSIVE_IMAGES_ROOTDIR="$REPO_MGGK/static/wp-content/responsive-images" ;
##
tmpA1="$DIR_Y/tmpA1-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
tmpA2="$DIR_Y/tmpA2-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "## Created by script: " > $tmpA1
#####################################

## Image addition part 1.1 = Adding all images with hugo figure tags
echo ">> Image addition part 1 = Adding all images with hugo figure tags ... " ;     
for x in $(grep -irl "{{< figure" $IMAGES_ROOTDIR  ) ; 
do 
    grep -i "{{< figure" $x | sd ' ' '\n' | grep 'src' | sd '"' '' | sd 'src=' '' >> $tmpA1
done

## Image addition part 1.2 = Adding all featured images to the list of images
echo ">> Image addition part 2 = Adding all featured images to the list of images ... " ;
grep -irh 'featured_image' $IMAGES_ROOTDIR | sd 'featured_image:' '' | sd ' ' '' | sd '"' '' | sd '^' 'https://www.mygingergarlickitchen.com' >> $tmpA1

########################################
## Converting urls to local file paths
echo ">> Converting urls to local file paths ..." ; 
cat $tmpA1 | grep -iv '#' | sort | uniq | sd "https://www.mygingergarlickitchen.com" "$REPO_MGGK/static" > $tmpA2

## Creating responsive images corresponding to each image path
## but only if the original image file exists
while read -r line;
do
    #echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"; 
    if [[ -f "$line" ]] ; then 
        echo "SUCCESS = Image Found = $line" ; 
        FUNC_create_responsive_images_for_each_line "$line" "$RESPONSIVE_IMAGES_ROOTDIR" ; ## Call function
    else 
        echo "FAILURE = Image Not Found = $line" ;
    fi
done < $tmpA2
##------------------------------------------------------------------------------
## END: BLOCK 1
##------------------------------------------------------------------------------

##------------------------------------------------------------------------------
## BEGIN: BLOCK 2 = Creating responsive images for recipe steps images
##------------------------------------------------------------------------------
IMAGES_ROOTDIR_STEPS="$REPO_MGGK/static/wp-content/recipe-steps-images/" ;
#RESPONSIVE_IMAGES_ROOTDIR_STEPS="$REPO_MGGK/static/wp-content/responsive-steps-images" ;
RESPONSIVE_IMAGES_ROOTDIR_STEPS="$DIR_Y" ;
##
tmpB1="$DIR_Y/tmpB1-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
tmpB2="$DIR_Y/tmpB2-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "## Created by script: " > $tmpB1
#####################################

## Image addition part 2.1 = Adding all recipe steps imagesto the list of images
echo ">> Image addition part 3 = Adding all recipe steps imagesto the list of images ... " ;
replaceThis1="/Users/abhishek/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static" ;
replaceThis2="/home/ubuntu/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static" ;
fd --search-path="$IMAGES_ROOTDIR_STEPS" -a -e jpg | sd "$replaceThis1" "" | sd "$replaceThis2" "" | sd '^' 'https://www.mygingergarlickitchen.com' >> $tmpB1

########################################
## Converting urls to local file paths
echo ">> Converting urls to local file paths ..." ; 
cat $tmpB1 | grep -iv '#' | sort | uniq | sd "https://www.mygingergarlickitchen.com" "$REPO_MGGK/static" > $tmpB2

## Creating responsive images corresponding to each image path
## but only if the original image file exists
while read -r line;
do
    #echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
    if [[ -f "$line" ]] ; then 
        echo "SUCCESS = Recipe Step Image Found = $line" ; 
        FUNC_create_responsive_images_for_each_line "$line" "$RESPONSIVE_IMAGES_ROOTDIR_STEPS" ; ## Call function
    else 
        echo "FAILURE = Recipe Step Image Not Found = $line" ; 
    fi
done < $tmpB2
##------------------------------------------------------------------------------
## END: BLOCK 2
##------------------------------------------------------------------------------

################################################################################
############################### PROGRAM ENDS ###################################
################################################################################
echo "$(date) = END-TIME" >> $time_taken
cat $time_taken

