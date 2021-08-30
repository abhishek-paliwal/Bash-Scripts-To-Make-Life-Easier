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
    ## This script saves copies of chosen webpages read from given sitemap xml files 
    ## as html pages using curl and wget utilities. 
    ################################################################################
    ## REQUIREMENT:  sitemap xml files in present working directory
    ### The xml files can have any names, however, the extension must be xml.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-08-30
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##------------------------------------------------------------------------------
## ASSIGN COMPUTER HOSTNAME SPECIFIC VARIABLES
function FUNC_assign_variables_for_this_hostname () {
    HOSTNAME=$(uname -n) ;
    #### Possible hostnames are: 
    #### AP-MBP.local // LAPTOP-F0AJ6LBG // ubuntu1804-digitalocean-bangalore-droplet
    ## 
    if [ "$HOSTNAME" == "ubuntu1804-digitalocean-bangalore-droplet" ] ; then
        WWWDIR="/var/www/vps.abhishekpaliwal.com/html/scripts-html-outputs" ;
        BASEDIR="$WWWDIR" ;
    else
        BASEDIR="$DIR_Y" ;
    fi
    ##
    echo ">> HOSTNAME IS = $HOSTNAME";
    echo ">> CHOSEN BASEDIR => $BASEDIR" ;
}
FUNC_assign_variables_for_this_hostname
##------------------------------------------------------------------------------

##############################################################################
## SETTING VARIABLES
WORKDIR="$BASEDIR/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## creates dir without any error messages if already present
##
echo ;
echo "################################################################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
##############################################################################

##############################################################################
function FUNC_step1_download_sitemap_xml_files_locally () {
    sitemap_array=$1;
    ####
    for sitemapFile in "${sitemap_array[@]}"; do
        sitemapFile_basename=$(basename $sitemapFile) ;
        ## extracting domain name (as 3rd field) for this sitemap file (Eg output => as www.mygingergarlickitchen.com)
        dirName=$(echo "$sitemapFile" | cut -d'/' -f3) ;
        outDir="$WORKDIR/$dirName" ; 
        mkdir -p "$outDir"  ;
        outFile="$outDir/$sitemapFile_basename" ;
        ##
        echo "Downloading Sitemap => $sitemapFile" ;
        wget -O "$outFile" "$sitemapFile" ;
    done
}
################################
function func_step2_extract_links_from_sitemap_xml_files () {
  sitemap_file="$1" ; 
  sitemap_file_dirname="$(dirname $sitemap_file)" ;  ## parent directory
  sitemap_file_basename="$(basename $sitemap_file)" ;
  sitemap_file_basename_no_extn="$(echo $sitemap_file_basename | sd '.xml' '' )" ;
  TMP_OUTPUT_FILE="$sitemap_file_dirname/_512_OUTPUT_LINKS_WITHOUT_CATEGORIES_AND_TAGS-$sitemap_file_basename_no_extn.txt"
  TMP_OUTPUT_FILE_ALL_LINKS="$sitemap_file_dirname/_512_OUTPUT_ALL_LINKS-$sitemap_file_basename_no_extn.txt"
  ####
  echo ">> READING CURRENT SITEMAP => $sitemap_file_basename" ;
  ## Running command and printing output on CLI
  ## Saving output to text files 
  cat $sitemap_file | grep '<loc>' | sed 's|<loc>||g' | sed 's|</loc>||g' | sd ' ' '' | sd '\t' '' | sort > $TMP_OUTPUT_FILE_ALL_LINKS ;
  cat $TMP_OUTPUT_FILE_ALL_LINKS | grep -iv 'tags' | grep -iv 'categories' | sort > $TMP_OUTPUT_FILE ;
  ## printing output on CLI
  #sort $TMP_OUTPUT_FILE_ALL_LINKS | nl
  ## SUMMARY
  echo; 
  echo "##++++++++++++++ SUMMARY [ sitemap = $sitemap_file_basename ] +++++++++++++" ;
  echo ">>>> OUTPUT SAVED TO (ALL LINKS)                    => $TMP_OUTPUT_FILE_ALL_LINKS " ;
  echo ">>>> OUTPUT SAVED TO (NO-TAGS AND CATEGORIES LINKS) => $TMP_OUTPUT_FILE " ;
  echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
}
################################
function FUNC_step3_save_webpages_as_html_files () {
    inFile="$1" ;
    current_dirname="$(dirname $inFile)" ;
    outDir="$current_dirname/_downloaded_html_files/" ; 
    mkdir -p "$outDir" ; 
    echo ">> current_dirname_basename = $current_dirname_basename // $current_dirname" ;
    ##
    for myurl in $(cat $inFile); do 
        echo ">> EXTRACTING THIS URL => $myurl" ;
        ##
        filename=$(echo $myurl | sd '/' '-' | sd ':' '' | sd '\.' '-' ) ; 
        datevar="$(date +%Y%m%d)" ;
        outFile="$outDir/$filename-$datevar.html" ;
        curl -s "$myurl" > "$outFile" ; 
        echo "  >> HTML FILE SAVED => $outFile"  ;
    done
}
##############################################################################
##############################################################################
sitemap_array=(https://www.mygingergarlickitchen.com/sitemap.xml
https://www.cookwithmanali.com/post-sitemap.xml
https://www.cookwithmanali.com/page-sitemap.xml) ;
##############################################################################

## Calling all functions sequentially
## step1 = download given sitemaps listed in array
FUNC_step1_download_sitemap_xml_files_locally "$sitemap_array" ;
## step2 = extracts all links from sitemaps to simple links text files
for sitemapFile in $(fd -e xml --search-path="$WORKDIR") ; do 
  func_step2_extract_links_from_sitemap_xml_files "$sitemapFile" ;
done 
## step3 = read lines from each of the links text files and download those urls 
for all_links_file in $(fd '_512_OUTPUT_ALL_LINKS' --search-path="$WORKDIR") ; do 
    FUNC_step3_save_webpages_as_html_files "$all_links_file" ;
done 
##############################################################################
