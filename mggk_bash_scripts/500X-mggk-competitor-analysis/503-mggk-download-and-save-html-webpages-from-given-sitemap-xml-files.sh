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
    ## This script saves copy of chosen webpages read from given sitemap xml files 
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
## MAIN FUNCTION DEFINITION
function FUNC_save_webpages_as_html () {
    outDir="$WORKDIR" ; 
    mkdir -p "$outDir" ; 
    ##
    echo "Downloading => $REQUIREMENTS_FILE_DOWNLOAD_URL" ;
    wget -O "$outDir/$REQUIREMENTS_FILE_BASENAME" "$REQUIREMENTS_FILE_DOWNLOAD_URL" ;
    ##
    inFile="$outDir/$REQUIREMENTS_FILE_BASENAME" ;
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
function FUNC_download_sitemap_xml_files_locally () {
    sitemap_array=(https://www.mygingergarlickitchen.com/sitemap.xml) ;

}
##############################################################################



## Call functions
FUNC_save_webpages_as_html



