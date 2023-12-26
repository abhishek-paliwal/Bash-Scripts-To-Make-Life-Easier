#!/bin/bash
################################################################################
## THIS PROGRAM COPIES N RANDOM MARKDOWN FILES FROM MGGK REPOSITORY
## DATE: 2023-12-26
## BY: PALI
################################################################################

THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

 # Prompt the user for input
read -p "How many MD FILES to get (Enter a number): " chosen_N

# Check if the input is a number
if [[ "$chosen_N" =~ ^[0-9]+$ ]]; then
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
    echo "You entered a valid numeric value // $chosen_N recipe md files will be copied ... ". ;
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
    ## Shuffle the rows and then copy the chosen N
    for myfile in $( fd -HItf -e md --search-path="$REPO_MGGK" -x grep -irl 'prepTime' {} | sort | shuf --head-count="${chosen_N}" ); do 
        cp "$myfile" "$WORKDIR"/ ; 
        echo ">> FILE COPIED => $myfile" ; 
    done  
else
    echo "Invalid input. Please enter a numeric value." ;
fi



