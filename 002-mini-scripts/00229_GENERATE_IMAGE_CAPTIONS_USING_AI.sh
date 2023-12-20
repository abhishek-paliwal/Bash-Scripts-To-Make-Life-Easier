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
echo "1. FASTEST   = h003_create_image_captions_from_inference_api_from_someones_space"
echo "2. FAST      = h002_create_image_captions_from_inference_api"
echo "3. VERYSLOW  = h001_run_this_to_create_image_captions_in_pwd_custom_dir"
echo "4. FAST      = googlecloud_create_image_captions_from_vertexai_vision"
echo "5. Quit"
echo "+++++++++++++++++++++++++++++++++++++++" ; 

read -p "Enter your choice [Press ENTER to use default choice - 1]: " choice

case $choice in
    1)
        echo "You chose Option One."
        eval h003_create_image_captions_from_inference_api_from_someones_space  ;
        ;;
    2)
        echo "You chose Option Two."
        eval h002_create_image_captions_from_inference_api  ;
        ;;
    3)
        echo "You chose Option Three."
        eval h001_run_this_to_create_image_captions_in_pwd_custom_dir  ;
        ;;
    4)
        echo "You chose Option Four."
        eval googlecloud_create_image_captions_from_vertexai_vision ;
        ;;
    5)
        echo "Exiting the program."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please enter a number between 1 and 5. Default command will run..." ;
        eval h003_create_image_captions_from_inference_api_from_someones_space ;
        ;;
esac
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

