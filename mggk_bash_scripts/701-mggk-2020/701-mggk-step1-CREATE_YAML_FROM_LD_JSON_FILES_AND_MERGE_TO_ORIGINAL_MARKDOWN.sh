#!/bin/bash
##------------------------------------------------------------------------------
## Assigning working directory and going to it
WORKDIR="$HOME_WINDOWS/Desktop/X" ;
cd $WORKDIR ;
##
VALID_NOTES_DIR="$WORKDIR/valid_notes"
YAMLDIR='/home/ubuntu/GitHub/ZZ-HUGO-TEST/content/597x-tocheck-$(date +%Y-%m-%d)' ;
MY_SCRIPT_PYTHON3="$DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/701-mggk-2020/701-mggk-step2-CREATE_YAML_FROM_EXTRACTED_LD_JSON_FILES.py" ;
##------------------------------------------------------------------------------

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
THIS_SCRIPT_NAME="$basename $0" ;
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ##################################################################################
    ## THIS BASH SCRIPTS READS MANY LD-JSON FILES LOCATED IN extracted-json FOLDER IN WORKDIR = $WORKDIR
    ## AND THEN CREATES YAML FILES FROM IT BY CALLING THIS PYTHON SCRIPT
    ## => $(basename $MY_SCRIPT_PYTHON3) .
    ########################################
    ## IT THEN MERGES THOSE YAML FILES WITH THE EXTRACTED RECIPE-NOTES FILES, PRESENT IN $VALID_NOTES_DIR AND 
    ## ORIGINAL MARKDOWN FILES STORED IN $WORKDIR, WHICH ARE ALL BASED UPON THE SAME URL.
    ## FINALLY, IT MOVES THOSE MERGED MARKDOWN FILES IN ZZ_HUGO DIRECTORY FOR CHECKING.
    ##################################################################################
    ## IMPORTANT NOTE: See the 701-MGGK-README.txt file for the folder structure for the
    ## workdir => $WORKDIR 
    ##################################################################################
    ## Created on: SEP 27, 2020
    ## Coded by: Pali
    #########################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##
echo ">>>> CURRENT WORKING DIRECTORY => $WORKDIR "
## Removing all temporary files in Working directory
rm $WORKDIR/_tmp_*.*

## Copying all JSON files from extracted-json folder to WORKDIR
for jsonfile in $(find extracted-json/ -type f); do cp $jsonfile $WORKDIR/ ; done 


## PROCESSING JSON FILES TO CREATE YAML FILES
for x in *.json ;
do
    step1_json_file_input="_tmp_step1-$x" ;
    step1_json_file_output="_tmp_step2-$x" ;
    valid_notes_file="$VALID_NOTES_DIR/$(echo $x | sed 's/-0\.json/\.NOTES/ig') " ;
    echo ">> EXTRACTED_NAME => VALID NOTES FILE => $valid_notes_file" ;
    cat $valid_notes_file ;

    ## CHECK IF THIS NOTES FILE ACTUALLY EXISTS. ELSE, USE BACKUP NOTES FILE.
    echo; echo; 
    if [ -f $valid_notes_file ] ; then 
        echo " >> SUCCESS: Notes file found." ;
        valid_notes_file=$valid_notes_file ;
    else 
        echo " >> FAILURE: Notes file not found. Backup file will be used." ;
        valid_notes_file="$WORKDIR/_BACKUP_VALID_NOTES.TXT" ;
    fi 

    echo "FINAL_NAME => VALID NOTES FILE => $valid_notes_file" ;

    #### USING PYTHON SCRIPT TO PROCESS THIS JSON FILE
    cat $x | sed 's/\\"/"/g' | tr -d "\n\r" | sed 's/\t//ig' | sed 's+https://www.mygingergarlickitchen.com++ig' > $step1_json_file_input ;
    cat $step1_json_file_input ;
    python3 $MY_SCRIPT_PYTHON3 "$step1_json_file_input" "$step1_json_file_output" "$valid_notes_file" ;
done

##
echo;
echo "##---------------------------------------------" ;
echo ">>>> PRINTING WORD COUNT IN ALL FILES - JSON: " ;
echo "##---------------------------------------------" ;
wc *.json
echo "##---------------------------------------------" ;
echo ">>>> PRINTING WORD COUNT IN ALL FILES - YAML: " ;
echo "##---------------------------------------------" ;
wc *.yaml
##

##------------------------------------------------------------------------------
## Merging the new yaml file with the old md file
MDFILE_DIR="$WORKDIR/597x-original-md-files" ;
for y in *.yaml; 
do
    mdfile_original="$MDFILE_DIR/$(echo $y | sed 's/_tmp_step2-//ig' |sed 's/-0\.json\.yaml/\.md/ig') " ;
    echo ">> ORIGINAL => $mdfile_original" ;

    echo "" > _tmp_recipe_html.txt ;
    echo "{{< mggk-INSERT-RECIPE-HTML-BLOCK >}} " >> _tmp_recipe_html.txt ;

    cat $y $mdfile_original _tmp_recipe_html.txt > _tmp_step3.txt 
    cat _tmp_step3.txt | sed 's/XYZXYZXYZ---//ig' > _TOCHECK-$(basename $mdfile_original)
done 

## Deleting all intermediate + temporary files
rm *.yaml ;
rm _tmp_step* ;
rm *.json ;
##------------------------------------------------------------------------------


##------------------------------------------------------------------------------
#### BEGIN: COMMENT THIS WHOLE BLOCK ####
## DEFINE FUNCTION: Move YAML files to specific directory
function move_yaml_files_as_md () {
    YAMLDIR='/home/ubuntu/GitHub/ZZ-HUGO-TEST/content/597x-tocheck-$(date +%Y-%m-%d)' ;
    mkdir $YAMLDIR ;
    ####
    for yamlfile in *.md ; 
    do
        mv $yamlfile $YAMLDIR/$yamlfile  ;
    done 
    echo ">>>> All md files moved to $YAMLDIR" ;
}
## CALL FUNCTION
move_yaml_files_as_md
#### END: COMMENT THIS WHOLE BLOCK ####
##------------------------------------------------------------------------------

