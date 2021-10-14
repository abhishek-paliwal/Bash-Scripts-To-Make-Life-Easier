#! /bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ##################################################################################
    ## CREATE LeelasRecipes HUGO recipe file with frontmatter inserted.
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
BASEDIR="$REPO_LEELA/content" ;
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
No notes.
##end_notes" > $RECIPE_TEMPLATE ;
    ## EXIT THIS SCRIPT IN THIS CASE
    $EDITOR $RECIPE_TEMPLATE ## Open this file in current editor
    exit 1 ;
fi

##
## Using the power of sed to find all text between two phrases
echo ">> Dumping all text found between the required headings" ;
sed -n "/##begin_recipename/,/##end_recipename/p" $REQUIREMENTS_FILE | grep -v '#' | grep -v '^$' > $REQUIREMENTS_FILE_BASENAME-recipename.txt
sed -n "/##begin_ingredients/,/##end_ingredients/p" $REQUIREMENTS_FILE | grep -v '#' | grep -v '^$' | sd '\* ' '' | sd '^\d*. ' '' > $REQUIREMENTS_FILE_BASENAME-ingredients.txt
sed -n "/##begin_instructions/,/##end_instructions/p" $REQUIREMENTS_FILE | grep -v '#' | grep -v '^$' | sd '\* ' '' | sd '^\d*. ' '' > $REQUIREMENTS_FILE_BASENAME-instructions.txt
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


FRONTMATTER_HEADER="---
my_custom_variable: \"custom_variable_value\"
steps_images_present: \"no\"

title: \"$CLIPBOARD\"

date: $DATE

description: \"POST_DESCRIPTION\"

type: post

image: \"images/youtube_video_cover_images/YOUTUBE_ID.jpg\"

url: /$(printf '%s' "$URL")/

youtube_video_id: \"YOUTUBE_ID\"

categories: 
  - \"Breakfast\"

tags:
  - \"Vegetarian\"

prepTime: PT0H0M
cookTime: PT0H0M
totalTime: PT0H0M

recipeCategory: Breakfast
recipeCuisine: Indian
recipeYield: 4

aggregateRating:
  ratingValue: 4.9
  ratingCount: 4

nutrition:
  calories: XYZ calories
  servingSize: 1

recipe_keywords: \"$CLIPBOARD\"

" ;

FRONTMATTER_FOOTER="---

{{< leelasrecipes-button-block-for-recipe-here-link >}}

LONG_TEXT_HERE

> LONG_TEXT_HERE

{{< figure src=\"https://www.leelasrecipes.com/images/masonary-post/2021/$URL-1.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.leelasrecipes.com/images/masonary-post/2021/$URL-2.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.leelasrecipes.com/images/masonary-post/2021/$URL-3.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< leelasrecipes-INSERT-RECIPE-HTML-BLOCK >}}

" ;

printf '%s' "$FRONTMATTER_HEADER" ;
FORMAT_INGREDIENTS
FORMAT_INSTRUCTIONS
FORMAT_NOTES
printf '%s' "$FRONTMATTER_FOOTER" ;

##################################################################################
## FINAL WRITING TO FILE, AND OPENING FILE IN CODE EDITOR
##################################################################################
FILENAME="$BASEDIR/$(date +%Y%m%d-%H%M%S)-frontl-generated-recipe.md" 
printf '%s' "$FRONTMATTER_HEADER" > $FILENAME
FORMAT_INGREDIENTS >> $FILENAME
FORMAT_INSTRUCTIONS >> $FILENAME
FORMAT_NOTES >> $FILENAME
printf '%s' "$FRONTMATTER_FOOTER" >> $FILENAME

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## FINAL FUNCTION TO CREATE ALL RECIPE PLACEHOLDER IMAGES
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
create_placeholder_images_for_recipe () 
{
    recipeName=$(printf '%s' "$URL") ;
    myDir="$DIR_Y" ;
    echo; echo ">>>> BEGIN TASK: CREATING PLACEHOLDER IMAGES (for recipe = $recipeName) IN DIR (= $myDir) ..." ; 

    ## creating 3 recipe images 
    for x in $(seq 1 1 3); do convert -size 1200x100 canvas:orange "$myDir/${recipeName}-$x.jpg" ; done ; 
    
    ## creating 20 steps images
    myDir_steps="$DIR_Y/${recipeName}" ;
    mkdir -p "$myDir_steps" ;
    for x in $(seq 1 1 20); do convert -size 1200x100 canvas:pink "$myDir_steps/${recipeName}-step-1-$x.jpg" ; done ; 
    
    ## creating 4 markup images => orig, 1x1,16x9,4x3
    im_orig="$myDir/${recipeName}.jpg" ; convert -size 1200x1200 canvas:lime $im_orig ;
    im1x1="$myDir/1x1-${recipeName}.jpg" ; convert -size 1200x1200 canvas:lime $im1x1 ;
    im4x3="$myDir/4x3-${recipeName}.jpg" ; convert -size 1200x900 canvas:lime $im4x3 ;
    im16x9="$myDir/16x9-${recipeName}.jpg" ; convert -size 1200x675 canvas:lime $im16x9 ;
    
    ## creating youtube cover image
    im_youtube="$REPO_LEELA/static/images/youtube_video_cover_images/YOUTUBE_ID.jpg" ;
    convert -size 1200x675 canvas:yellow $im_youtube ;
    
    ## Final MESSAGE printout about moving markup images to respective dirs  
    dirMarkUp="$REPO_LEELA/static/rich-markup-images" ;
    echo "  >> REMAINING TASKS FOR YOU ... " ; 
    echo "    >> TASK 1 = Move steps images to steps directory." ; 
    echo "    >> TASK 2 = Move recipe images to main images directory." ; 
    echo "    >> TASK 3 = Copy-paste the following to move markup images ..." ; 
    echo "mv $im_orig $dirMarkUp/original_copied/" ;
    echo "mv $im1x1 $dirMarkUp/1x1/" ;
    echo "mv $im4x3 $dirMarkUp/4x3/" ;
    echo "mv $im16x9 $dirMarkUp/16x9/" ;

    ## FINAL LINE
    echo; echo ">>>> END TASK: CREATING BLANK IMAGES (for recipe = $recipeName) IN DIR (= $myDir) ..." ; 
}
## CALL THIS FUNCTION
create_placeholder_images_for_recipe
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Opening markdown file in editor
echo "Opening markdown file in editor ..." ;
code $FILENAME ;
