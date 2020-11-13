#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ############################################################################
    ## THIS PROGRAM TAKES TWO DIFFERENT .BASH_ALIASES FILES AND CREATES
    ## A MERGED FILE WITH ALL THE UNIQUE LINES (AKA ALIASES)
    ## STEPS:
    #### 1. ON THE CLIENT MACHINE, MAKES A COPY OF THE BASH ALIASES FILE IN
    ####### ONEDRIVE TMP FOLDER
    #### 2. REPEATS STEP 1 ON ANOTHER CLIENT'S MACHINE
    #### 3. FINDS THE DIFFERENCES BETWEEN THOSE TWO FILES, AND MERGES THEM, AND
    ####### CREATES A NEW MERGED ALIASES FILE. JUST REPLACE THIS FILE TO BOTH THE
    ####### THE BASH ALIASES ON BOTH CLIENT MACHINES.
    ############################################################################
    ## CREATED ON: MARCH 27 2019
    ## BY: PALI
    ############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

####################### ADDING COLOR TO OUTPUT ON CLI ##########################
echo "Currently sourcing the bash color script, which outputs chosen texts in various colors ..." ;
source $REPO_SCRIPTS/2000_vendor_programs/color-logger.sh
#info "This enables use of keywords for coloring, such as: debug, info, error, success, warn, highlight." ;
#debug "Read it's help by running: >> bash $DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/color-logger.sh -h"
##############################################################################

echo;
warn ">> Currently running this script => $THIS_SCRIPT_NAME" ; 
##
FILE_TRANSFER_DIR="$HOME_WINDOWS/Dropbox/_MY_BASH_SCRIPTS/_bash_aliases_compilation_outputs/"
ALIASES_FILE_USER1="bash-aliases-abhishek.txt"
ALIASES_FILE_USER2="bash-aliases-ubuntu.txt"
ALIASES_FILE_MERGED="bash-aliases-MERGED-abhishek-ubuntu.txt"

## CD to the desired directory
cd $FILE_TRANSFER_DIR;

info ">>>> PWD = $(pwd)" ;
echo;

## Saving a copy of the current bash_aliases file present for this user
## It will create abhishek-bash-aliases.txt OR anu-bash-aliases depending upon
#### which machine it is run on.
cp $HOME/.bash_aliases $FILE_TRANSFER_DIR/bash-aliases-$USER.txt ;

## FINALLY, some DIFF merging magic
## 1. Display on CLI
#diff --line-format %L $ALIASES_FILE_USER1 $ALIASES_FILE_USER2 ;
## 2. Save to file
echo ;
echo ">>>> NOW SAVING MERGED-bash-aliases file ..." ;
warn "## MERGED ALIASES FILE CREATED ON: $(date)" > $ALIASES_FILE_MERGED ## Initializing with first line
echo "####################################################################" >> $ALIASES_FILE_MERGED
diff --line-format %L $ALIASES_FILE_USER1 $ALIASES_FILE_USER2 >> $ALIASES_FILE_MERGED
echo;

##################################################################################
echo "##++++++++++++++++++++++++++++++++++++++++++++" ;
info "Listing all FILES in the DIR = $FILE_TRANSFER_DIR" ;
ls -lt $FILE_TRANSFER_DIR/ ;
echo "##++++++++++++++++++++++++++++++++++++++++++++" ;
##################################################################################

function FUNCTION_OPEN_DIR () {
    echo "Opening the DIR = $FILE_TRANSFER_DIR" ;
    if [ "$USER" == "ubuntu" ] ; then
        cd $FILE_TRANSFER_DIR ;
        explorer.exe .
    else
        open $FILE_TRANSFER_DIR ;
    fi
}
## Calling this fuction (Uncomment if needed)
#FUNCTION_OPEN_DIR
##################################################################################
