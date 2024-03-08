#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

#########################################################################
## THIS PROGRAM SPLITS THE MGGK DATA CSV FILE INTO PIECES CORRESPONDING TO ONE FILE PER CSV ROW.
## THIS MEANS THAT YOU GET ONE FILE PER RECIPE.
## DATE: 2024-03-08
## BY: PALI
#########################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_SOURCE_SCRIPTS () {
    source "$REPO_SCRIPTS_MINI/00200a_source_script_to_print_fancy_divider.sh" ;
    # This enables => 'palidivider' command, which prints a fancy divider on cli 
    palidivider "Running $FUNCNAME" ;
}
FUNC_SOURCE_SCRIPTS ; 
palidivider ; 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 


tmpfile99="$WORKDIR/_tmpfile99.txt" ; 
tmpdir99="$WORKDIR/_tmpdir99_with_split_files" ;  
mkdir -p "$tmpdir99" ; 

cd $tmpdir99 ; 

# use miller to display csv to xtab, then save it
palidivider ">> Saving csv to xtab" ; 
mlr --icsv --oxtab cat "$CSV_MGGK_DATA" > $tmpfile99 ;

# finally split the saved file into pieces whenever 'toc  ' is found. 
palidivider ">> Splitting into pieces using csplit" ; 
csplit $tmpfile99 '/toc  /' '{*}' -f "splitRecipeFile_" -n 4 --quiet ;

## rename to txt
palidivider ">> Renaming split files to txt" ; 
for x in $(fd -u -tf --search-path="$tmpdir99") ; do mv "$x" "$x.txt" ; done 

