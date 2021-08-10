#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
REQUIREMENTS_FILE="$REPO_SCRIPTS_MGGK/_REQUIREMENT_FILES_MGGK/500X-mggk-competitors-urls-of-interest.txt" ;

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
    ## This script saves copy of chosen competitors webpages as html thru curl command. 
    ## 
    ## 
    ################################################################################
    ## REQUIREMENT:  $REQUIREMENTS_FILE
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-08-10
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo ;
echo "################################################################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
##############################################################################

##############################################################################
## MAIN FUNCTION DEFINITION
function FUNC_save_webpages () {
    inFile="$REQUIREMENTS_FILE" ;
    outFile="$REQUIREMENTS_FILE" ;
    outDir="$REQUIREMENTS_FILE" ;
    for x in $(cat $inFile); do 
    mydir="$WORKDIR/_OUTPUTS_500X_HTML" ; 
    mkdir -p "$mydir" ; 
    file=$(echo $x | sd '/' '-' | sd ':' '' | sd '\.' '-' ) ; 
    curl $x > "$mydir/$file-$(date +%Y%m%d).html" ; 
    done
}
##############################################################################
