#!/bin/bash
################################################################################
THIS_FILENAME="512-mggk-get-all-page-links-from-local-sitemap-xml-file.sh"
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
  ## THIS SCRIPT READS ALL SITEMAP XML FILES PRESENT IN PWD AND CREATES TEXT FILES 
  ## WHICH CONTAINING ALL LINKS (WITH AND WITHOUT TAGS AND NON-CATEGORIES LINKS) 
  #################################################################################
  ## REQUIREMENT: ###########################
  #### For this script, you need to have sitemap xml files locally stored
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

################################################################################
## FUNCTIONS
################################################################################
function func_display_error_for_info () {
  echo;
  echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
  echo ">> INFO IN CASE OF ERROR: This script needs sitemap xml files to be present in pwd. Their names can be anything, however, their extensions must be .xml ..." ;
  echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
}
#######
function func_extract_links_from_sitemap_xml_files () {
  sitemap_file="$1" ; 
  sitemap_file_basename="$(basename $sitemap_file)" ;
  sitemap_file_basename_no_extn="$(echo $sitemap_file_basename | sd '.xml' '' )" ;
  TMP_OUTPUT_FILE="_512_OUTPUT_LINKS_WITHOUT_CATEGORIES_AND_TAGS-$sitemap_file_basename_no_extn.txt"
  TMP_OUTPUT_FILE_ALL_LINKS="_512_OUTPUT_ALL_LINKS-$sitemap_file_basename_no_extn.txt"
  ####
  echo ">> READING CURRENT SITEMAP => $sitemap_file_basename" ;
  ## Running command and printing output on CLI
  ## Saving output to text files 
  cat $sitemap_file | grep '<loc>' | sed 's|<loc>||g' | sed 's|</loc>||g' | sd ' ' '' | sort > $TMP_OUTPUT_FILE_ALL_LINKS ;
  cat $TMP_OUTPUT_FILE_ALL_LINKS | grep -iv 'tags' | grep -iv 'categories' | sort > $TMP_OUTPUT_FILE ;
  ## printing output on CLI
  sort $TMP_OUTPUT_FILE_ALL_LINKS | nl
  ## SUMMARY
  echo; 
  echo "##++++++++++++++ SUMMARY [ sitemap = $sitemap_file_basename ] +++++++++++++" ;
  echo ">>>> OUTPUT SAVED TO (ALL LINKS)                    => $TMP_OUTPUT_FILE_ALL_LINKS " ;
  echo ">>>> OUTPUT SAVED TO (NO-TAGS AND CATEGORIES LINKS) => $TMP_OUTPUT_FILE " ;
  echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
}
################################################################################
## Calling functions
for sitemapFile in $(fd -e xml) ; do 
  func_extract_links_from_sitemap_xml_files "$sitemapFile" ;
done 
###
func_display_error_for_info
###
## Displaying line counts
fd -t f '_512_OUTPUT' -x wc -l {} ;
################################################################################
## OPENING PWD
echo; echo ">>>> Opening PWD = $PWD" ;
open $PWD
