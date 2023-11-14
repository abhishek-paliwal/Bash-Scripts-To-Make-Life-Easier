#/bin/bash

############ BEGIN: EXPANDING ALIASES ON NON-INTERATIVE SHELL SCRIPTS ########
source $HOME/.bash_aliases ## source this the first
shopt -s expand_aliases ## for BASH: This has to be done, else, aliases are not expanded in scripts.

## The following will be run as read from bash aliases
## comment/uncomment as needed
eval h003_create_image_captions_from_inference_api_from_someones_space ;
# eval h002_create_image_captions_from_inference_api  ; 
# eval h001_run_this_to_create_image_captions_in_pwd_custom_dir ; 