#! /bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ##################################################################################
    ## Insert MGGK - HUGO frontmatter with proper dates
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
BASEDIR="$DIR_GITHUB/ZZ-HUGO-TEST/content/blog"

cd $BASEDIR

echo ">>>> Current working directory is: $BASEDIR" ;
echo ">>>> IMPORTANT NOTE: This script needs a command line argument to run." ;

if [ "$(uname)" == "Linux" ] ; then 
    DATE=$(date -d '12 hour ago' +%Y-%m-%dT%H:%M:%S) ;
else
    DATE=$(date -v -12H +%Y-%m-%dT%H:%M:%S) ;
fi 

PUBDATE=$DATE ;

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
  - All-recipes
  -
  -

tags:
  -
  -

youtube_video_id: \"YOUTUBE_ID\"

yoast_description: \"YOAST_DESCRIPTION\"

prepTime: PTHM
cookTime: PTHM
totalTime: PTHM

recipeCategory: xyz
recipeCuisine: xyz
recipeYield: xyz xyz

aggregateRating:
  ratingValue: 4.9
  ratingCount: 3

nutrition:
  calories: xyz calories
  servingSize: 1

recipe_keywords: \"xyz\"

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

<!--more-->

{{< mggk-button-block-for-recipe-here-link >}}


{{< mggk-hugo-google-ad-1 >}}

{{< mggk-hugo-google-ad-2 >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-1.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-2.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-3.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-4.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-5.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-6.jpg\" alt=\"Image of $CLIPBOARD\" >}}


{{< mggk-print-recipe-button >}}

{{< mggk-INSERT-RECIPE-HTML-BLOCK >}}

{{< mggk-YouMayAlsoLike-HTMLcode >}}


{{< /mggk-YouMayAlsoLike-HTMLcode >}}

" ;

printf '%s' "$FRONTMATTER"


## FINAL WRITING TO FILE, AND OPENING FILE IN CODE EDITOR
FILENAME="$BASEDIR/$(date +%Y%m%d-%H%M%S)-frontm-generated-recipe.md" 
printf '%s' "$FRONTMATTER" > $FILENAME
code $FILENAME ;
