#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## THIS SCRIPT PRINTS trash-cli COMMANDS
## CREATED: 2023-03-25
## CREATED BY: PALI
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

their_url="https://github.com/andreafrancia/trash-cli" ; 

echo "################################################################################" ;
echo ">> Command help text below ... 
####
trash-cli => provides these commands:
####
trash-put           trash files and directories.
trash-empty         empty the trashcan(s).
trash-list          list trashed files.
trash-restore       restore a trashed file.
trash-rm            remove individual files from the trashcan.
####
## Example commands: 
    trash-put YOUR_FILE_NAME ## trash files or directory
    trash-list ## list files already in trash
    trash-restore ## restore files
    trash-empty ## empty full trash
    trash-empty <days> ## trash-empty 2
####
>> trash-cli project url => $their_url
" ; 
echo "################################################################################" ;

