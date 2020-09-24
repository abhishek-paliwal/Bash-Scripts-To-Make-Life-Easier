#/bin/bash
##############################

MY_SCRIPT_PYTHON3="$DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/701-mggk-2020/701-script_python.py" ;

## Assigning working directory and going to it
WORKDIR="$HOME_WINDOWS/Desktop/X" ;
cd $WORKDIR ;

##
## Removing all temporary files in Working directory
rm $WORKDIR/_tmp_*.*
##
for x in *.json ;
do
    step1_json_file_input="_tmp_step1-$x" ;
    step1_json_file_output="_tmp_step2-$x" ;
    ####
    cat $x | sed 's/\\"/"/g' | tr -d "\n\r" | sed 's/\t//ig' | sed 's+https://www.mygingergarlickitchen.com++ig' > $step1_json_file_input ;
    cat $step1_json_file_input ;
    python3 $MY_SCRIPT_PYTHON3 "$step1_json_file_input" "$step1_json_file_output" ;
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


#### BEGIN: COMMENT THIS WHOLE BLOCK ####
# Move YAML files to specific directory
#YAMLDIR="/home/ubuntu/GitHub/ZZ-HUGO-TEST/content/223x-no-howtosection-recipes" ;
YAMLDIR='/home/ubuntu/GitHub/ZZ-HUGO-TEST/content/374x-yes-howtosection-recipes' ;
mkdir $YAMLDIR ;
for yamlfile in *.yaml ; 
do
    mv $yamlfile $YAMLDIR/$yamlfile.md  ;
done 
echo ">>>> All md files moved to $YAMLDIR" ;
#### END: COMMENT THIS WHOLE BLOCK ####

