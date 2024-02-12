#! /bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ##################################################################################
    ## CREATE MGGK HUGO recipe file with frontmatter inserted.
    ## IMPORTANT NOTE: This script needs a user input at runtime.
    ##################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


##################################################################################

##
PWD="$DIR_Y" ;
WORKDIR="$DIR_Y" ; 
BASEDIR="$DIR_GITHUB/ZZ-HUGO-TEST/content/blog"
cd $PWD ;
echo ">>>> Current working directory is: $PWD" ;
##################################################################################


##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
RECIPE_TEMPLATE="$PWD/my-recipe-template.txt" ;
REQUIREMENTS_FILE="$RECIPE_TEMPLATE" ;  ## first text file
REQUIREMENTS_FILE_BASENAME="$(basename $REQUIREMENTS_FILE)" ; 

## CHECK WHETHER THE REQUIRED RECIPE TEMPLATE FILE ALREADY EXISTS
## IF NOT, AUTOMATICALLY CREATE IT.
echo;
if [ -f "$RECIPE_TEMPLATE" ]; then
    echo ">> SUCCESS: RECIPE TEMPLATE FILE EXISTS => $RECIPE_TEMPLATE"
else
    echo ">> FAILURE: RECIPE TEMPLATE FILE DOES NOT EXIST. IT HAS BEEN CREATED FOR YOU." ;
    echo ">>>> NEXT STEP: Edit this file with your TEXT CONTENT and LINKS, then run this program again. => $RECIPE_TEMPLATE" ;

    ##################################################################################
    echo ">>>> IMPORTANT NOTE: This script needs a user input to run."
    echo "##------------------------------------------------------------------------------" ;
    echo ">> Enter the name of the recipe (in Title Case)"
    read RECIPE_NAME_VAR ;

## (KEEP THIS BLOCK UNINDENTED) CREATING AN EMPTY RECIPE TEMPLATE TO BE FILLED IN
echo "##begin_recipename
$RECIPE_NAME_VAR
##end_recipename

##begin_ingredients
!!For $RECIPE_NAME_VAR
INGREDIENT_1
INGREDIENT_2
##end_ingredients

##begin_instructions
!!For making $RECIPE_NAME_VAR
INSTRUCTION_1
INSTRUCTION_2
!!THIS IS ANOTHER HEADING
INSTRUCTION_1
INSTRUCTION_2
##end_instructions

##begin_notes
THIS_IS_NOTES_TEXT.
##end_notes" > $RECIPE_TEMPLATE ;
    ## EXIT THIS SCRIPT IN THIS CASE
    $EDITOR $RECIPE_TEMPLATE ## Open this file in current editor
    exit 1 ;
fi

##
## Using the power of sed to find all text between two phrases
echo ">> Dumping all text found between the required headings" ;
sed -n "/##begin_recipename/,/##end_recipename/p" $REQUIREMENTS_FILE | grep -v '#' | grep -v '^$' > $REQUIREMENTS_FILE_BASENAME-recipename.txt
sed -n "/##begin_ingredients/,/##end_ingredients/p" $REQUIREMENTS_FILE | grep -v '#' | grep -v '^$' > $REQUIREMENTS_FILE_BASENAME-ingredients.txt
sed -n "/##begin_instructions/,/##end_instructions/p" $REQUIREMENTS_FILE | grep -v '#' | grep -v '^$' > $REQUIREMENTS_FILE_BASENAME-instructions.txt
sed -n "/##begin_notes/,/##end_notes/p" $REQUIREMENTS_FILE | grep -v '#' | grep -v '^$' > $REQUIREMENTS_FILE_BASENAME-notes.txt
###############################################################################

############################################################
############## BEGIN: FORMATTING FUNCTIONS #################
############################################################
## RECIPE INGREDIENTS
function FORMAT_INGREDIENTS () {
echo "recipeIngredient:" ;
while IFS= read line ;
do
  if [[ "$line" == *"!!"* ]] ; then
    ## MEANING IT IS A RECIPE SECTION HEADING LINE
    ## step 1: remove !! from these lines
    line=$(echo "$line" | sed 's/!!//g') ;
    ## step 2: printing to stdout
    echo "  - recipeIngredientTitle: \"$line\"
    recipeIngredientList:" ;
  else
    ## FOR ANY OTHER LINE WHICH IS NOT HEADING
    echo "    - \"$line\" " ;
  fi
done <"$REQUIREMENTS_FILE_BASENAME-ingredients.txt"
echo;
}
############################################################
## RECIPE INSTRUCTIONS
function FORMAT_INSTRUCTIONS () {
echo "recipeInstructions:" ;
while IFS= read line ;
do
  if [[ "$line" == *"!!"* ]] ; then
    ## MEANING IT IS A RECIPE SECTION HEADING LINE
    ## step 1: remove !! from these lines
    line=$(echo "$line" | sed 's/!!//g') ;
    ## step 2: printing to stdout
    echo "  - recipeInstructionsTitle: \"$line\"
    recipeInstructionsList:" ;
  else
    ## FOR ANY OTHER LINE WHICH IS NOT HEADING
    echo "    - \"$line\" " ;
  fi
done <"$REQUIREMENTS_FILE_BASENAME-instructions.txt"
echo;
}
############################################################
## RECIPE NOTES
function FORMAT_NOTES () {
echo "recipeNotes:" ;
while IFS= read line ;
do
    ## FOR ANY LINE
    echo "  - \"$line\" " ;
done <"$REQUIREMENTS_FILE_BASENAME-notes.txt"
echo;
}
############################################################
############## END: FORMATTING FUNCTIONS ###################
############################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

