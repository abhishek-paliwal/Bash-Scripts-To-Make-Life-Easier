#!/bin/bash
THIS_SCRIPT_NAME="1002-leelasrecipes-CREATE-AND-SAVE-SITE-STATISTICS.sh"

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ################################################################################
  ## THIS SCRIPT GATHERS IMPORTANT SITE STATS USING HUGO MD FILES, AND
  ## SAVES THEM TO AN OUTPUT FILE IN HUGO STATIC DIRECTORY
  ## USAGE:
  #### bash $THIS_SCRIPT_NAME
  ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

HUGO_BASE_DIR="$REPO_LEELA"
HUGO_CONTENT_DIR="$REPO_LEELA/content"
FILE_OUTPUT_SITESTATS="$REPO_LEELA_SUMMARY/leelasrecipes-sitestats.html"

##------------------ DO NOT CHANGE ANYTHING BELOW ------------------------------
## OUTPUT FILE CREATED AT (+ initializing the output file):
echo "<pre>" > $FILE_OUTPUT_SITESTATS
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS
echo "## LEELARECIPES.COM Site Statistics last updated at:" >> $FILE_OUTPUT_SITESTATS
echo "## $(date)" >> $FILE_OUTPUT_SITESTATS
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF ALL MD POSTS
NUM_MD_POSTS=$(find $HUGO_CONTENT_DIR/ -type f | grep '.md'| wc -l)
echo "$NUM_MD_POSTS: NUMBER OF ALL MD POSTS" >> $FILE_OUTPUT_SITESTATS
echo "        >>>> $NUM_MD_POSTS: NUMBER OF ALL MD POSTS"

