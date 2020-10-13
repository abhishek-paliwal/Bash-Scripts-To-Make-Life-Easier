#! /bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ##################################################################################
    ## Insert LeelasRecipes - HUGO frontmatter with proper dates
    ## IMPORTANT NOTE: This script needs a command line argument to run if the user is ubuntu.
    ##### Else, if run on MAC OS, it just takes its input from the last copied item from Clipboard.
    ##################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


##################################################################################

#BASEDIR="$HOME_WINDOWS/Desktop/Y"
BASEDIR="$DIR_GITHUB/2020-LEELA-RECIPES/content"

cd $BASEDIR

echo ">>>> Current working directory is: $BASEDIR" ;
echo ">>>> IMPORTANT NOTE: This script needs a command line argument to run." ;

DATE=$(date +%Y-%m-%dT%H:%M:%S)
PUBDATE=$(date +%Y-%m-%d)

YEAR=$(date +%Y)
MONTH=$(date +%m)

echo ">>>> IMPORTANT NOTE: This script needs a command line argument to run."

if [ "$USER" == "ubuntu" ] ; then
    CLIPBOARD=$(echo "$1" | sed 's/^$//g') ;
else 
    CLIPBOARD=$(pbpaste) ;
fi

# Converting to all lowercase and removing all the strange characters with hyphens
URL=$(echo "$CLIPBOARD" | awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1' | sed -e 's/[{}\,! ()\-]/_/g' | sed -e 's/__*/-/g' | tr 'A-Z' 'a-z')


FRONTMATTER="---
title: \"$CLIPBOARD\"
date: $DATE
description: \"\"
type: post
image: \"images/youtube_video_cover_images/YOUTUBE_ID.jpg\"

url: /$(printf '%s' "$URL")/

youtube_video_id: \"YOUTUBE_ID\"

categories: 
  - \"Breakfast\"

tags:
  - \"Vegetarian\"

prepTime: PTHM
cookTime: PTHM
totalTime: PTHM

recipeCategory: Breakfast
recipeCuisine: International
recipeYield: 4

aggregateRating:
  ratingValue: 4.9
  ratingCount: 4

nutrition:
  calories: xyz calories
  servingSize: 1

recipe_keywords: \"$CLIPBOARD\"

recipeIngredient:
  - recipeIngredientTitle: \"For $CLIPBOARD\"
    recipeIngredientList:
    - xyz
    - xyz

recipeInstructions:
  - recipeInstructionsTitle: \"For making $CLIPBOARD\"
    recipeInstructionsList:
    - xyz
    - xyz

recipeNotes: 
  - xyz 
  - xyz
   
---

{{< leelasrecipes-button-block-for-recipe-here-link >}}

LONG_TEXT_HERE

> LONG_TEXT_HERE

{{< figure src=\"https://www.leelasrecipes.com/images/masonary-post/2020/$URL-1.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.leelasrecipes.com/images/masonary-post/2020/$URL-2.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.leelasrecipes.com/images/masonary-post/2020/$URL-3.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< leelasrecipes-INSERT-RECIPE-HTML-BLOCK >}}

" ;

printf '%s' "$FRONTMATTER"


## FINAL WRITING TO FILE, AND OPENING FILE IN CODE EDITOR
FILENAME="$BASEDIR/$(date +%Y%m%d-%H%M%S)-frontl-generated-recipe.md" 
printf '%s' "$FRONTMATTER" > $FILENAME
code $FILENAME ;