if [ "$(uname)" == "Linux" ] ; then 
    DATE=$(date -d '12 hour ago' +%Y-%m-%dT%H:%M:%S) ;
else
    DATE=$(date -v -12H +%Y-%m-%dT%H:%M:%S) ;
fi 

PUBDATE=$DATE ;

YEAR=$(date +%Y)
MONTH=$(date +%m)

## CREATE A NEW VARIABLE FROM RECIPE NAME FILE
CLIPBOARD=$(cat "$REQUIREMENTS_FILE_BASENAME-recipename.txt" | sed 's/^$//g') ;

# Converting to all lowercase and removing all the strange characters with hyphens
URL=$(echo "$CLIPBOARD" | awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1' | sed -e 's/[{}\,! ()\-]/_/g' | sed -e 's/__*/-/g' | tr 'A-Z' 'a-z')

## GETTING ALL RECIPE CATEGORIES AND CUISINES
TMPFILE_RECIPECATEGORIES="$WORKDIR/_tmp_recipecategories_all.txt" ;
TMPFILE_RECIPECUISINES="$WORKDIR/_tmp_recipecuisines_all.txt" ;
grep -irh 'recipecategory:' "$REPO_MGGK/content/allrecipes" | sort -u > "$TMPFILE_RECIPECATEGORIES" ; 
grep -irh 'recipecuisine:' "$REPO_MGGK/content/allrecipes" | sort -u > "$TMPFILE_RECIPECUISINES" ; 

## GETTING ALL EXISTING CATEGORIES AND TAGS
MGGK_DATAFILE_FROM_ENVVAR="$CSV_MGGK_DATA" ; 
TMPFILE_CATEGORIES="$WORKDIR/_tmp_categories_all.txt" ;
TMPFILE_TAGS="$WORKDIR/_tmp_tags_all.txt" ;
mlr --csv cut -f categories "$MGGK_DATAFILE_FROM_ENVVAR" | sd '"' '' | sd ',' '\n'  | tr '[:upper:]' '[:lower:]' | sort | uniq | sd '^' '  - ' > "$TMPFILE_CATEGORIES" ; 
mlr --csv cut -f tags "$MGGK_DATAFILE_FROM_ENVVAR" | sd '"' '' | sd ',' '\n'  | tr '[:upper:]' '[:lower:]' | sort | uniq | sd '^' '  - ' >  "$TMPFILE_TAGS" ; 


##
FRONTMATTER_HEADER="---
toc: true

seo_title_value: \"$CLIPBOARD\"

my_custom_variable: \"custom_variable_value\"

steps_images_present: \"no\"

title: \"$CLIPBOARD\"

author: Anupama Paliwal

type: post

date: $DATE
first_published_on: $DATE

url: /$(printf '%s' "$URL")/

featured_image: /wp-content/uploads/$YEAR/$MONTH/YOUR-IMAGE.JPG

recipe_code_image: /wp-content/uploads/$YEAR/$MONTH/YOUR-IMAGE.JPG

categories:
  - 
$(cat $TMPFILE_CATEGORIES)

tags:
  - 
$(cat $TMPFILE_TAGS)
  -

youtube_video_id: \"YOUTUBE_ID\"

yoast_description: \"YOAST_DESCRIPTION\"

prepTime: PTHM
cookTime: PTHM
totalTime: PTHM

recipeCategory: xyz
$(cat $TMPFILE_RECIPECATEGORIES)

recipeCuisine: xyz
$(cat $TMPFILE_RECIPECUISINES)

recipeYield: xyz xyz

aggregateRating:
  ratingValue: 4.9
  ratingCount: 5

nutrition:
  calories: xyz calories
  servingSize: 1

recipe_keywords: \"$CLIPBOARD\"

" ;

  
FRONTMATTER_FOOTER="---

<!--more-->

{{< mggk-INSERT-COOKING-TIP-OF-THE-DAY-IN-POST >}}

{{< mggk-hugo-google-ad-1 >}}

{{< mggk-hugo-google-ad-2 >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-recipe-1.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-recipe-2.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$UURL-recipe-3.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-recipe-4.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-recipe-5.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-recipe-6.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< mggk-INSERT-RECIPE-STEP-BY-STEP-IMAGES-BLOCK >}}

{{< mggk-print-recipe-button >}}

{{< mggk-INSERT-RECIPE-HTML-BLOCK >}}

{{< mggk-GET-RELATED-POSTS-FOR-THESE-URLS urls=\"https://www.mygingergarlickitchen.com/test-no-video/ https://www.mygingergarlickitchen.com/my-books/ https://www.mygingergarlickitchen.com/avocado-salad/\" >}}


" ;

printf '%s' "$FRONTMATTER_HEADER" ;
FORMAT_INGREDIENTS
FORMAT_INSTRUCTIONS
FORMAT_NOTES
printf '%s' "$FRONTMATTER_FOOTER" ;

##################################################################################
## FINAL WRITING TO FILE, AND OPENING FILE IN CODE EDITOR
##################################################################################
FILENAME="$BASEDIR/$(date +%Y%m%d-%H%M%S)-frontm-generated-recipe.md" 
printf '%s' "$FRONTMATTER_HEADER" > $FILENAME
FORMAT_INGREDIENTS >> $FILENAME
FORMAT_INSTRUCTIONS >> $FILENAME
FORMAT_NOTES >> $FILENAME
printf '%s' "$FRONTMATTER_FOOTER" >> $FILENAME
##
code $FILENAME ;
