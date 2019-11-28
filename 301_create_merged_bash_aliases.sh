#!/bin/bash
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

#FILE_TRANSFER_DIR="$HOME/OneDrive/Apps2Sync/dotfiles_backups/"
FILE_TRANSFER_DIR="$HOME/Dropbox/_MY_BASH_SCRIPTS/_bash_aliases_compilation_outputs/"
ALIASES_FILE_USER1="bash-aliases-abhishek.txt"
ALIASES_FILE_USER2="bash-aliases-anu.txt"
ALIASES_FILE_MERGED="bash-aliases-MERGED.txt"

## CD to the desired directory
cd $FILE_TRANSFER_DIR;

echo ">>>> PWD = $(pwd)" ;
echo;

## Saving a copy of the current bash_aliases file present for this user
## It will create abhishek-bash-aliases.txt OR anu-bash-aliases depending upon
#### which machine it is run on.
cp $HOME/.bash_aliases $FILE_TRANSFER_DIR/bash-aliases-$USER.txt ;

## FINALLY, some DIFF merging magic
## 1. Display on CLI
diff --line-format %L $ALIASES_FILE_USER1 $ALIASES_FILE_USER2 ;
## 2. Save to file
echo ;
echo ">>>> NOW SAVING MERGED-bash-aliases file ..." ;
echo "## MERGED ALIASES FILE CREATED ON: $(date)" > $ALIASES_FILE_MERGED ## Initializing with first line
echo "####################################################################" >> $ALIASES_FILE_MERGED
diff --line-format %L $ALIASES_FILE_USER1 $ALIASES_FILE_USER2 >> $ALIASES_FILE_MERGED
echo;

###########
echo "Opening DIR = $FILE_TRANSFER_DIR" ;
open $FILE_TRANSFER_DIR ;
