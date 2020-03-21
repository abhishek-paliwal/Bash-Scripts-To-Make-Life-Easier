#! /bin/bash

cat << EOF
    ##################################################################################
    ## Insert MGGK - HUGO frontmatter with proper dates
    ## IMPORTANT NOTE: This script needs a command line argument to run.
    ##################################################################################
EOF

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
BASEDIR="$HOME/Desktop/Y"
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
author: Anupama Paliwal
type: post

date: $DATE
first_published_on: $DATE

url: /$(printf '%s' "$URL")/

featured_image: /wp-content/uploads/$YEAR/$MONTH/YOUR-IMAGE.JPG

categories:
  - All-recipes
  -
  -

tags:
  -
  -

youtube_video_id: \"\"

yoast_description: \"\"

mggk_json_recipe: \"\"

---

<!--more-->

{{< mggk-button-block-for-recipe-here-link >}}


{{< mggk-hugo-google-ad-1 >}}

{{< mggk-hugo-google-ad-2 >}}


{{< mggk-print-recipe-button >}}
{{< mggkrecipeHTMLcode >}}

{{< /mggkrecipeHTMLcode >}}

{{< mggk-youtube-video-embed >}}

"

printf '%s' "$FRONTMATTER"


## FINAL WRITING TO FILE, AND OPENING FILE IN CODE EDITOR
FILENAME="$BASEDIR/$(date +%Y%m%d-%H%M%S)-generated-file-mggk.md" 
printf '%s' "$FRONTMATTER" > $FILENAME
code $FILENAME ;
