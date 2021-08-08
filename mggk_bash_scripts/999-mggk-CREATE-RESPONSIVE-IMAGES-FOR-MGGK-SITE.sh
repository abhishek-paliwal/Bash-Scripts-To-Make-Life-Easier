#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

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
    ## This script reads all figure shortcodes + featured images + recipe steps images 
    ## from all md files and creates 
    ## responsive images to be read by the srcset html image tags by the browser.
    ## Example image resolutions include: 350px, 425px, 550px, 675px, 800px, etc.
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

## Only run this program on MAC OS
echo "##------------------------------------------------------------------------------" ;
echo "IMPORTANT NOTE: This script only runs on MAC OS." ; 
if [ "$USER" == "abhishek" ] ; then
  echo "This is MAC OS. So, script this will continue => $THIS_SCRIPT_NAME " ;
else
  echo "This is not MAC OS. So, this script will stop and exit now => $THIS_SCRIPT_NAME " ;
  exit 1 ;
fi

echo "CURRENTLY RUNNING SCRIPT = $THIS_SCRIPT_NAME" ;
## Present working directory
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION";
mkdir -p $WORKDIR ;
cd $WORKDIR ;
echo;
echo ">> Present working directory = $WORKDIR" ;
echo;
##
time_taken="$WORKDIR/tmp-time-taken-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "$(date) = START-TIME" > $time_taken

##################################################################################
## FUNCTION DEFINITIONS
function FUNC_create_responsive_images () {
    ## FUNCTION TO CREATE RESPONSIVE IMAGES
    RESPONSIVE_IMAGES_ROOTDIR="$1" ;
    ALL_IMAGES_FILE="$2" ;
    PREFIX="$3" ;
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
    echo "CURRENT RESPONSIVE DIR IN USE => $RESPONSIVE_IMAGES_ROOTDIR" ;
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
    ##
    FINAL_FILE="$WORKDIR/$PREFIX-create-these-responsive-images-FINAL.txt" ;
    originalImageDir="$RESPONSIVE_IMAGES_ROOTDIR/original" ;
    mkdir -p $originalImageDir ;
    md51="$WORKDIR/$PREFIX-md5sums-before.txt"
    md52="$WORKDIR/$PREFIX-md5sums-after.txt"

    ## Calculate md5sums after of the existing images
    FUNC_calc_md5sums $md51

    ## The following command splits a large text file into separate smaller 
    ## text files as xaa ,xab, xac, xad, etc, each containing 2000 lines
    echo ">> Splitting big $ALL_IMAGES_FILE to chunks with 2000 lines each ..." ;
    rm $WORKDIR/xa* ; ## remove these files if already exist
    split -l 2000 $ALL_IMAGES_FILE ;

    ## Read these files and copy all images to orig dir
    echo ">> Copying all files => (from $ALL_IMAGES_FILE)(to $originalImageDir )" ;
    for myfile in $WORKDIR/xa* ; do cp $(cat $myfile) $originalImageDir/ ; done

    ## Calculate md5sums after copying images
    FUNC_calc_md5sums $md52

    ## Finding diff and printing filepaths
    echo ">> Doing diff of md5sums ..." ;
    diff $md51 $md52 | grep '>' | awk '{print $3}' | sort > $FINAL_FILE

    ## Read file line by line and create responsive image
    myarray=(350px 425px 550px 675px 800px)
    ##
    total_lines=$(cat $FINAL_FILE | wc -l ) ;
    count=0;
    while read -r line; 
    do
    ####
        ((count++)) ;
        echo "Currently reading = $count of $total_lines" ;
        ####
        for i in "${myarray[@]}"; do
        ####
            imageRes="$i" ;
            resizeDimen="$(echo $i | sed 's/px//g')"
            resizeDir="$RESPONSIVE_IMAGES_ROOTDIR/$imageRes" ;
            imagePath="$line" ;
            imagePath_basename=$(basename $imagePath) ;
            outputImage="$resizeDir/$imageRes-$imagePath_basename" ;
            mkdir -p $resizeDir ;
            convert $line -resize "$resizeDimen" -quality 80 "$outputImage" ;
        ####           
        done
    ####
    done < $FINAL_FILE
    ####
    FUNC_ONLY_RUN_FOR_THIS_USER "$RESPONSIVE_IMAGES_ROOTDIR" ;
}

#######
function FUNC_calc_md5sums() {
    ## Calculate md5sums of the existing files
    outputFile="$1" ;
    echo "Writing md5sums to => $outputFile" ; 
    fd --search-path="$originalImageDir" -x md5sum > $WORKDIR/tmp-md5.txt ;
    sort $WORKDIR/tmp-md5.txt > "$outputFile" ;
}

#######
function FUNC_ONLY_RUN_FOR_THIS_USER () {
    DirImages="$1" ;
    ## ## Only run this program for this user
    echo "IMPORTANT NOTE: This script only runs on MAC OS." ; 
    if [ "$USER" == "abhishek" ] ; then
        echo "This is MAC OS. So, script will remove extended image attributes ..." ;
        xattr -rc "$1" ;
    else
        echo "This is not MAC OS. So, script will continue normally." ;
    fi
}

##################################################################################

