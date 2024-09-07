#/bin/bash

DIR_PROJECT="$REPO_SCRIPTS/2000_vendor_programs/2003_find_similar_images" ;

# step1
$REPO_PYTHONPROGRAMS/my_python_virtual_environments/venv3/bin/python3 "$DIR_PROJECT/step1_find_similar_images.py" ;

# step2
bash "$DIR_PROJECT/step2_create_html_file_from_similar_images_found.sh" ;

