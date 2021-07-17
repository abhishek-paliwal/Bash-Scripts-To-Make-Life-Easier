#! /bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ##################################################################################
    ## CREATE MGGK HUGO sponsored file with frontmatter inserted.
    ## IMPORTANT NOTE: This script needs a user input at runtime.
    ## Created by: Pali
    ## Created on: July 17, 2021
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
fi

##
## Using the power of sed to find all text between two phrases
echo ">> Dumping all text found between the required headings" ;
echo "$RECIPE_NAME_VAR" > $REQUIREMENTS_FILE_BASENAME-recipename.txt
###############################################################################

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
title: \"$CLIPBOARD\"

author: Anupama Paliwal

type: post

date: $DATE
first_published_on: $DATE

url: /$(printf '%s' "$URL")/

featured_image: /wp-content/uploads/$YEAR/$MONTH/YOUR-IMAGE.JPG

categories:
  - Uncategorized

tags:
  - Uncategorized

yoast_description: \"YOAST_DESCRIPTION\"

" ;

  
FRONTMATTER_FOOTER="---

<!--more-->


{{< mggk-hugo-google-ad-1 >}}

{{< mggk-hugo-google-ad-2 >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-1.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-2.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/$YEAR/$MONTH/$URL-3.jpg\" alt=\"Image of $CLIPBOARD\" >}}

{{< mggk-YouMayAlsoLike-HTMLcode >}}


{{< /mggk-YouMayAlsoLike-HTMLcode >}}

" ;

printf '%s' "$FRONTMATTER_HEADER" ;
printf '%s' "$FRONTMATTER_FOOTER" ;

##################################################################################
## FINAL WRITING TO FILE, AND OPENING FILE IN CODE EDITOR
##################################################################################
FILENAME="$BASEDIR/$(date +%Y%m%d-%H%M%S)-frontm-generated-sponsored-post.md" 
printf '%s' "$FRONTMATTER_HEADER" > $FILENAME
printf '%s' "$FRONTMATTER_FOOTER" >> $FILENAME
##
code $FILENAME ;
