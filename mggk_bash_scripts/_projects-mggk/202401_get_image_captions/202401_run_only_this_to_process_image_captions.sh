#/bin/bash
## Run programs sequentially

# step1
bash "$REPO_SCRIPTS_MGGK_PROJECTS/202401_get_image_captions/202401_step1_mggk_create_captions_using_ai_for_all_old_mdfiles.sh" ; 

# step2
bash "$REPO_SCRIPTS_MGGK_PROJECTS/202401_get_image_captions/202401_step2_mggk_create_html_with_captions_from_csv_files_to_edit_and_download.sh" ; 
