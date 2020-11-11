#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
REQUIREMENTS_FILE="$REPO_SCRIPTS_MGGK/_REQUIREMENT_FILES_MGGK/0000-bash-script-creation-template.txt" ; 
##
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## This script creates a fresh BASH SCRIPT from the template text already
    ## present in REQUIREMENTS file directory.
    ################################################################################
    ## REQUIREMENT:  $REQUIREMENTS_FILE
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: NOV 11, 2020
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##############################################################################
## SETTING VARIABLES
WORKING_DIR="$DIR_Y" ;
echo ;
echo "################################################################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKING_DIR" ;
echo; 
##############################################################################
NEW_SCRIPTNAME="$DIR_Y/template_bashscript_$(date +%Y%m%d-%H%M%S).sh" ; 
##
function CREATESCRIPT_BASH () { 
    echo "REQUIREMENT FILE => $REQUIREMENTS_FILE" ; 
    echo "CREATED SCRIPT => $NEW_SCRIPTNAME"; 
    echo; echo "Enter Script Description (in a single line): " ; 
    read SCRIPT_DESC ; 
    echo; echo ">>>> Inserting text into script ... " ; 
    echo > $NEW_SCRIPTNAME ; 
    echo "$SCRIPT_DESC" | fold -sw 75 | sed "s/^/    ## /g" >> $NEW_SCRIPTNAME ; 
    cat $REQUIREMENTS_FILE >> $NEW_SCRIPTNAME ; 
    $EDITOR $NEW_SCRIPTNAME 
} ; 
## RUNNING THE FUNCTION
CREATESCRIPT_BASH

################################ FINAL SUMMARY ####################################
echo "## SUMMARY PRINTING #########################################################" ;
echo "##---------------------------------------------------------------------------"
echo ">>>> SUCCESS // NEW BASH SCRIPT CREATED AS => $NEW_SCRIPTNAME" ;
