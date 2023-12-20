#!/bin/bash
################################################################################
## THIS PROGRAM DOWNLOADS N RANDOM IMAGES FROM MGGK WEBSITE
## Please note that total images downloaded will be N+N = jpg + webp.
## DATE: 2023-12-20
## BY: PALI
################################################################################

THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

images_wpcontent_url="https://downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs/mggk_summary_cloudflare_ImagesUrlsWPcontentUploads.csv" ; 
images_webp_url="https://downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs/mggk_summary_cloudflare_ImagesUrlsWPcontentUploads_WEBP.txt" ; 

# Prompt the user for input
read -p "How many images to download (Enter a number): " chosen_N

# Check if the input is a number
if [[ "$chosen_N" =~ ^[0-9]+$ ]]; then
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
    echo "You entered a valid numeric value: $chosen_N // ($chosen_N + $chosen_N) jpg + webp images will be downloaded". ;
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
    ## Download
    wget -P $WORKDIR/ "$images_wpcontent_url" ;
    wget -P $WORKDIR/ "$images_webp_url" ;
    ## Shuffle the rows in file and then download the chosen N
    shuf --head-count="$chosen_N" "$WORKDIR/$(basename $images_wpcontent_url)" | xargs wget -P "$WORKDIR"
    shuf --head-count="$chosen_N" "$WORKDIR/$(basename $images_webp_url)" | xargs wget -P "$WORKDIR"
else
    echo "Invalid input. Please enter a numeric value." ;
fi