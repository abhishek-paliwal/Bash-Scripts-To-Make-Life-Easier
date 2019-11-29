#!/bin/bash
###############################################################################
THIS_FILENAME="599-mggk-create-recipe-yaml-template-file-from-user-input.sh" ;
###############################################################################
cat<<EOF
  ###############################################################################
  ## FILENAME: $THIS_FILENAME
  ## USAGE: sh $THIS_FILENAME
  ###############################################################################
  ## THIS PROGRAM CREATES A YAML RECIPE FILE FROM USER INPUT ON COMMAND PROMPT
  ###############################################################################
  ## CODED ON: MAY 02, 2019
  ## CODED BY: PALI
  ###############################################################################
EOF

###############################################################################

## SOME VARIABLES
MY_OUTPUT_DIR="$HOME/Desktop" ;
cd $MY_OUTPUT_DIR ;
##
PWD=$(pwd) ;
echo;
echo "Current working directory = $PWD" ;
echo;

## USER CONFIRMATION
read -p ">>>> If this working directory is OK, please press ENTER key to continue ..." ;
echo;

################################################################################

## ASKING FOR USER INPUTS ON COMMAND LINE
read -p "Enter RECIPE NAME: " RECIPE_NAME
read -p "Enter RECIPE DESCRIPTION: " RECIPE_DESCRIPTION
read -p "Enter YOTUBUE VIDEO ID: " YOUTUBE_ID
read -p "Enter FULL IMAGE URL: " RECIPE_IMAGE_URL
read -p "Enter FULL RECIPE URL: " RECIPE_URL
##
DATE_TODAY=$(date +%Y-%m-%d) ;

################################################################################
## CREATING YAML RECIPE FILENAME, BY REMOVING LEADING+TRAILING SPACES + SOME EXTRA UNNEEDED CHARS
## ALSO REPLACING REMAINING SPACES WITH HYPHENS
YAML_FILENAME_VAR="$(echo $RECIPE_NAME | tr '|' ' ' | tr '-' ' ' | awk '{$1=$1};1'  | tr ' ' '-' )" ;

DATE_FOR_FILENAME=$(date +%Y%m%d) ;
FILE_NAME_PREFIX="recipe-" ;
FILE_EXTENSION=".yaml" ;
YAML_FILENAME_FINAL=$(echo $FILE_NAME_PREFIX$DATE_FOR_FILENAME-$YAML_FILENAME_VAR$FILE_EXTENSION) ;

################################################################################

cat >$YAML_FILENAME_FINAL <<EOFFF
---
"@context": http://schema.org/

"@type": Recipe

name: "$RECIPE_NAME"

description: "$RECIPE_DESCRIPTION"

image:
  - $RECIPE_IMAGE_URL
  - https://www.mygingergarlickitchen.com/wp-content/youtube_video_cover_images/$YOUTUBE_ID.jpg

prepTime: PT40M
cookTime: PT25M
totalTime: PT1H5M
recipeCategory: Breakfast
recipeCuisine: Indian
recipeYield: 6-8

aggregateRating:
  "@type": AggregateRating
  ratingValue: '5'
  ratingCount: '1'

nutrition:
  "@type": NutritionInformation
  calories: 225 calories
  servingSize: 1 serving

author:
  "@type": Person
  name: Anupama Paliwal
  brand: My Ginger Garlic Kitchen
  url: http://www.MyGingerGarlicKitchen.com

recipeNotes: "SOME NOTES TEXT<br>SOME NOTES TEXT<br>SOME NOTES TEXT."

keywords: "KEYWORD 1, KEYWORD 2, KEYWORD 3"

video:
  "@type": videoObject
  name: "$RECIPE_NAME"
  description: "$RECIPE_DESCRIPTION"
  thumbnailUrl:
    - https://www.mygingergarlickitchen.com/wp-content/youtube_video_cover_images/$YOUTUBE_ID.jpg
    - $RECIPE_IMAGE_URL
  contentUrl: https://youtu.be/$YOUTUBE_ID
  embedUrl: https://www.youtube.com/embed/$YOUTUBE_ID
  uploadDate: "$DATE_TODAY"

datePublished: "$DATE_TODAY"

url: "$RECIPE_URL"

recipeIngredient:
  - "!!TITLE 1:"
  - ingredient
  - ingredient
   - "!!TITLE 2:"
  - ingredient
  - ingredient
  - ingredient

recipeInstructions:
- "@type": HowToSection
  name: TITLE 1 TITLE 1
  itemListElement:
  - '@type': HowToStep
    text: Sample instruction text
  - '@type': HowToStep
    text: Sample instruction text
- "@type": HowToSection
  name: TITLE 2 TITLE 2
  itemListElement:
  - '@type': HowToStep
    text: Sample instruction text
  - '@type': HowToStep
    text: Sample instruction text

EOFFF


###############################################################################
## Opening directory + yaml_output_file in atom
echo ">>>> Opening Present Working Directory ..." ;
echo ">>>> Opening in ATOM => YAML OUTPUT FILE = $YAML_FILENAME_FINAL " ;

open $PWD ;
atom $YAML_FILENAME_FINAL ;
