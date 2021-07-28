#!/bin/bash
THIS_SCRIPT_NAME="599-mggk-create-and-save-site-statistics.sh"

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

##################################################################################
HUGO_CONTENT_DIR="$REPO_MGGK/content" ;
FILE_OUTPUT_SITESTATS="$DIR_Y/tmp-mggk-sitestats.html" ;
FILE_OUTPUT_SITESTATS_FINAL="$REPO_MGGK_SUMMARY/mggk-sitestats.html" ;
DIR_HUGO_MAIN="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL" ; 
DIR_OUTPUT="$HOME/Desktop/Y" ;

echo "##------------------------------------------------------------------------------" ;
echo ">> GATHERING IMPORTANT SITE STATS FOR MGGK HUGO WEBSITE ..." ;
echo "##------------------------------------------------------------------------------" ;

##------------------ ADD BLOCKS AS NEEDED BELOW ------------------------------

##################################################################################
##################################################################################
## CREATING SUMMARY FILES TO BE USED BY CLOUDFLARE SCRIPTS
echo ">> CREATING SUMMARY FILES TO BE USED BY CLOUDFLARE SCRIPTS ... (line counts below)" ;
FilesUrlsWPcontent="$DIR_DROPBOX_SCRIPTS_OUTPUT/mggk_summary_cloudflare_FilesUrlsWPcontent.txt" ;
AllValidUrlsMGGK="$DIR_DROPBOX_SCRIPTS_OUTPUT/mggk_summary_cloudflare_AllValidSiteUrls.txt" ;
##
#### Get all filepaths inside wp-content directory and converting them to valid MGGK urls
replaceThis1="/home/ubuntu/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static" ;
replaceThis2="/Users/abhishek/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static" ;
replaceTo="https://www.mygingergarlickitchen.com" ;
## (Add -I flag so that fd also read filepaths present in .gitignore in the given directory)
fd -I -t f --search-path=$REPO_MGGK/static/wp-content | sd "$replaceThis1" "$replaceTo" | sd "$replaceThis2" "$replaceTo" > $FilesUrlsWPcontent ;
####

## Get all mggk urls from current md files
ack -ih 'url:' $REPO_MGGK/content/ | sd 'url:' '' | sd ' ' '' | sd '"' '' | sd '^' 'https://www.mygingergarlickitchen.com'  | sort | uniq > $AllValidUrlsMGGK ;

##
wc -l $FilesUrlsWPcontent ;
wc -l $AllValidUrlsMGGK ;
##################################################################################
##################################################################################


## OUTPUT FILE CREATED AT (+ initializing the output file):
echo "<pre>" > $FILE_OUTPUT_SITESTATS
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS
echo "## MGGK Site Statistics last updated at:" >> $FILE_OUTPUT_SITESTATS
echo "## $(date)" >> $FILE_OUTPUT_SITESTATS
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS

