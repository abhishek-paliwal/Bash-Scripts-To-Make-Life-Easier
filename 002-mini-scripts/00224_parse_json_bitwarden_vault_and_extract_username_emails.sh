#!/bin/bash
## THIS PROGRAMS PARSES BITWARDEN VAULT JSON FILE AND EXTRACT USERNAME EMAILS

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_SOURCE_SCRIPTS () {
    ####
    source "$REPO_SCRIPTS_MINI/00200a_source_script_to_print_fancy_divider.sh" ;
    # This enables => 'palidivider' command, which prints a fancy divider on cli 
    # Eg. palidivider "THIS IS A TEST STRING." "$palihline | $palialine | $palibline | $palimline | $palipline | $palixline"
    ####
    source "$REPO_SCRIPTS_MINI/00200b_source_script_to_delete_chosen_files_and_dirs.sh" ; 
    # This enables => 'palidelete, palitrash-put, palitrash-empty, palitrash-list' commands, which move files into a _trashed_directory instead of deleting completely 
    ####
    ####################### ADDING COLOR TO OUTPUT ON CLI ##########################
    source $REPO_SCRIPTS/2000_vendor_programs/color-logger.sh
    # echo "Currently sourcing the bash color script, which outputs chosen texts in various colors ..." ;
    # info "This enables use of keywords for coloring, such as: debug, info, error, success, warn, highlight." ;
    # debug "Read it's help by running: >> bash $DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/color-logger.sh -h"
    ##############################################################################
}
FUNC_SOURCE_SCRIPTS ; 
palidivider ; 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##------------------------------------------------------------------------------
WORKDIR="$DIR_Y" ; 
tmpfile1="$WORKDIR/_tmp01_bitwarden.txt" ; 
tmpfile2="$WORKDIR/_tmp02_bitwarden.txt" ; 
tmpfile3="$WORKDIR/_tmp03_bitwarden.txt" ; 
email_list_from_dotfiles_repo="$REPO_DOTFILES/_00_common_files/email_id_list.txt" ;  

# create tmp output file
palidivider "IMPORTANT NOTE: MAKE SURE THAT bitwarden_export*.json FILE EXISTS IN $WORKDIR" ;
jq '.items[].login.username' $WORKDIR/bitwarden_export*.json | ag 'loveuvw.xyz|stockfotoage.com|mggkanu.com' | sd '"' '' |sort > $tmpfile1
##
echo ">> Concatenating tmpfile1 with $email_list_from_dotfiles_repo" ; 
cat $tmpfile1 $email_list_from_dotfiles_repo | grep -iv '##' > $tmpfile2
sort $tmpfile2 > $tmpfile3
# show output
#cat $tmpfile

####
# show output with domain names first
palidivider "OUTPUT LISTING DOMAIN NAMES FIRST (COUNT // EMAIL_ID)" "$palixline" ;
# show when was this email list updated
show_last_updated=$(grep -i 'updated' $email_list_from_dotfiles_repo) ; 
success ">> Please note that the email list (=> $email_list_from_dotfiles_repo) was last updated on: $show_last_updated " ; 
##
echo ">> IF COUNT = 0, THEN EMAIL ID HAS NOT BEEN USED AT ALL." ; echo; 
cat $tmpfile3 | sort | uniq -c | sort -n | awk '{print ($1-1) " // " $2}' ; 
##------------------------------------------------------------------------------