## NUMBER OF POSTS WITH TITLE
NUM_TITLE_POSTS=$(grep -irl '^title:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_TITLE_POSTS: NUMBER OF POSTS WITH TITLE" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH DATE
NUM_DATE_POSTS=$(grep -irl '^date:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_DATE_POSTS: NUMBER OF POSTS WITH DATE" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH URL TAGS
NUM_URL_POSTS=$(grep -irl '^url:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_URL_POSTS: NUMBER OF POSTS WITH URL TAGS" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH YOAST_DESCIPTION
NUM_YOAST_DESCIPTION_POSTS=$(grep -irl 'description:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_YOAST_DESCIPTION_POSTS: NUMBER OF POSTS WITH DESCRIPTION" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH FEATURED_IMAGE
NUM_FEATURED_IMAGE_POSTS=$(grep -irh 'image:' $HUGO_CONTENT_DIR/* | wc -l)
echo "$NUM_FEATURED_IMAGE_POSTS: NUMBER OF POSTS WITH FEATURED IMAGE TAG" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH CATEGORIES
NUM_CATEGORIES_POSTS=$(grep -irl '^categories:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_CATEGORIES_POSTS: NUMBER OF POSTS WITH CATEGORIES" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH TAGS
NUM_TAGS_POSTS=$(grep -irl '^tags:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_TAGS_POSTS: NUMBER OF POSTS WITH TAGS" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH MGGK_JSON_RECIPE BLOCK
NUM_MGGK_JSON_RECIPE_POSTS=$(grep -irh 'mggk_json_recipe:' $HUGO_CONTENT_DIR/* | wc -l)
echo "$NUM_MGGK_JSON_RECIPE_POSTS: NUMBER OF POSTS WITH JSON_RECIPE BLOCK" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH YOUTUBE_VIDEO_ID
NUM_YOUTUBE_VIDEO_ID_POSTS=$(grep -irh 'youtube_video_id:' $HUGO_CONTENT_DIR/* | wc -l)
echo "$NUM_YOUTUBE_VIDEO_ID_POSTS: NUMBER OF POSTS WITH YOUTUBE_VIDEO_ID" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF CURRENT YOUTUBE COVER IMAGES PRESENT IN LOCAL DIRECTORY
NUM_CURRENT_YOUTUBE_COVER_IMAGES=$(cat "$HUGO_BASE_DIR/static/video-cover-images-current.txt" | wc -l)
echo "$NUM_CURRENT_YOUTUBE_COVER_IMAGES: NUMBER OF CURRENT YOUTUBE COVER IMAGES PRESENT" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH MGGK_RECIPE_HERE_BUTTON_BLOCKS
RECIPE_HERE_BUTTON_BLOCKS=$(grep -irh '{{< leelasrecipes-button-block-for-recipe-here-link >}}' $HUGO_CONTENT_DIR/* | wc -l)
echo "$RECIPE_HERE_BUTTON_BLOCKS: NUMBER OF POSTS WITH RECIPE_HERE_BUTTON_BLOCKS" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF CURRENT IMAGES PRESENT IN 1x1 DIRECTORY
NUM_CURRENT_1x1_IMAGES=$(ls $HUGO_BASE_DIR/static/rich-markup-images/1x1/*.jpg | wc -l)
echo "$NUM_CURRENT_1x1_IMAGES: NUMBER OF CURRENT IMAGES PRESENT IN 1x1 DIRECTORY" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF CURRENT IMAGES PRESENT IN 4x3 DIRECTORY
NUM_CURRENT_4x3_IMAGES=$(ls $HUGO_BASE_DIR/static/rich-markup-images/4x3/*.jpg | wc -l)
echo "$NUM_CURRENT_4x3_IMAGES: NUMBER OF CURRENT IMAGES PRESENT IN 4x3 DIRECTORY" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF CURRENT IMAGES PRESENT IN 16x9 DIRECTORY
NUM_CURRENT_16x9_IMAGES=$(ls $HUGO_BASE_DIR/static/rich-markup-images/16x9/*.jpg | wc -l)
echo "$NUM_CURRENT_16x9_IMAGES: NUMBER OF CURRENT IMAGES PRESENT IN 16x9 DIRECTORY" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF CURRENT IMAGES PRESENT IN ORIGINAL_COPIED DIRECTORY
NUM_CURRENT_ORIGINAL_COPIED_IMAGES=$(ls $HUGO_BASE_DIR/static/rich-markup-images/original_copied/*.* | wc -l)
echo "$NUM_CURRENT_ORIGINAL_COPIED_IMAGES: NUMBER OF CURRENT IMAGES PRESENT IN original_copied DIRECTORY" >> $FILE_OUTPUT_SITESTATS


##------------------------------------------------------------------------------
## LIST OF ALL URLS FOUND IN MD FILES
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS
#LIST_OF_ALL_URLS=$(fd 'md' $HUGO_CONTENT_DIR/ | sed 's|/home/ubuntu/GitHub/2020-LEELA-RECIPES/content/||ig' | sort| nl)
LIST_OF_ALL_URLS=$(grep -irh '^url: ' $HUGO_CONTENT_DIR/* | sort| nl)
echo "" >> $FILE_OUTPUT_SITESTATS
echo "LIST OF ALL URLS FOUND IN MD FILES:" >> $FILE_OUTPUT_SITESTATS
echo "$LIST_OF_ALL_URLS" >> $FILE_OUTPUT_SITESTATS
##------------------------------------------------------------------------------

## NUMBER OF POSTS BY MONTHS
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS
NUMBER_OF_POSTS_BY_MONTHS=$(grep -irh '^date: ' $HUGO_CONTENT_DIR/* | sed 's/date: //g' | cut -c1-7 | sort | uniq -c | awk '{print  }')
echo "" >> $FILE_OUTPUT_SITESTATS
echo "NUMBER OF POSTS BY MONTHS:" >> $FILE_OUTPUT_SITESTATS
echo "$NUMBER_OF_POSTS_BY_MONTHS" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS BY EACH DATE
NUMBER_OF_POSTS_BY_EACH_DATE=$(grep -irh '^date: ' $HUGO_CONTENT_DIR/* | sed 's/date: //g' | cut -c1-10 | sort | uniq -c | awk '{ printf ("%s => %4d    ",$2,$1) ; p = $1 ; for(c=0;c<p;c++) printf "X"; print ":" }' )
echo "" >> $FILE_OUTPUT_SITESTATS
echo "NUMBER OF POSTS BY EACH DATE:" >> $FILE_OUTPUT_SITESTATS
echo "$NUMBER_OF_POSTS_BY_EACH_DATE" >> $FILE_OUTPUT_SITESTATS

##------------------------------------------------------------------------------

echo "################################################################################" >> $FILE_OUTPUT_SITESTATS
echo "</pre>" >> $FILE_OUTPUT_SITESTATS

##################################################################################
echo;
echo ">> SUMMARY >> " ;
echo ">> STATISTICS FILE SAVED AS => $FILE_OUTPUT_SITESTATS" ;
## COPY this file to Dropbox dir
cp $FILE_OUTPUT_SITESTATS $DIR_DROPBOX_SCRIPTS_OUTPUT/