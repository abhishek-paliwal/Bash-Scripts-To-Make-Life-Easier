#!/bin/bash
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
start_time_secs=$(date +%s) ;
FUNC_SOURCE_SCRIPTS () {
    source "$REPO_SCRIPTS_MINI/00200a_source_script_to_print_fancy_divider.sh" ;
}
FUNC_SOURCE_SCRIPTS ;
palidivider "START_TIME = $(date)" ;
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## USAGE:
    #### > bash $THIS_SCRIPT_NAME \$1
    #### WHERE, \$1 CAN BE ONE OF (anu, pali, leela)
    ################################################################################
    ## THIS SCRIPT SHOWS A LIST OF PERSONAL COMMANDS TO BE USED BY DIFFERENT USERS 
    ## AND ASKS FOR USER INPUT ABOUT WHICH COMMAND THE USER WANTS TO RUN FROM THAT 
    ## LIST. FINALLY, IT RUNS THE CHOSEN COMMAND.
    ################################################################################
    ## REQUIREMENT: THIS SCRIPT NEEDS A CLI ARGUMENT TO RUN.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: NOV 05, 2020
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

####################### ADDING COLOR TO OUTPUT ON CLI ##########################
echo "Currently sourcing the bash color script, which outputs chosen texts in various colors ..." ;

source $REPO_SCRIPTS/2000_vendor_programs/color-logger.sh

info "This enables use of keywords for coloring, such as: debug, info, error, success, warn, highlight." ;
debug "Read it's help by running: >> bash $DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/color-logger.sh -h"
##############################################################################

##############################################################################
############ BEGIN: EXPANDING ALIASES ON NON-INTERATIVE SHELL SCRIPTS ########
source "$REPO_DOTFILES"/_00_common_files/.bash_aliases ## source this the first
shopt -s expand_aliases ## for BASH: This has to be done, else, aliases are not expanded in scripts.
##
## IF THE HOME USER IS UBUNTU, CHANGE SOME DEFAULT VARIABLES (BCOZ WE ARE USING WSL)
echo; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo "IMPORTANT NOTE: This OS is $(uname) ... aliases and profile will be sourced now." ; 
echo "IMPORTANT NOTE: YOU CAN DISREGARD THIS ERROR BELOW: alias: bash: not found" ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo; 
if [ "$(uname)" == "Linux" ] ; then 
    source $HOME/.profile ;
    source $HOME/.bash_aliases ; ## Then, this also has to be done to use aliases in this script.
else
    source $HOME/.bash_profile ;
    source $HOME/.bash_aliases ; ## Then, this also has to be done to use aliases in this script.
fi 
############ END: EXPANDING ALIASES ON NON-INTERATIVE SHELL SCRIPTS ##########
##############################################################################

WORKING_DIR="$DIR_Y" ;
PWD=$WORKING_DIR ;
echo ;
echo "################################################################################" ; 
info "## PRESENT WORKING DIRECTORY = $PWD" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## GET THE USER FROM THE CLI ARGUMENT:
WHICH_USER=$1;
if [ -z "$WHICH_USER" ] ; then 
  echo; 
  error ">>>> FAILURE: No CLI argument given. Please provide one." ; 
  exit 1 ; 
echo;  
fi 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##############################################################################
## DECLARING COMMAND LIST ARRAYS FOR EACH USER, ONE COMMAND PER LINE (NO COMMAS)
ANU_COMMANDS_ARRAY=(makesite_mggk
frontm
frontm_sponsored
makesite_mggk_quickly
search_mggk_url_and_open_mdfile_in_code
video_cutting_in_1_minute_equal_parts_using_ffmpeg
1x1
upload_all_images_to_mggk_webserver
506-mggk-search-word-in-tags-and-categories
599-mggk-CREATE-AND-SAVE-SITE-STATISTICS
601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls-NEW2021
999-mggk-EXTRACT-VIDEO-SCREENSHOTS-EVERY-N-SECONDS
999A-mggk-MATCH-WORDS-IN-MD-FILE-WITH-EXISTING-URLS-LIKE-WORDPRESS
999B-mggk-CREATE-SEARCH-ENGINE-LINKS-FOR-ALL-URLS
999-mggk-CREATE-RESPONSIVE-IMAGES-FOR-MGGK-SITE
901-mggk-delete-cloudflare-cache-for-chosen-keyword-urls
901-mggk-delete-cloudflare-cache-for-user-input-urls
902-linkchecker-extract-all-internal-external-images-links-from-given-urls
convert_images_to_1080x1920_padded_imagemagick
make_collages_from_images_from_given_url_1080x1920
yoast-find-possible-mdfiles-for-inserting-links-for-given-keyword
yoast_find_all_outbound_mdfiles_urls_containing_target_keyword_url
leelasrecipes_run_commands_13_14_15_16
algolia_search_for_this_phrase_mggk
yt1_download_audio
yt2_download_video
ffmpeg_convert_webm_videos_to_mp4
mggk_search_ONEDRIVE_FILES
GENERATE_IMAGE_CAPTIONS_USING_AI
00227_mggk_resize_jpg_png_to_1200px_and_reduce_size_over_950KB_images_in_pwd_imagemagick
00236_mggk_find_number_of_images_in_every_post_from_figure_tags_hugo
00238_mggk_find_the_count_of_particular_keywords_in_competitor_recipe_urls_keysearch_io
ml03_step00_only_run_this_for_document_similarity_comparison
00241_delete_chosen_image_files_from_mggk_cdn_based_upon_LROOM_dir_images
imagemagick_resize_images_to_512px_for_AI_captionining) ;