##------------------------------------------------------------------------------
## BEGIN: BLOCK 1 = Creating responsive images for all figure images + all featured images
##------------------------------------------------------------------------------
IMAGES_ROOTDIR="$REPO_MGGK/content/" ;
IMAGES_ROOTDIR_ZZMGGK="$REPO_ZZMGGK/content/" ; 
RESPONSIVE_IMAGES_ROOTDIR="$REPO_MGGK/static/wp-content/responsive-images" ;
##
tmpA1="$WORKDIR/tmpA1-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
tmpA2="$WORKDIR/tmpA2-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "## Created by script: " > $tmpA1
#####################################

## Image addition part 1.1 = Adding all images with hugo figure tags in MGGK HUGO DIR
echo ">> Image addition part 1.1 = Adding all images with hugo figure tags in MGGK HUGO DIR ... " ;     
for x in $(grep -irl "{{< figure" $IMAGES_ROOTDIR ) ; 
do 
    grep -i "{{< figure" $x | sd ' ' '\n' | grep 'src' | sd '"' '' | sd 'src=' '' >> $tmpA1 ;
done

## Image addition part 1.2 = Adding all images with hugo figure tags in ZZ MGGK HUGO DIR
echo ">> Image addition part 1.2 = Adding all images with hugo figure tags in ZZ MGGK HUGO DIR ... " ;     
for x in $(grep -irl "{{< figure" $IMAGES_ROOTDIR_ZZMGGK ) ; 
do 
    grep -i "{{< figure" $x | sd ' ' '\n' | grep 'src' | sd '"' '' | sd 'src=' '' >> $tmpA1 ;
done

## Image addition part 1.3 = Adding all featured images to the list of images in MGGK + ZZMGGK DIR
echo ">> Image addition part 1.3 = Adding all featured images to the list of images in MGGK + ZZMGGK DIR ... " ;
insertURL="https://www.mygingergarlickitchen.com" ;
grep -irh 'featured_image:' $IMAGES_ROOTDIR | sd 'featured_image:' '' | sd ' ' '' | sd '"' '' >> $tmpA1 ;
grep -irh 'recipe_code_image:' $IMAGES_ROOTDIR | sd 'recipe_code_image:' '' | sd ' ' '' | sd '"' '' >> $tmpA1 ;
##
grep -irh 'featured_image:' $IMAGES_ROOTDIR_ZZMGGK | sd 'featured_image:' '' | sd ' ' '' | sd '"' '' >> $tmpA1 ;
grep -irh 'recipe_code_image:' $IMAGES_ROOTDIR_ZZMGGK | sd 'recipe_code_image:' '' | sd ' ' '' | sd '"' '' >> $tmpA1 ;

########################################
## Converting urls to local file paths
echo ">> Converting urls to local file paths ..." ; 
cat $tmpA1 | grep -iv '#' | sd "$insertURL" "" | sed "s+^+$insertURL+g" | sd "$insertURL" "$REPO_MGGK/static" | sort | uniq > $tmpA2
## Call main function
FUNC_create_responsive_images "$RESPONSIVE_IMAGES_ROOTDIR" "$tmpA2" "tmpA" ;
##------------------------------------------------------------------------------
## END: BLOCK 1
##------------------------------------------------------------------------------

##------------------------------------------------------------------------------
## BEGIN: BLOCK 2 = Creating responsive images for recipe steps images
##------------------------------------------------------------------------------
IMAGES_ROOTDIR_STEPS="$REPO_MGGK/static/wp-content/recipe-steps-images/" ;
RESPONSIVE_IMAGES_ROOTDIR_STEPS="$REPO_MGGK/static/wp-content/responsive-steps-images" ;
##
tmpB1="$WORKDIR/tmpB1-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
tmpB2="$WORKDIR/tmpB2-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "## Created by script: " > $tmpB1

#####################################
## Image addition part 2.1 = Adding all recipe steps imagesto the list of images
echo ">> Image addition part 2.1 = Adding all recipe steps imagesto the list of images ... " ;
replaceThis1="/Users/abhishek/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static" ;
replaceThis2="/home/ubuntu/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static" ;
fd --search-path="$IMAGES_ROOTDIR_STEPS" -a -e jpg | sd "$replaceThis1" "" | sd "$replaceThis2" "" | sd '^' 'https://www.mygingergarlickitchen.com' >> $tmpB1

########################################
## Converting urls to local file paths
echo ">> Converting urls to local file paths ..." ; 
cat $tmpB1 | grep -iv '#' | sd "$insertURL" "" | sed "s+^+$insertURL+g" | sd "$insertURL" "$REPO_MGGK/static" | sort | uniq > $tmpB2
## Call main function
FUNC_create_responsive_images "$RESPONSIVE_IMAGES_ROOTDIR_STEPS" "$tmpB2" "tmpB" ;
##------------------------------------------------------------------------------
## END: BLOCK 2
##------------------------------------------------------------------------------

## PRINGING WORD COUNTS FOR ALL FILES IN WORKDIR
echo ">> PRINGING WORD COUNTS FOR ALL FILES IN WORKDIR ..." ;
wc $WORKDIR/* ;
################################################################################
############################### PROGRAM ENDS ###################################
################################################################################
echo "$(date) = END-TIME" >> $time_taken
cat $time_taken
