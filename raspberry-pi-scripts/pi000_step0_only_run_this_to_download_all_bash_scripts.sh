#!/bin/bash
##########################################################################################
## Only run this script on Raspberry Pi4, and it will take care of everything in sequence.
## This script will download the freshest copies of the bash scripts from GitHub repo,
## necessary to make the video slideshow from photos.
##########################################################################################
## Created on: Wednesday January 15, 2020
## Coded by: Pali
#########################################################################################

################################################################################
## ASSIGNING THE MAIN PWD DEPENDING UPON WHETHER THIS PROGRAM IS RUN ON VPS SERVER
## OR ELSEWHERE LOCALLY
################################################################################
if [ $USER = "pi" ]; then
  MY_PWD="/home/_AUDIOJUNGLE_MUSIC"
  echo "USER = $USER // USER is pi. Hence, MY_PWD will be: $MY_PWD " ;
else
  MY_PWD="$HOME/Desktop/Y"
  echo "USER = $USER // USER is not ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
fi

cd $MY_PWD ;
################################################################################

echo ">>>> DOWNLOADING the 3 BASH SCRIPTS ..." ; echo;

curl -O https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/ffmpeg-commands/113_ffmpeg_images_to_video_slideshow_maker.sh

curl -O https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/ffmpeg-commands/201_sorting_mp3_files_by_duration.sh

curl -O https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/mggk_bash_scripts/9999_MGGK_TEMPLATE_SCRIPTS/9999_mggk_TEMPLATE_SCRIPT_FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS.sh

## CREATING LOGFILE...
echo "## THIS SCRIPT => pi000_step0_only_run_this_to_download_all_bash_scripts.sh" > $MY_PWD/_TMP_LOGFILE_PI000_SCRIPT.TXT
echo "## Last ran at: $(date)" >> $MY_PWD/_TMP_LOGFILE_PI000_SCRIPT.TXT