##
MGGK_COMMANDS_ARRAY=(makesite_mggk
makesite_mggk_quickly
frontm
frontm_sponsored
algolia_search_for_this_phrase_mggk
gif_maker_from_jpgs
hugo_mggk_enable_featured_posts
pali_spellings_check_in_this_directory
search_mggk_url_and_open_mdfile_in_code
video_cutting_in_1_minute_equal_parts_using_ffmpeg
1x1
10-mggk-create-images-index-page-for-current-year
114b_mggk_make_imagemagick_very_fancy_custom_collage
505_mggk-rss-to-email-xml-feed-parser
505A-mggk-custom-newsletter-creation-from-hyperlinks-text-file
506-mggk-search-word-in-tags-and-categories
599_mggk_REPLACE_BULK_RATINGCOUNT_AND_RATINGVALUE_FROM_GOOGLE_SHEETS_CSV
599-mggk-2020-CREATE-IMAGES-TO-DIFFERENT-RATIOS-USING-IMAGEMAGICK-IN-PWD
599-mggk-CREATE-AND-SAVE-SITE-STATISTICS
599-mggk-MAKE-VIDEO-SITEMAP-XML
599_mggk_CREATE_ALL_MISSING_STEPS_IMAGES_DIRECTORIES
601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls-NEW2021
702-mggk-CREATE-LD-JSON-FAQ-BLOCKS-FROM-MD-FILES
999-mggk-EXTRACT-VIDEO-SCREENSHOTS-EVERY-N-SECONDS
999-mggk-MOVE-MD-FILES-to-PWD-based-on-URLs-from-CLI-text-file-argument
999-mggk-convert-each-line-in-text-file-to-HTML-hyperlinks
999-mggk-opening-hyperlinks-in-browser-for-checking
999-mggk-2020-MICROSOFT-BING-BATCH-URL-SUBMISSION
999A-mggk-MATCH-WORDS-IN-MD-FILE-WITH-EXISTING-URLS-LIKE-WORDPRESS
999B-mggk-CREATE-SEARCH-ENGINE-LINKS-FOR-ALL-URLS
999-mggk-CREATE-PDF-FILES-FROM-RECIPE-MD-FILES
999-mggk-REPLACE-RECIPE-STEPS-WHITE-SQUARE-IMAGES-WITH-WIDE-ONES
999-mggk-CREATE-RESPONSIVE-IMAGES-FOR-MGGK-SITE
901-mggk-delete-cloudflare-cache-for-chosen-keyword-urls
901-mggk-delete-cloudflare-cache-for-user-input-urls
902-linkchecker-extract-all-internal-external-images-links-from-given-urls
999-mggk-CREATE-PRINT-HTML-FILES-FROM-RECIPE-MD-FILES
mggk_shortcode_collection_maker
mggk_calculate_length_of_yoast_description
mggk_calculate_length_of_titles
mggk_calculate_length_of_urls
10b-mggk-create-index-for-recipe-steps-present-folder
convert_images_to_1080x1920_padded_imagemagick
9999_mggk_create_mggk_and_localhost_hyperlinks_from_all_mdfiles_in_pwd
yoast-calculate-all-inbound-outbound-links-counts
yoast_find_paragraph_word_counts
mggk_WEEKLY_SUMMARY_RUN
00232_mggk_download_N_random_images_from_MGGK_website) ;

