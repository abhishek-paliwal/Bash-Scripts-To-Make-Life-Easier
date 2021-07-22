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
    ## This script also finds the cloudflare cache status of all valid MGGK URLs.
    ## This script finds the cloudflare cache status of all valid files present in 
    ## MGGK hugo directory.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-07-22
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##------------------------------------------------------------------------------
function FUNC_ONLY_RUN_FOR_THIS_USER () {
    ## Only run this program for this user
    echo "IMPORTANT NOTE: This script only runs on MAC OS." ; 
    if [ "$USER" == "abhishek" ] ; then
        echo "This is MAC OS. So, script will continue ... " ;
    else
        echo "This is not MAC OS. So, script will stop and exit now." ;
        exit 1 ;
    fi
}
#FUNC_ONLY_RUN_FOR_THIS_USER
##------------------------------------------------------------------------------

##
time_taken="$WORKDIR/tmp-time-taken-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "$(date) = START-TIME" > $time_taken

##################################################################################
WORKDIR="$DIR_Y" ;
cd $WORKDIR ; 

## Getting required files from dropbox urls
prefix_url="https://downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs" ;
file1="mggk_summary_cloudflare_FilesUrlsWPcontent.txt"
file2="mggk_summary_cloudflare_AllValidSiteUrls.txt"

ARRAY_FILES_TO_DOWNLOAD=("$prefix_url/$file1"
"$prefix_url/$file2") ;

for i in "${ARRAY_FILES_TO_DOWNLOAD[@]}"; do
    echo "Downloading ... $i" ;
    wget -P "$WORKDIR" $i ;
done

FilesUrlsWPcontent="$WORKDIR/$file1" ;
AllValidUrlsMGGK="$WORKDIR/$file2" ;

##################################################################################
## FUNCTION TO FIND THE ACTUAL CACHE STATUS USING CURL
function FUNC_find_cache_status () {
    PathsFile="$1" ;
    PathsFile_base=$(basename $PathsFile) ;
    cacheSummaryOutput="$WORKDIR/cache_HitOrMiss-$PathsFile_base" ;
    echo "##" > $cacheSummaryOutput ;
    echo ">> Finding cache status for => $PathsFile" ;
    ##
    total=$(cat $PathsFile | wc -l) ;
    count=0
    for myURL in $(cat $PathsFile); do 
        ((count++));
        echo ">> $count of $total" ;
        varCache=$(curl -s -I -L $myURL | grep 'cf-cache') ;
        ## Print and remove some dos-sy unprintable characters
        echo "$varCache ## $myURL" | sed -e "s/\r//g" >> $cacheSummaryOutput ; 
        echo "" >> $cacheSummaryOutput ; 
    done
}
####
FUNC_find_cache_status $AllValidUrlsMGGK
FUNC_find_cache_status $FilesUrlsWPcontent
##################################################################################


################################################################################
############################### PROGRAM ENDS ###################################
################################################################################
echo "$(date) = END-TIME" >> $time_taken
cat $time_taken
