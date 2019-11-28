#!/bin/bash
THIS_SCRIPT_NAME="1599-palinotes-CREATE-AND-SAVE-SITE-STATISTICS.sh"
cat << EOF
  ################################################################################
  ## THIS SCRIPT GATHERS IMPORTANT SITE STATS USING HUGO MD FILES, AND
  ## SAVES THEM TO AN OUTPUT FILE IN HUGO STATIC DIRECTORY
  ## USAGE:
  #### bash $THIS_SCRIPT_NAME
  ################################################################################
EOF

HUGO_CONTENT_DIR="$HOME/GitHub/2019-NOTES-HUGO-WEBSITE-PALI/content"
FILE_OUTPUT_SITESTATS="$HOME/GitHub/2019-NOTES-HUGO-WEBSITE-PALI/static/sitestats.html"

##------------------ DO NOT CHANGE ANYTHING BELOW ------------------------------
## OUTPUT FILE CREATED AT (+ initializing the output file):
echo "<pre>" > $FILE_OUTPUT_SITESTATS
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS
echo "## MGGK Site Statistics last updated at:" >> $FILE_OUTPUT_SITESTATS
echo "## $(date)" >> $FILE_OUTPUT_SITESTATS
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF ALL MD POSTS
NUM_MD_POSTS=$(find $HUGO_CONTENT_DIR/ -type f | grep '.md'| wc -l)
echo "$NUM_MD_POSTS: NUMBER OF ALL MD POSTS" >> $FILE_OUTPUT_SITESTATS

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
NUM_YOAST_DESCIPTION_POSTS=$(grep -irl 'yoast_description:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_YOAST_DESCIPTION_POSTS: NUMBER OF POSTS WITH YOAST_DESCIPTION" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH FEATURED_IMAGE
NUM_FEATURED_IMAGE_POSTS=$(grep -irh 'featured_image:' $HUGO_CONTENT_DIR/* | wc -l)
echo "$NUM_FEATURED_IMAGE_POSTS: NUMBER OF POSTS WITH FEATURED_IMAGE" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH CATEGORIES
NUM_CATEGORIES_POSTS=$(grep -irl '^categories:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_CATEGORIES_POSTS: NUMBER OF POSTS WITH CATEGORIES" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH TAGS
NUM_TAGS_POSTS=$(grep -irl '^tags:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_TAGS_POSTS: NUMBER OF POSTS WITH TAGS" >> $FILE_OUTPUT_SITESTATS
## NUMBER OF POSTS WITH MGGK_JSON_RECIPE BLOCK
NUM_MGGK_JSON_RECIPE_POSTS=$(grep -irh 'mggk_json_recipe:' $HUGO_CONTENT_DIR/* | wc -l)
echo "$NUM_MGGK_JSON_RECIPE_POSTS: NUMBER OF POSTS WITH MGGK_JSON_RECIPE BLOCK" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH YOUTUBE_VIDEO_ID
NUM_YOUTUBE_VIDEO_ID_POSTS=$(grep -irh 'youtube_video_id:' $HUGO_CONTENT_DIR/* | wc -l)
echo "$NUM_YOUTUBE_VIDEO_ID_POSTS: NUMBER OF POSTS WITH YOUTUBE_VIDEO_ID" >> $FILE_OUTPUT_SITESTATS

##------------------------------------------------------------------------------
## LIST OF ALL URLS FOUND IN MD FILES
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS
LIST_OF_ALL_URLS=$(grep -irh '^url: ' $HUGO_CONTENT_DIR/* | sort| nl)
echo "" >> $FILE_OUTPUT_SITESTATS
echo "LIST OF ALL URLS FOUND IN MD FILES:" >> $FILE_OUTPUT_SITESTATS
echo "$LIST_OF_ALL_URLS" >> $FILE_OUTPUT_SITESTATS
##------------------------------------------------------------------------------

## NUMBER OF POSTS BY MONTHS
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS
NUMBER_OF_POSTS_BY_MONTHS=$(grep -irh 'date: ' $HUGO_CONTENT_DIR/* | sed 's/date: //g' | cut -c1-7 | sort | uniq -c | awk '{print  }')
echo "" >> $FILE_OUTPUT_SITESTATS
echo "NUMBER OF POSTS BY MONTHS:" >> $FILE_OUTPUT_SITESTATS
echo "$NUMBER_OF_POSTS_BY_MONTHS" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS BY EACH DATE
NUMBER_OF_POSTS_BY_EACH_DATE=$(grep -irh 'date: ' $HUGO_CONTENT_DIR/* | sed 's/date: //g' | cut -c1-10 | sort | uniq -c | awk '{ printf ("%s => %4d    ",$2,$1) ; p = $1 ; for(c=0;c<p;c++) printf "X"; print ":" }' )
echo "" >> $FILE_OUTPUT_SITESTATS
echo "NUMBER OF POSTS BY EACH DATE:" >> $FILE_OUTPUT_SITESTATS
echo "$NUMBER_OF_POSTS_BY_EACH_DATE" >> $FILE_OUTPUT_SITESTATS

##------------------------------------------------------------------------------

echo "################################################################################" >> $FILE_OUTPUT_SITESTATS
echo "</pre>" >> $FILE_OUTPUT_SITESTATS