##
PALI_COMMANDS_ARRAY=(palinotes_makesite_hugo
frontp
0000_create_NEW_BASH_SCRIPT_FROM_TEMPLATE
edit_0000_BASHSCRIPT_CREATION_TEMPLATE_FILE
edit_999Z_script
edit_lce_index_html
1_all_backup_indexes_maker
999-make-imagemagick-collage-vertically-and-horizontally
pali_0000_create_html_index_with_usage_help_for_all_bash_scripts
pali_copy_aspell_personal_words_for_this_user
pali_countfiles
pali_filepath_printing
pali_imagesinfo
pali_move_videos_and_photos_to_separate_folders
pali_move_videos_and_photos_to_separate_folders_win
pali_pathlength_printing
pali_print_video_and_image_dimensions_using_ffprobe
pali_spellings_add_in_personal_words
pali_spellings_check_in_this_directory
pali_takeout_google_unzip_all_sequential_zip_files
pali_mggk_RSYNC_REPOS_MGGK_AND_ZZMGGK
pali_GIT_STATUS_FOR_ALL_REPOS
pali_git_CONFIRM_ALL_CHANGES
pali_imagemagick_fixed_resize_images_by_width_or_height
2000-python-image-resize
pali_imagemagick_create_10_random_images
901-mggk-delete-cloudflare-cache-for-chosen-keyword-urls
901-mggk-delete-cloudflare-cache-for-user-input-urls
901-mggk-delete-cloudflare-cache-for-user-input-urls-adoria
901-mggk-get-all-image-links-from-mggk-webpages-for-cloudflare-cache
901-mggk-get-and-save-cloudflare-cache-status-for-all-valid-mggk-urls-1K-150K
902-linkchecker-extract-all-internal-external-images-links-from-given-urls
601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls
601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls-NEW2021
convert-all-csv-files-in-pwd-to-html-tables-bootstrap
mggk_WEEKLY_SUMMARY_RUN
gits_all
dotfiles_copy
create_listing_of_mggk_ONEDRIVE_FILES) ;

##
LEELA_COMMANDS_ARRAY=(leelasrecipes_makesite_hugo
frontl_leelasrecipes
1x1
leelasrecipes_rename_images-with-custom-prefix-and-counters
leelasrecipes-MOVE-ALL-PWD-IMAGES-TO-PROPER-WEBSITE-FOLDER
leelasrecipes_check_spellings
leelasrecipes-CREATE-AND-SAVE-SITE-STATISTICS
leelasrecipes-MAKE-VIDEO-SITEMAP-XML
leelasrecipes_calculate_length_of_description
leelasrecipes_calculate_length_of_titles
leelasrecipes_calculate_length_of_urls
999-mggk-EXTRACT-VIDEO-SCREENSHOTS-EVERY-N-SECONDS
leelasrecipes_make_20_directories
leelasrecipes-CREATE-SUBDIRECTORIES-THEN-MOVE-STEPS-IMAGES
leelasrecipes-WATERMARK-IMAGES-SEQUENTIALLY-IN-SUBDIRS
2000-collage-maker-using-vendor-script-leelasrecipes
2000-python-image-resize
leelasrecipes_run_commands_13_14_15_16
pali_imagemagick_create_10_random_images
901-mggk-delete-cloudflare-cache-for-chosen-keyword-urls-leelasrecipes
901-mggk-delete-cloudflare-cache-for-user-input-urls-leelasrecipes
9998-digitalocean-create-responsive-images-and-copy-to-cdn) ;

##
IMAGEMAGICK_FFMPEG_COMMANDS_ARRAY=(1_imagemagick_maker
1_tinypng_maker
111_ffmpeg_convert_opus_to_mp3
112_ffmpeg_join_movies
113_ffmpeg_images_to_video_slideshow_maker
114_make_imagemagick_collage_with_title
114a_make_imagemagick_very_fancy_custom_collage
114b_mggk_make_imagemagick_very_fancy_custom_collage
115_imagemagick_print_custom_label_text_onto_images
116_imagemagick_crop_images_to_any_custom_dimensions
117-imagemagick-sort-images-long-and-wide
118-imagemagick-make-title-slides-and-move-to-their-directories
119-imagemagick-make-video-slideshow-title-using-collage-n-text
120-imagemagick-create-random-image-with-user-input-text
2000-python_collage_maker
2000-collage-maker-using-vendor-script
201_sorting_mp3_files_by_duration
202_change_id3_tags_info_for_mp3
203-join-N-random-mp3-files-using-ffmpeg
599-mggk-2020-CREATE-IMAGES-TO-DIFFERENT-RATIOS-USING-IMAGEMAGICK-IN-PWD
999-make-imagemagick-collage-vertically-and-horizontally
bordercolor
ffmpeg_extract_audio_from_mp4_video
gif_maker_from_jpgs
gif_to_png_frames
jpg2webp
mggk_shortcode_collection_maker
pali_move_videos_and_photos_to_separate_folders
png2webp
unsplash_wallpaper_download
video_cutting_in_1_minute_equal_parts_using_ffmpeg
webp_animation_to_png_first_frame
webp_to_jpg
webp_to_png
youtube-download-all-formats
youtube-download-best-audio-only
youtube-download-best-overall-version
youtube-list-formats
youtube-update-downloader-program
pali_imagemagick_fixed_resize_images_by_width_or_height
pali_imagemagick_create_10_random_images
convert_images_to_1080x1920_padded_imagemagick
convert_images_to_1920x1080_padded_imagemagick
2000-python-image-resize)
##
DIGITALOCEAN_COMMANDS_ARRAY=(9995-digitalocean-delete-all-temporary-unnecessary-files
9996-digitalocean-send-server-backups-to-dreamobjects
9997-digitalocean-download-latest-datafiles-required-for-react-apps
9997-digitalocean-download-latest-rss-xml-feeds-from-websites
9998-digitalocean-create-responsive-images-and-copy-to-cdn
9999-download-latest-scripts-from-github-repo-for-crontab
9999-show-files-to-delete-for-space-cleanup-digitalocean
dotfiles_copy)

