#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
REQUIREMENTS_FILE="$REPO_MGGK/_mggk_summary_files/summary_mggk_current_mdfilepaths_with_urls.txt" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## USAGE:
    #### > bash $THIS_SCRIPT_NAME \$1
    #### WHERE, \$1 IS ...
    ################################################################################
    ## THIS SCRIPT FINDS ALL IMAGE URLS PRESENT ON CORRESPONDING MGGK WEBPAGE 
    ## CREATED BY READING EVERY VALID MGGK MDFILE IN MGGK HUGO CONTENT DIRECTORY.
    ## THIS SCRIPT FINDS jpg, jpeg, png, gif
    ## A TEXT FILE IS CREATED IN WORKDIR AS A RESULT OF THIS SCRIPT RUN.
    ################################################################################
    ## REQUIREMENT:  $REQUIREMENTS_FILE
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-08-02
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##
time_taken="$DIR_Y/tmp-time-taken-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "$(date) = START-TIME" > $time_taken

##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y" ;
file_tmp="$WORKDIR/_tmp0.txt" ;
file_output="$WORKDIR/_FINAL_OUTPUT-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ; 

echo "####" > $file_output ;
##################################################################################
for x in $(cat $REQUIREMENTS_FILE | grep -v '#' ) ; do
    url_mggk=$(echo "$x" | cut -d'=' -f2) ; 
    echo ">> CURRENT URL = $url_mggk" ;
    curl -s "https://www.mygingergarlickitchen.com/$url_mggk" | sd '.jpg' '.jpg\n' | sd 'http' '\nhttp' | ag -o 'http.*.jpg$' >> $file_output
    curl -s "https://www.mygingergarlickitchen.com/$url_mggk" | sd '.png' '.png\n' | sd 'http' '\nhttp' | ag -o 'http.*.png$' >> $file_output
    curl -s "https://www.mygingergarlickitchen.com/$url_mggk" | sd '.gif' '.gif\n' | sd 'http' '\nhttp' | ag -o 'http.*.gif$' >> $file_output
    curl -s "https://www.mygingergarlickitchen.com/$url_mggk" | sd '.jpeg' '.jpeg\n' | sd 'http' '\nhttp' | ag -o 'http.*.jpeg$' >> $file_output
done
##################################################################################

################################################################################
############################### PROGRAM ENDS ###################################
################################################################################
echo "$(date) = END-TIME" >> $time_taken
cat $time_taken
