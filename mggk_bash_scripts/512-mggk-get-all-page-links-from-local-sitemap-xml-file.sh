#!/bin/bash
################################################################################
THIS_FILENAME="512-mggk-get-all-page-links-from-local-sitemap-xml-file.sh"
TMP_OUTPUT_FILE="_512_TMP_OUTPUT.TXT"
REQUIRED_FILE="sitemap.xml"
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  #################################################################################
  ## THIS FILENAME = $THIS_FILENAME
  ## USAGE: > sh $THIS_FILENAME
  #################################################################################
  ## THIS SCRIPT OUTPUTS A TEXT FILE in PWD = $TMP_OUTPUT_FILE , WHICH CONTAINS
  ## ALL NON-TAGS AND NON-CATEGORIES LINKS FROM THE SITEMAP.XML FILE DOWNLOADED from
  ## ANY WEBSITE.
  #################################################################################
  ## REQUIREMENT: ###########################
  #### For this script, you need to have a $REQUIRED_FILE file locally stored
  #### in the Present Working Directory.
  #################################################################################
  ###############################################################################
  ## CODED ON: MAY 7, 2019
  ## CODED BY: PALI
  ###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


################################################################################
PWD=$(pwd) ;
echo;
echo "Current working directory = $PWD" ;
echo;

## USER CONFIRMATION
read -p "If this working directory is OK, please press ENTER key to continue ..." ;
echo;

################################################################################
## REAL MAGIC HAPPENS BELOW

## Running command and printing output on CLI
cat $REQUIRED_FILE | grep '<loc>' | grep -iv 'tags' | grep -iv 'categories' | sed 's|<loc>||g' | sed 's|</loc>||g' | sort

## Saving output to text file
echo; echo ">>>> Saving output to output text file = $TMP_OUTPUT_FILE " ;
cat $REQUIRED_FILE | grep '<loc>' | grep -iv 'tags' | grep -iv 'categories' | sed 's|<loc>||g' | sed 's|</loc>||g' | sort > $TMP_OUTPUT_FILE

## OPENING PWD
echo; echo ">>>> Opening PWD = $PWD" ;
open $PWD