##
GOPS_COMMANDS_ARRAY=(gops_full_video_extraction_encoding_upload_process)

## Assign the corresponding user array to the new array variable
if [ "$WHICH_USER" == "mggk" ] ; then MY_COMMANDS_ARRAY=( "${MGGK_COMMANDS_ARRAY[@]}" ) ; fi
if [ "$WHICH_USER" == "anu" ] ; then MY_COMMANDS_ARRAY=( "${ANU_COMMANDS_ARRAY[@]}" ) ; fi
if [ "$WHICH_USER" == "pali" ] ; then MY_COMMANDS_ARRAY=( "${PALI_COMMANDS_ARRAY[@]}" ) ; fi
if [ "$WHICH_USER" == "leela" ] ; then MY_COMMANDS_ARRAY=( "${LEELA_COMMANDS_ARRAY[@]}" ) ; fi
if [ "$WHICH_USER" == "gops" ] ; then MY_COMMANDS_ARRAY=( "${GOPS_COMMANDS_ARRAY[@]}" ) ; fi
if [ "$WHICH_USER" == "docean" ] ; then MY_COMMANDS_ARRAY=( "${DIGITALOCEAN_COMMANDS_ARRAY[@]}" ) ; fi
if [ "$WHICH_USER" == "imagemagick_ffmpeg" ] ; then MY_COMMANDS_ARRAY=( "${IMAGEMAGICK_FFMPEG_COMMANDS_ARRAY[@]}" ) ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## PRINTING ALL ELEMENTS OF THE COMMAND ARRAY
echo;
echo "##------------------------------------------------------------------------------"; 
info "TOTAL NUMBEER OF COMMANDS FOUND: ${#MY_COMMANDS_ARRAY[*]}" ; echo; 
info ">>>> MY COMMAND LIST >>>> "; echo; 
for index in ${!MY_COMMANDS_ARRAY[*]}
do
    printf "%4d: %s\n" $index ${MY_COMMANDS_ARRAY[$index]}
done
echo "##------------------------------------------------------------------------------"; 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USER INPUT:
echo; 
info ">>>> SELECT THE NUMBER OF THE COMMAND TO RUN (press ENTER key to exit) =>" ;
read WHICH_COMMAND_TO_RUN
echo;

# Check for validity if no input is given
if [ -z $WHICH_COMMAND_TO_RUN ]
then
  error "*** INVALID USER INPUT. PROGRAM WILL EXIT NOW. ***" ;
  exit 1 ; 
elif [ -n $WHICH_COMMAND_TO_RUN ]
then
  echo ">>>> Are you sure, you want to run this command: " ;
  warn "${MY_COMMANDS_ARRAY[$WHICH_COMMAND_TO_RUN]}" ; 
  echo; 
  read -p "Press Enter key if OKAY ..." ; 
  # run the chosen command
  echo; 
  info ">>>> RUNNING THE CHOSEN COMMAND" ; echo ; 
  eval ${MY_COMMANDS_ARRAY[$WHICH_COMMAND_TO_RUN]} ;
fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##------------------------------------------------------------------------------
## ASSIGN COMPUTER HOSTNAME SPECIFIC VARIABLES
function FUNC_display_end_msg () {
    palidivider "Running $FUNCNAME" ;
    HOSTNAME=$(uname) ;
    ## Possible hostnames are: 
    #### AP-MBP.local // LAPTOP-F0AJ6LBG // ubuntu1804-digitalocean-bangalore-droplet
    ## 
    figlet ">> DONE" ; 
    ## Also say if MAC OS
    if [ "$(uname)" == "Darwin" ] ; then say 'done' ; fi
}
FUNC_display_end_msg ; 
##------------------------------------------------------------------------------

end_time_secs=$(date +%s) ;
command_duration=$((end_time_secs - start_time_secs)) ;
command_duration_minutes=$(echo "scale=2; $command_duration/60" | bc -l) ; 
#echo "Total program duration: ${command_duration} seconds" ;
palidivider "End time = $(date). Program took ${command_duration} secs (${command_duration_minutes} mins)";

