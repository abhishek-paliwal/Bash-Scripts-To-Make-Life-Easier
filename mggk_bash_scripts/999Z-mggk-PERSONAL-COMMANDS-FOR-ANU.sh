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
    #### > bash $THIS_SCRIPT_NAME \$1
    #### WHERE, \$1 CAN BE ONE OF (anu, pali, leela)
    ################################################################################
    ## THIS SCRIPT SHOWS A LIST OF PERSONAL COMMANDS TO BE USED BY DIFFERENT USERS 
    ## AND ASKS FOR USER INPUT ABOUT WHICH COMMAND THE USER WANTS TO RUN FROM THAT 
    ## LIST. FINALLY, IT RUNS THE CHOSEN COMMAND.
    ################################################################################
    ## REQUIREMENT: THIS SCRIPT NEEDS A CLI ARGUMENT TO RUN.
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

##############################################################################
############ BEGIN: EXPANDING ALIASES ON NON-INTERATIVE SHELL SCRIPTS ########
shopt -s expand_aliases ## for BASH: This has to be done, else, aliases are not expanded in scripts.
##
## IF THE HOME USER IS UBUNTU, CHANGE SOME DEFAULT VARIABLES (BCOZ WE ARE USING WSL)
echo; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo "IMPORTANT NOTE: This OS is $(uname) ... aliases and profile will be sourced now." ; 
echo "IMPORTANT NOTE: YOU CAN DISREGARD THIS ERROR BELOW: alias: bash: not found" ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo; 
if [ "$(uname)" == "Linux" ] ; then 
    source $HOME/.profile ;
    source $HOME/.bash_aliases ; ## Then, this also has to be done to use aliases in this script.
else
    source $HOME/.bash_profile ;
    source $HOME/.bash_aliases ; ## Then, this also has to be done to use aliases in this script.
fi 
############ END: EXPANDING ALIASES ON NON-INTERATIVE SHELL SCRIPTS ##########
##############################################################################

WORKING_DIR="$DIR_Y" ;
PWD=$WORKING_DIR ;
echo ;
echo "################################################################################" ; 
echo "## PRESENT WORKING DIRECTORY = $PWD" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## GET THE USER FROM THE CLI ARGUMENT:
WHICH_USER=$1;
if [ -z "$WHICH_USER" ] ; then 
  echo; 
  echo ">>>> FAILURE: No CLI argument given. Please provide one." ; 
  exit 1 ; 
echo;  
fi 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##############################################################################
## DECLARING COMMAND LIST ARRAYS FOR EACH USER, ONE COMMAND PER LINE (NO COMMAS)
ANU_COMMANDS_ARRAY=(makesite_mggk
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
999-mggk-2020-MICROSOFT-BING-BATCH-URL-SUBMISSION) ;

##
PALI_COMMANDS_ARRAY=(palinotes_makesite_hugo
frontp
1_all_backup_indexes_maker
pali_0000_create_html_index_with_usage_help_for_all_bash_scripts
pali_copy_aspell_personal_words_for_this_user
pali_countfiles
pali_filepath_printing
pali_imagesinfo
pali_move_videos_and_photos_to_separate_folders
pali_move_videos_and_photos_to_separate_folders_win
pali_pathlength_printing
pali_print_video_and_image_dimensions_using_ffprobe
pali_spellings_add_in_personal_words
pali_spellings_check_in_this_directory
pali_takeout_google_unzip_all_sequential_zip_files) ;

##
LEELA_COMMANDS_ARRAY=(leelasrecipes_makesite_hugo
frontl_leelasrecipes
leelasrecipes-MOVE-ALL-PWD-IMAGES-TO-PROPER-WEBSITE-FOLDER
leelasrecipes_check_spellings
leelasrecipes_rename_images-with-custom-prefix-and-counters
leelasrecipes-CREATE-AND-SAVE-SITE-STATISTICS
leelasrecipes-MAKE-VIDEO-SITEMAP-XML) ;

## Assign the corresponding user array to the new array variable
if [ "$WHICH_USER" == "anu" ] ; then MY_COMMANDS_ARRAY=( "${ANU_COMMANDS_ARRAY[@]}" ) ; fi
if [ "$WHICH_USER" == "pali" ] ; then MY_COMMANDS_ARRAY=( "${PALI_COMMANDS_ARRAY[@]}" ) ; fi
if [ "$WHICH_USER" == "leela" ] ; then MY_COMMANDS_ARRAY=( "${LEELA_COMMANDS_ARRAY[@]}" ) ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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
