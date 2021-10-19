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
    #### IMPORTANT: THIS SCRIPT SHOULD ONLY BE RUN ON DIGITAL OCEAN SERVER.
    ## This script reads all jpg images (only jpg) from given directories and creates 
    ## responsive images to be read by the srcset html image tags by the browser.
    ## Example image resolutions include: 350px, 425px, 550px, 675px, 800px, etc.
    #### NOTE: Needs the rclone cli program. (https://rclone.org/)
    #### Install by running > brew install rclone
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-10-18
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##------------------------------------------------------------------------------
## ASSIGN COMPUTER HOSTNAME SPECIFIC VARIABLES
function FUNC_check_hostname_and_assign_proper_variables () {
    HOSTNAME=$(uname -n) ;
    ## Possible hostnames are: 
    #### AP-MBP.local // LAPTOP-F0AJ6LBG // ubuntu1804-digitalocean-bangalore-droplet
    ## 
    if [ "$HOSTNAME" == "ubuntu1804-digitalocean-bangalore-droplet" ] ; then
        echo ">> NOTE: This is digital ocean server, hence the script will continue ..." ;
        WWW_RESPONSIVE_ROOTDIR="/home/WWW_RESPONSIVE_IMAGES" ;
    else
        echo ">> NOTE: This is NOT digital ocean server, hence the script will EXIT." ;
        exit 1 ;
        WWW_RESPONSIVE_ROOTDIR="$DIR_Y" ;
    fi
    ##
    echo ">> HOSTNAME IS = $HOSTNAME";
    echo ">> CHOSEN WWW_RESPONSIVE_ROOTDIR => $WWW_RESPONSIVE_ROOTDIR" ;
}
FUNC_check_hostname_and_assign_proper_variables
##------------------------------------------------------------------------------

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

    ## Calculate md5sums of the existing images
    FUNC_calc_md5sums $md51

    ## Read these files and copy all images to orig dir
    echo ">> Copying all files => (from $ALL_IMAGES_FILE)(to $originalImageDir )" ;
    while read imageline; do cp $imageline $originalImageDir/ ; done < $ALL_IMAGES_FILE

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
}

#######
function FUNC_calc_md5sums() {
    ## Calculate md5sums of the existing files
    outputFile="$1" ;
    echo "Writing md5sums to => $outputFile" ; 
    fd --search-path="$originalImageDir" -x md5sum > $WORKDIR/tmp-md5.txt ;
    sort $WORKDIR/tmp-md5.txt > "$outputFile" ;
}

##################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function MAIN_FUNC_GET_IMAGES_AND_CREATE_RESPONSIVE_VERSIONS () {
    # USAGE: THIS_FUNCTION_NAME <copy images from this dir> <copy images to this dir>
    ## Creating responsive images for all images
    CDN_ROOTDIR="$1" ;
    REPO_IMAGEDIR="$2" ; ## copy all images from this dir
    RESPONSIVE_OUTPUT_DIR="$WWW_RESPONSIVE_ROOTDIR/$CDN_ROOTDIR/images" ; ## copy images to this dir and create responsive copies
    mkdir -p "$RESPONSIVE_OUTPUT_DIR" ; ## create dir if does not exist

    ## Image addition = Adding all images present in REPO_IMAGEDIR
    tmpA="$WORKDIR/tmpA-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
    echo ">> Image addition = Adding all images present in REPO_IMAGEDIR ... " ;     
    fd -I -e jpg --search-path="$REPO_IMAGEDIR" | sort | uniq > $tmpA ;

    ## Call main image creation function
    FUNC_create_responsive_images "$RESPONSIVE_OUTPUT_DIR" "$tmpA" "tmpA" ;

    ## Syncing to cdn bucket and checking its integrity
    rclone sync $WWW_RESPONSIVE_ROOTDIR/$CDN_ROOTDIR dreamobjects:$CDN_ROOTDIR ;
    rclone check $WWW_RESPONSIVE_ROOTDIR/$CDN_ROOTDIR dreamobjects:$CDN_ROOTDIR ;
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## RUN THE FINAL FUNCTION FOR AS MANY CDNs AS REQUIRED
MAIN_FUNC_GET_IMAGES_AND_CREATE_RESPONSIVE_VERSIONS "cdn.leelasrecipes.com" "$REPO_LEELA/static/" ;
MAIN_FUNC_GET_IMAGES_AND_CREATE_RESPONSIVE_VERSIONS "cdn.mantracoaching.in" "$REPO_MANTRA/static/" ;

################################################################################
############################### PROGRAM ENDS ###################################
################################################################################
echo "$(date) = END-TIME" >> $time_taken
cat $time_taken
