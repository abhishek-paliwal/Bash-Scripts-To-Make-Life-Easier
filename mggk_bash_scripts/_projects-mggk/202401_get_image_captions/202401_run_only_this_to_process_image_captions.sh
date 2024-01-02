#/bin/bash
## Run programs sequentially

# step1
bash "$REPO_SCRIPTS_MGGK_PROJECTS/202401_get_image_captions/202401_step1_mggk_create_captions_using_ai_for_all_old_mdfiles.sh" ; 

# step2
DIR_INPUT="$DIR_GITHUB/TMP0/2024_mggk_project_captions/_outputs" ; 
##
for subdir in $(fd -HItd -d1 --search-path="$DIR_INPUT") ; do
    cd $subdir ; 
    csv_file=$(basename "$subdir")"_captions.csv" ;
    html_file=$(basename "$subdir")"_output.html" ; 
    text_file_output=$(basename "$subdir")"_captions.txt" ; 
    ##
    #Usage: bash script.sh [csv_file] [html_file] [text_file_output]
    bash "$REPO_SCRIPTS_MGGK_PROJECTS/202401_get_image_captions/202401_step2_mggk_create_html_with_captions_from_csv_files_to_edit_and_download.sh" "$csv_file" "$html_file" "$text_file_output" ; 
    cd $DIR_INPUT ; 
done    
