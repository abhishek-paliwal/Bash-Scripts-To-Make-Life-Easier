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
    ## FILENAME = $THIS_SCRIPT_NAME
    ## USAGE:
    #### > bash $THIS_SCRIPT_NAME
    ################################################################################
    ## THIS SCRIPT SHOWS A LIST OF PERSONAL COMMANDS TO BE USED REGARDING MGGK WEBSITE 
    ## AND ASKS FOR USER INPUT ABOUT WHICH COMMAND THE USER WANTS TO RUN FROM THAT 
    ## LIST. FINALLY, IT RUNS THE CHOSEN COMMAND.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: NOV 05, 2020
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
WORKING_DIR="$HOME_WINDOWS/Desktop/Y" ;
PWD=$(pwd);
echo;
echo "## PRESENT WORKING DIRECTORY = $PWD" ;

##############################################################################
############ EXPANDING ALIASES ON NON-INTERATIVE SHELL SCRIPTS ###############
## For Running system commands (as Aliases from .bash_profile)
shopt -s expand_aliases ## for BASH: This has to be done, else, aliases are not expanded in scripts.
##
## IF THE HOME USER IS UBUNTU, CHANGE SOME DEFAULT VARIABLES (BCOZ WE ARE USING WSL)
if [ "$USER"=="ubuntu" ] ; then 
    source $HOME/.profile
    source $HOME/.bash_aliases ## Then, this also has to be done to use aliases in this script.
else 
    source $HOME/.bash_profile
    source $HOME/.bash_aliases ## Then, this also has to be done to use aliases in this script.
fi 
##############################################################################

##############################################################################
## DECLARING COMMAND LIST ARRAY, ONE COMMAND PER LINE (NO COMMAS)
MY_COMMANDS_ARRAY=(makesite_mggk
frontm
algolia_search_for_this_phrase
pali_spellings_check_in_this_directory
1x1
10-mggk-create-images-index-page-for-current-year
506-mggk-search-word-in-tags-and-categories
599_mggk_REPLACE_BULK_RATINGCOUNT_AND_RATINGVALUE_FROM_GOOGLE_SHEETS_CSV
599-mggk-CREATE-AND-SAVE-SITE-STATISTICS
599-mggk-MAKE-VIDEO-SITEMAP-XML
601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls
702-mggk-CREATE-LD-JSON-FAQ-BLOCKS-FROM-MD-FILES
999-mggk-EXTRACT-VIDEO-SCREENSHOTS-EVERY-N-SECONDS
999-mggk-MOVE-MD-FILES-to-PWD-based-on-URLs-from-CLI-text-file-argument
999-mggk-convert-each-line-in-text-file-to-HTML-hyperlinks
999-mggk-opening-hyperlinks-in-browser-for-checking
999-mggk-2020-MICROSOFT-BING-BATCH-URL-SUBMISSION
my_commands_for_ANU) ;

## PRINTING ALL ELEMENTS OF THE COMMAND ARRAY
echo;
echo "##------------------------------------------------------------------------------"; 
echo "TOTAL NUMBEER OF COMMANDS FOUND: ${#MY_COMMANDS_ARRAY[*]}" ; echo; 
echo ">>>> MY COMMAND LIST >>>> "; echo; 
for index in ${!MY_COMMANDS_ARRAY[*]}
do
    printf "%4d: %s\n" $index ${MY_COMMANDS_ARRAY[$index]}
done
echo "##------------------------------------------------------------------------------"; 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USER INPUT:
echo; 
echo ">>>> SELECT THE NUMBER OF THE COMMAND TO RUN (press ENTER key to exit) =>" ;
read WHICH_COMMAND_TO_RUN
echo;

# Check for validity if no input is given
if [ -z $WHICH_COMMAND_TO_RUN ]
then
  echo "*** INVALID USER INPUT. PROGRAM WILL EXIT NOW. ***" ;
  exit 1 ; 
elif [ -n $WHICH_COMMAND_TO_RUN ]
then
  echo ">>>> Are you sure, you want to run this command: " ;
  echo "${MY_COMMANDS_ARRAY[$WHICH_COMMAND_TO_RUN]}" ; 
  echo; 
  read -p "Press Enter key if OKAY ..." ; 
  # run the chosen command
  echo; echo ">>>> RUNNING THE CHOSEN COMMAND" ; echo ; 
  eval ${MY_COMMANDS_ARRAY[$WHICH_COMMAND_TO_RUN]} ;
fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
