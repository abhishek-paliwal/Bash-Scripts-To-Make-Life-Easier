#/bin/bash

############ BEGIN: EXPANDING ALIASES ON NON-INTERATIVE SHELL SCRIPTS ########
source $HOME/.bash_aliases ## source this the first
shopt -s expand_aliases ## for BASH: This has to be done, else, aliases are not expanded in scripts.

## The following will be run as read from bash aliases
## comment/uncomment as needed
# eval h003_create_image_captions_from_inference_api_from_someones_space ;
# eval h002_create_image_captions_from_inference_api  ; 
# eval h001_run_this_to_create_image_captions_in_pwd_custom_dir ; 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "+++++++++++++++++++++++++++++++++++++++" ; 
echo ">> Choose an option:" ;
echo "1. FAST              = h002_create_image_captions_from_inference_api"
echo "2. FAST (FREE)       = googlecloud_use_gemini_pro_models_with_text_and_images_captions"
echo "3. FAST (PAID)       = googlecloud_create_image_captions_from_vertexai_vision"
#echo "4. FAST              = h003_create_image_captions_from_inference_api_from_someones_space"
#echo "5. VERYSLOW (local)  = h001_run_this_to_create_image_captions_in_pwd_custom_dir"
echo "99. Quit"
echo "+++++++++++++++++++++++++++++++++++++++" ; 

read -p "Enter your choice [Press ENTER to use default choice - 1]: " choice

case $choice in
    1)
        eval h002_create_image_captions_from_inference_api 
        ;;
    2)
        figlet 'USA VPN on ?' 
        eval googlecloud_use_gemini_pro_models_with_text_and_images_captions
        ;;
    3)
        eval googlecloud_create_image_captions_from_vertexai_vision
        ;;
    4)
        #eval h003_create_image_captions_from_inference_api_from_someones_space 
        ;;
    5)
        #eval h001_run_this_to_create_image_captions_in_pwd_custom_dir 
        ;;
    99)
        echo "Exiting the program."
        exit 0
        ;;
    *)
        echo "No option selected. Default command [option 1] will run..." ;
        eval h002_create_image_captions_from_inference_api ;
        ;;
esac
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

