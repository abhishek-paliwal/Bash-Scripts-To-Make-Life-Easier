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
    #### NOTE: This program uses rclone utility => brew install rclone
    #### NOTE: This program uses awscli utility => brew install awscli
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

    ## Read these files and copy all images to orig dir
    echo; echo ">> Copying all files => (from $ALL_IMAGES_FILE)(to $originalImageDir )" ;
    while read imagepath; do cp "$imagepath" $originalImageDir/ ; done < $ALL_IMAGES_FILE
    
    ## Calculate md5sums after copying images
    FUNC_calc_md5sums $md52

    ## Finding diff and printing filepaths
    echo; echo ">> Doing diff of md5sums ..." ;
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
        echo "Currently reading = $count of $total_lines (= $line)" ;
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
            convert "$line" -resize "$resizeDimen" -quality 85 "$outputImage" ;
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
    echo; echo "Writing md5sums to => $outputFile" ; 
    fd -I --search-path="$originalImageDir" -x md5sum > $WORKDIR/tmp-md5.txt ;
    sort $WORKDIR/tmp-md5.txt > "$outputFile" ;
}

#######
function FUNC_ONLY_RUN_FOR_THIS_USER () {
    DirImages="$1" ;
    ## ## Only run this program for this user
    echo; echo "IMPORTANT NOTE: This script only runs on MAC OS." ; 
    if [ "$USER" == "abhishek" ] ; then
        echo "This is MAC OS. So, script will remove extended image attributes ..." ;
        xattr -rc "$1" ;
    else
        echo "This is not MAC OS. So, script will continue normally." ;
    fi
}

#######
function FUNC_sync_to_dreamobjects_bucket () {
    ## Sync images to CDN on dreamobjects bucket using rclone OR awscli
    CDN_ROOTDIR="cdn.mygingergarlickitchen.com" ;
    CDN_PATH="$REPO_CDN/$CDN_ROOTDIR" ;
    ## IF using native aws cli commands, then uncomment the following:
    #aws --profile=dreamobjects --endpoint-url https://objects-us-east-1.dream.io s3 sync $CDN_PATH s3://$CDN_ROOTDIR ;
    ##
    rclone sync --fast-list --checksum $CDN_PATH dreamobjects:$CDN_ROOTDIR ;
    rclone check $CDN_PATH dreamobjects:$CDN_ROOTDIR ;
}
##################################################################################

##------------------------------------------------------------------------------
## BEGIN: BLOCK 1 = Creating responsive images for all images + steps images present in wp content dir
##------------------------------------------------------------------------------
RESPONSIVE_IMAGES_ROOTDIR="$REPO_CDN/cdn.mygingergarlickitchen.com/images" ;
##
tmpA1="$WORKDIR/tmpA1-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
tmpA2="$WORKDIR/tmpA2-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;

echo; echo ">>  Image addition part 1 = Adding all images in REPO_MGGK + REPO_ZZMGGK ..."
echo "## Created by script: " > $tmpA1
fd -I -e jpg -e png --search-path="$REPO_MGGK/static/"   >> $tmpA1
fd -I -e jpg -e png --search-path="$REPO_ZZMGGK/static/" >> $tmpA1

echo; echo ">> Sorting image paths ..." ; 
cat $tmpA1 | grep -iv '#' | sort | uniq > $tmpA2

## Call main function + sync function (uncomment the sync function if needed)
FUNC_create_responsive_images "$RESPONSIVE_IMAGES_ROOTDIR" "$tmpA2" "tmpA" ;
#FUNC_sync_to_dreamobjects_bucket ;

##------------------------------------------------------------------------------
## END: BLOCK 1
##------------------------------------------------------------------------------

## PRINTING WORD COUNTS FOR ALL FILES IN WORKDIR
echo; echo ">> PRINTING WORD COUNTS FOR ALL FILES IN WORKDIR ..." ;
wc $WORKDIR/* ;

##------------------------------------------------------------------------------
## NOW FINALLY CREATE WEBP VERSIONS OF ALL IMAGES
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo ">> CREATING WEBP IMAGE VERSIONS ..." ; 
bash $REPO_SCRIPTS_MGGK/999-mggk-CREATE-RESPONSIVE-IMAGES-FOR-MGGK-SITE-WEBP.sh ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
##------------------------------------------------------------------------------

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## PRINTING THE FULL UPDATED LIST OF FILES IN MGGK CDN DIRECTORY TO SEE FOR ANY CHANGES
echo; echo ">> PRINTING THE FULL UPDATED LIST OF FILES IN MGGK CDN DIRECTORY TO SEE IF ANY CHANGES ..." ;
##
DIR_CDN="$REPO_CDN/cdn.mygingergarlickitchen.com" ; 
##
DIR_CDN_IMAGES="$REPO_CDN/cdn.mygingergarlickitchen.com/images" ; 
echo "## File last updated: $(date)" > $DIR_CDN/summary_file_list_latest.txt ;
tree -h --charset=ascii "$DIR_CDN_IMAGES"  >> $DIR_CDN/summary_file_list_latest.txt ; 
## for webp
DIR_CDN_WEBP="$REPO_CDN/cdn.mygingergarlickitchen.com/images_webp" ; 
echo "## File last updated: $(date)" > $DIR_CDN/summary_file_list_latest_webp.txt ;
tree -h --charset=ascii "$DIR_CDN_WEBP"  >> $DIR_CDN/summary_file_list_latest_webp.txt ; 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################
############################### PROGRAM ENDS ###################################
################################################################################
echo "$(date) = END-TIME" >> $time_taken
cat $time_taken
