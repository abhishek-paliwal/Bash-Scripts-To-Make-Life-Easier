#/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
start_time_secs=$(date +%s) ;
FUNC_SOURCE_SCRIPTS () {
    source "$REPO_SCRIPTS_MINI/00200a_source_script_to_print_fancy_divider.sh" ;
}
FUNC_SOURCE_SCRIPTS ; 
palidivider "START_TIME = $(date)" ; 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


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
echo "1. FASTEST   = h003_create_image_captions_from_inference_api_from_someones_space"
echo "2. FAST      = h002_create_image_captions_from_inference_api"
echo "3. VERYSLOW  = h001_run_this_to_create_image_captions_in_pwd_custom_dir"
echo "4. FAST      = googlecloud_create_image_captions_from_vertexai_vision"
echo "5. FAST      = googlecloud_use_gemini_pro_models_with_text_and_images_captions"
echo "99. Quit"
echo "+++++++++++++++++++++++++++++++++++++++" ; 

read -p "Enter your choice [Press ENTER to use default choice - 1]: " choice

case $choice in
    1)
        echo "You chose Option 1."
        eval h003_create_image_captions_from_inference_api_from_someones_space  ;
        ;;
    2)
        echo "You chose Option 2."
        eval h002_create_image_captions_from_inference_api  ;
        ;;
    3)
        echo "You chose Option 3."
        eval h001_run_this_to_create_image_captions_in_pwd_custom_dir  ;
        ;;
    4)
        echo "You chose Option 4."
        eval googlecloud_create_image_captions_from_vertexai_vision ;
        ;;
    5)
        echo "You chose Option 5." ; 
        figlet 'USA VPN on ?' ; 
        eval googlecloud_use_gemini_pro_models_with_text_and_images_captions ;
        ;;
    99)
        echo "Exiting the program."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please enter a number between 1 and 5. Default command will run..." ;
        eval h003_create_image_captions_from_inference_api_from_someones_space ;
        ;;
esac
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end_time_secs=$(date +%s) ; 
command_duration=$((end_time_secs - start_time_secs)) ; 
#echo "Total program duration: ${command_duration} seconds" ; 
palidivider "End time = $(date). Program took ${command_duration} seconds"; 