################################################################################ 
## FINDING ALL DUPLICATE MD FILES WITH SAME URL
echo "" >> $FILE_OUTPUT_SITESTATS ;
echo "##---------------------------------------"  >> $FILE_OUTPUT_SITESTATS ;
echo ">> FINDING DUPLICATE MD FILES WITH SAME URL (AS COUNT, URL)" >> $FILE_OUTPUT_SITESTATS ;
grep -irh "^url: " $HUGO_CONTENT_DIR/* | sort | uniq -d | uniq -c >> $FILE_OUTPUT_SITESTATS
echo "" >> $FILE_OUTPUT_SITESTATS ;
echo ">> If the above block is empty, means no duplicates found." >> $FILE_OUTPUT_SITESTATS ;
echo "##---------------------------------------"  >> $FILE_OUTPUT_SITESTATS ;
echo "" >> $FILE_OUTPUT_SITESTATS ;
################################################################################ 

################################################################################ 
## COMPARING THE NUMBER OF STEPS IMAGES TO ACTUAL STEPS IN MDFILES
echo "" >> $FILE_OUTPUT_SITESTATS ;
echo "##---------------------------------------"  >> $FILE_OUTPUT_SITESTATS ;
echo ">> COMPARING THE NUMBER OF STEPS IMAGES TO ACTUAL STEPS IN MDFILES" >> $FILE_OUTPUT_SITESTATS ;
echo "##-------------------"  >> $FILE_OUTPUT_SITESTATS ;
cat $DIR_DROPBOX_SCRIPTS_OUTPUT/mggk_summary_10b-mggk-create-index-for-recipe-steps-present-folder.txt >> $FILE_OUTPUT_SITESTATS ;
echo "##---------------------------------------"  >> $FILE_OUTPUT_SITESTATS ;
echo "" >> $FILE_OUTPUT_SITESTATS ;
################################################################################ 


################################################################################ 
## CHECKING IF RECIPE_STEPS_FOLDERS ARE SAME AS URLS ...
tmpfile1="$DIR_Y/tmp1000.txt" ;
tmpfile2="$DIR_Y/tmp1001.txt" ;
##
for x in $(grep -irl preptime $REPO_MGGK/content/**) ; do grep -i 'url: ' $x ;  done | sed 's/url: //g' | sed 's+/++g' | sort > $tmpfile1 ;
##
DIR_STEPS_IMAGES="$REPO_MGGK/static/wp-content/recipe-steps-images" ;
replace_this1="/Users/abhishek/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/wp-content/recipe-steps-images/" ;
replace_this2="/home/ubuntu/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/wp-content/recipe-steps-images/" ;
## Changing the username to the be the same on all computers ...
fd . -t d --full-path $DIR_STEPS_IMAGES | sed "s+$replace_this1++g" | sed "s+$replace_this2++g" | sort > $tmpfile2 ;
##
echo "" >> $FILE_OUTPUT_SITESTATS ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $FILE_OUTPUT_SITESTATS
echo ">> CHECKING IF RECIPE_STEPS_FOLDERS ARE SAME AS URLS ... (ideally diff should be blank)" >> $FILE_OUTPUT_SITESTATS
echo ">>>>  left-file = all_urls // right-file = recipe_steps_folder names " >> $FILE_OUTPUT_SITESTATS
diff $tmpfile1 $tmpfile2 >> $FILE_OUTPUT_SITESTATS
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $FILE_OUTPUT_SITESTATS
echo "" >> $FILE_OUTPUT_SITESTATS ;
################################################################################ 
################################################################################ 

################################################################################ 
## CHECKING IF FILES AND DIRECTORIES IN RECIPE_STEPS_IMAGES HAVE
## ANY UPPERCASE LETTERS (bcoz they are not allowed)...
tmpfile1="$DIR_Y/tmp999.txt" ;
##
DIR_STEPS_IMAGES="$REPO_MGGK/static/wp-content/recipe-steps-images" ;
replace_this1="/Users/abhishek/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/wp-content/recipe-steps-images/" ;
replace_this2="/home/ubuntu/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/wp-content/recipe-steps-images/" ;
##
fd . --full-path $DIR_STEPS_IMAGES | sed "s+$replace_this1++g" | sed "s+$replace_this2++g" | grep '[A-Z]' > $tmpfile1 ;
##
echo "" >> $FILE_OUTPUT_SITESTATS ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $FILE_OUTPUT_SITESTATS
echo ">> PRINTING IF FILES AND DIRECTORIES IN RECIPE_STEPS_IMAGES HAVE ANY UPPERCASE LETTERS (bcoz they are not allowed)..." >> $FILE_OUTPUT_SITESTATS ;
cat $tmpfile1 >> $FILE_OUTPUT_SITESTATS ;
echo "" >> $FILE_OUTPUT_SITESTATS ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $FILE_OUTPUT_SITESTATS
echo "" >> $FILE_OUTPUT_SITESTATS ;
################################################################################ 
################################################################################ 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $FILE_OUTPUT_SITESTATS
echo ">> LIST OF MD FILES WITH VALID YOUTUBE ID BUT WITH STEPS IMAGES PRESENT = NO" >> $FILE_OUTPUT_SITESTATS
echo "" >> $FILE_OUTPUT_SITESTATS
for x in $(grep -irl youtube_video_id $REPO_MGGK/content ) ; do grep -il 'steps_images_present: "no"' $x ; done | nl >> $FILE_OUTPUT_SITESTATS
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $FILE_OUTPUT_SITESTATS
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


echo "" >> $FILE_OUTPUT_SITESTATS
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS
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

## NUMBER OF POSTS WITH FIRST_PUBLISHED_ON DATETIME VALUE
NUM_FIRST_PUBLISHED_ON_POSTS=$(grep -irl '^first_published_on:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_FIRST_PUBLISHED_ON_POSTS: NUMBER OF POSTS WITH FIRST_PUBLISHED_ON DATETIME VALUE" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH URL TAGS
NUM_URL_POSTS=$(grep -irl '^url:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_URL_POSTS: NUMBER OF POSTS WITH URL TAGS" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH YOAST_DESCIPTION
NUM_YOAST_DESCIPTION_POSTS=$(grep -irl 'yoast_description:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_YOAST_DESCIPTION_POSTS: NUMBER OF POSTS WITH YOAST_DESCIPTION" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH FEATURED_IMAGE
NUM_FEATURED_IMAGE_POSTS=$(grep -irh 'featured_image:' $HUGO_CONTENT_DIR/* | wc -l)
echo "$NUM_FEATURED_IMAGE_POSTS: NUMBER OF POSTS WITH FEATURED_IMAGE" >> $FILE_OUTPUT_SITESTATS

################################################################################
## NUMBER OF CURRENT IMAGES PRESENT IN 1x1 DIRECTORY
NUM_CURRENT_1x1_IMAGES=$(ls $DIR_HUGO_MAIN/static/wp-content/rich-markup-images/1x1/*.jpg | wc -l)
echo "$NUM_CURRENT_1x1_IMAGES: NUMBER OF CURRENT IMAGES PRESENT IN 1x1 DIRECTORY" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF CURRENT IMAGES PRESENT IN 4x3 DIRECTORY
NUM_CURRENT_4x3_IMAGES=$(ls $DIR_HUGO_MAIN/static/wp-content/rich-markup-images/4x3/*.jpg | wc -l)
echo "$NUM_CURRENT_4x3_IMAGES: NUMBER OF CURRENT IMAGES PRESENT IN 4x3 DIRECTORY" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF CURRENT IMAGES PRESENT IN 16x9 DIRECTORY
NUM_CURRENT_16x9_IMAGES=$(ls $DIR_HUGO_MAIN/static/wp-content/rich-markup-images/16x9/*.jpg | wc -l)
echo "$NUM_CURRENT_16x9_IMAGES: NUMBER OF CURRENT IMAGES PRESENT IN 16x9 DIRECTORY" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF CURRENT IMAGES PRESENT IN ORIGINAL_COPIED DIRECTORY
NUM_CURRENT_ORIGINAL_COPIED_IMAGES=$(ls $DIR_HUGO_MAIN/static/wp-content/rich-markup-images/original_copied/*.* | wc -l)
echo "$NUM_CURRENT_ORIGINAL_COPIED_IMAGES: NUMBER OF CURRENT IMAGES PRESENT IN original_copied DIRECTORY" >> $FILE_OUTPUT_SITESTATS
################################################################################

## NUMBER OF POSTS WITH CATEGORIES
NUM_CATEGORIES_POSTS=$(grep -irl '^categories:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_CATEGORIES_POSTS: NUMBER OF POSTS WITH CATEGORIES" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH TAGS
NUM_TAGS_POSTS=$(grep -irl '^tags:' $HUGO_CONTENT_DIR/* |wc -l)
echo "$NUM_TAGS_POSTS: NUMBER OF POSTS WITH TAGS" >> $FILE_OUTPUT_SITESTATS

################################################################################
## NUMBER OF POSTS WITH VAR prepTime + recipeIngredient + recipeInstructions + recipeNotes
MGGK_VAR_prepTime=$(grep -irl 'prepTime' $HUGO_CONTENT_DIR/* | wc -l)
MGGK_VAR_recipeIngredient=$(grep -irl 'recipeIngredient' $HUGO_CONTENT_DIR/* | wc -l)
MGGK_VAR_recipeInstructions=$(grep -irl 'recipeInstructions' $HUGO_CONTENT_DIR/* | wc -l)
MGGK_VAR_recipeNotes=$(grep -irl 'recipeNotes' $HUGO_CONTENT_DIR/* | wc -l)

echo "$MGGK_VAR_prepTime: NUMBER OF POSTS WITH VAR prepTime" >> $FILE_OUTPUT_SITESTATS
echo "$MGGK_VAR_recipeIngredient: NUMBER OF POSTS WITH VAR recipeIngredient" >> $FILE_OUTPUT_SITESTATS
echo "$MGGK_VAR_recipeInstructions: NUMBER OF POSTS WITH VAR recipeInstructions" >> $FILE_OUTPUT_SITESTATS
echo "$MGGK_VAR_recipeNotes: NUMBER OF POSTS WITH VAR recipeNotes" >> $FILE_OUTPUT_SITESTATS
################################################################################

## NUMBER OF POSTS WITH YOUTUBE_VIDEO_ID
NUM_YOUTUBE_VIDEO_ID_POSTS=$(grep -irh 'youtube_video_id:' $HUGO_CONTENT_DIR/* | wc -l)
echo "$NUM_YOUTUBE_VIDEO_ID_POSTS: NUMBER OF POSTS WITH YOUTUBE_VIDEO_ID" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF CURRENT YOUTUBE COVER IMAGES PRESENT IN LOCAL DIRECTORY
NUM_CURRENT_YOUTUBE_COVER_IMAGES=$(cat "$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/video-cover-images-current.txt" | wc -l)
echo "$NUM_CURRENT_YOUTUBE_COVER_IMAGES: NUMBER OF CURRENT YOUTUBE COVER IMAGES PRESENT" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH MGGK_RECIPE_HERE_BUTTON_BLOCKS
MGGK_RECIPE_HERE_BUTTON_BLOCKS=$(grep -irh '{{< mggk-button-block-for-recipe-here-link >}}' $HUGO_CONTENT_DIR/* | wc -l)
echo "$MGGK_RECIPE_HERE_BUTTON_BLOCKS: NUMBER OF POSTS WITH MGGK_RECIPE_HERE_BUTTON_BLOCKS" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH steps_images_present: "yes"
MGGK_steps_images_present_YES=$(grep -irl 'steps_images_present: "yes"' $HUGO_CONTENT_DIR/* | sort | uniq | wc -l)
echo "$MGGK_steps_images_present_YES: NUMBER OF POSTS WITH steps_images_present = yes" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH steps_images_present: "no"
MGGK_steps_images_present_NO=$(grep -irl 'steps_images_present: "no"' $HUGO_CONTENT_DIR/* | sort | uniq | wc -l)
echo "$MGGK_steps_images_present_NO: NUMBER OF POSTS WITH steps_images_present = no" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH steps_images_present: "no" // BUT WITH VALID YOUTUBE IDs
MGGK_steps_images_present_NO_valid_youtube_id=$(for x in $(grep -irl youtube_video_id $REPO_MGGK/content) ; do grep -il 'steps_images_present: "no"' $x ; done | sort | uniq | wc -l)
echo "$MGGK_steps_images_present_NO_valid_youtube_id: NUMBER OF POSTS WITH steps_images_present = no // BUT WITH VALID YOUTUBE IDs" >> $FILE_OUTPUT_SITESTATS

## NUMBER OF POSTS WITH MGGK_JSON_RECIPE BLOCK
NUM_MGGK_JSON_RECIPE_POSTS=$(grep -irh 'mggk_json_recipe:' $HUGO_CONTENT_DIR/* | wc -l)
echo "$NUM_MGGK_JSON_RECIPE_POSTS: NUMBER OF POSTS WITH MGGK_JSON_RECIPE BLOCK" >> $FILE_OUTPUT_SITESTATS

################################################################################
echo "##------------------------------------------------------------------------------" >> $FILE_OUTPUT_SITESTATS 
echo ">> FINDING WHICH URLS ARE NOT PRESENT AS VALID IMAGES IN 1X1, 4X3, 16X9 DIRECTORIES ..." >> $FILE_OUTPUT_SITESTATS
echo ">> ... OR IF ANY INVALID IMAGES ARE PRESENT IN 1X1, 4X3, 16X9 DIRECTORIES WHICH ..." >> $FILE_OUTPUT_SITESTATS
echo ">> ... DO NOT HAVE CORRESPONDING VALID URLS." >> $FILE_OUTPUT_SITESTATS
echo "##------------------------------------------------------------------------------" >> $FILE_OUTPUT_SITESTATS
################################################################################
####
DIR_ALL_URLS="$DIR_HUGO_MAIN/content" ;
DIR_ORIG_COPIED="$DIR_HUGO_MAIN/static/wp-content/rich-markup-images/original_copied" ;
DIR_1x1="$DIR_HUGO_MAIN/static/wp-content/rich-markup-images/1x1" ;
DIR_4x3="$DIR_HUGO_MAIN/static/wp-content/rich-markup-images/4x3" ;
DIR_16x9="$DIR_HUGO_MAIN/static/wp-content/rich-markup-images/16x9" ;
####
FILE_ALL_URLS="$DIR_OUTPUT/_tmplist_ALL_URLS.txt" ;
FILE_ORIG_COPIED="$DIR_OUTPUT/_tmplist_00_ORIG_COPIED.txt" ;
FILE_1x1="$DIR_OUTPUT/_tmplist_1x1.txt" ;
FILE_4x3="$DIR_OUTPUT/_tmplist_4x3.txt" ;
FILE_16x9="$DIR_OUTPUT/_tmplist_16x9.txt" ;
####
rm $DIR_OUTPUT/_tmplist*.txt ; ## removing existing temporary files
####
## Getting all names from jpg images
ls $DIR_ORIG_COPIED/ | tr -d ' ' | sed 's/.jpg//g' | sort > $FILE_ORIG_COPIED
ls $DIR_1x1/ | tr -d ' ' | sed 's/1x1-//g' | sed 's/.jpg//g'  | sort > $FILE_1x1
ls $DIR_4x3/ | tr -d ' ' | sed 's/4x3-//g' | sed 's/.jpg//g' | sort > $FILE_4x3
ls $DIR_16x9/ | tr -d ' ' | sed 's/16x9-//g' | sed 's/.jpg//g'  | sort > $FILE_16x9

## Getting all urls in hugo main directory
TMPFILE1="$DIR_OUTPUT/_tmp1.txt" ;
TMPFILE2="$DIR_OUTPUT/_tmp2.txt" ;
grep -irh 'url: ' $DIR_ALL_URLS/*  | grep -v '"' | tr -d ' ' | sed 's/url://g'| sed 's+/++g' | sort > $TMPFILE1 ;
## Adding 'index' word to compensate for the base site url which only contained slashes, hence came out blank.
echo "index" > $TMPFILE2 ;
cat $TMPFILE1 $TMPFILE2 | sort > $FILE_ALL_URLS

## Counting lines in all _tmplist files
wc -l $DIR_OUTPUT/_tmplist*.txt >> $FILE_OUTPUT_SITESTATS

## Finding which urls are not present as valid images
FILENAME_ARRAY=("$FILE_ORIG_COPIED" "$FILE_1x1" "$FILE_4x3" "$FILE_16x9") ;
for x in ${FILENAME_ARRAY[@]} ; do 
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $FILE_OUTPUT_SITESTATS
    echo ">> CURRENTLY COMPARING => $FILE_ALL_URLS -- AND -- $x" >> $FILE_OUTPUT_SITESTATS
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $FILE_OUTPUT_SITESTATS
    echo "" >> $FILE_OUTPUT_SITESTATS
    diff $FILE_ALL_URLS $x >> $FILE_OUTPUT_SITESTATS
done
################################################################################
################################################################################

##------------------------------------------------------------------------------
## LIST OF ALL URLS FOUND IN MD FILES
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS
LIST_OF_ALL_URLS=$(grep -irh '^url: ' $HUGO_CONTENT_DIR/* | sort| nl)
echo "" >> $FILE_OUTPUT_SITESTATS
echo "LIST OF ALL URLS FOUND IN MD FILES:" >> $FILE_OUTPUT_SITESTATS
echo "$LIST_OF_ALL_URLS" >> $FILE_OUTPUT_SITESTATS
##------------------------------------------------------------------------------

## NUMBER OF POSTS BY FIRST_PUBLISHING_YEAR
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS
NUMBER_OF_POSTS_BY_FIRST_PUBLISHING_YEAR=$(grep -irh '^first_published_on: ' $HUGO_CONTENT_DIR/* | sed 's/first_published_on: //g' | cut -c1-4 | sort | uniq -c | awk '{print  }')
echo "" >> $FILE_OUTPUT_SITESTATS
echo "NUMBER OF POSTS BY FIRST_PUBLISHING_YEAR:" >> $FILE_OUTPUT_SITESTATS
echo "$NUMBER_OF_POSTS_BY_FIRST_PUBLISHING_YEAR" >> $FILE_OUTPUT_SITESTATS

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

## NUMBER OF WORDS IN ALL MD FILES WITH THEIR FULL PATHS
function FIND_NUMBER_OF_WORDS_IN_ALL_MD_FILES () { 
    echo;
    echo "################################################################################" ;
    echo ">> FINDING NUMBER OF WORDS IN ALL MD FILES: " ;
    echo "################################################################################" ;
    for mydir in $(fd . $REPO_MGGK/content/ -t d) ; do 
        echo "========================================" ; 
        echo ">> DIRECTORY ==> $mydir" ; 
        echo "========================================" ; 
        #find $mydir/ -name "*.md" -exec wc -w {} \;  | sort -n ; 
        for x in $(fd . $mydir/ -t f --exact-depth 1) ; do wc -w $x ; done | sort -n ;
    done
}
FIND_NUMBER_OF_WORDS_IN_ALL_MD_FILES >> $FILE_OUTPUT_SITESTATS

##------------------------------------------------------------------------------
echo "################################################################################" >> $FILE_OUTPUT_SITESTATS

##------------------------------------------------------------------------------
## COUNT AND PRINT THE NUMBER OF FILES (IMAGES) PRESENT IN recipe-steps-images DIRECTORY ...
echo " " >> $FILE_OUTPUT_SITESTATS
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $FILE_OUTPUT_SITESTATS
echo "## COUNT AND PRINT THE NUMBER OF FILES (IMAGES) PRESENT IN recipe-steps-images DIRECTORY ..." >> $FILE_OUTPUT_SITESTATS
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $FILE_OUTPUT_SITESTATS
DIR_FOR_COUNT="$REPO_MGGK/static/wp-content/recipe-steps-images"
bash $REPO_SCRIPTS/999-count-number-of-files-in-directories-recursively.sh $DIR_FOR_COUNT | sed 's+/Users/abhishek/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/wp-content/recipe-steps-images+\.+g' >> $FILE_OUTPUT_SITESTATS
##------------------------------------------------------------------------------


echo "################################################################################" >> $FILE_OUTPUT_SITESTATS
echo "</pre>" >> $FILE_OUTPUT_SITESTATS

##################################################################################
cat $FILE_OUTPUT_SITESTATS | sed -e 's/abhishek/USERNAME/g' -e 's/ubuntu/USERNAME/g' > $FILE_OUTPUT_SITESTATS_FINAL
##################################################################################
echo;
echo ">> SUMMARY >> " ;
echo ">> STATISTICS FILE SAVED AS => $FILE_OUTPUT_SITESTATS_FINAL" ;
## COPY this file to Dropbox dir
cp $FILE_OUTPUT_SITESTATS_FINAL $DIR_DROPBOX_SCRIPTS_OUTPUT/

## Listing word counts for files in dropbox dir
#echo;
#echo ">> Listing word counts for files in dropbox dir ..." ; 
#fd --search-path="$DIR_DROPBOX_SCRIPTS_OUTPUT/" -x wc -l {} ;


