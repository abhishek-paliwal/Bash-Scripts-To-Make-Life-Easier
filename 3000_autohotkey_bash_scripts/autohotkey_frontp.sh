#! /bin/bash
## Insert PaliNOTES - HUGO frontmatter with proper dates // §frontp

echo ">>>> IMPORTANT NOTE: This script needs a command line argument to run."

DATE=$(date +%Y-%m-%dT%H:%M:%S)
PUBDATE=$(date +%Y-%m-%d)

if [ "$USER" == "ubuntu" ] ; then
    CLIPBOARD=$(echo "$1" | sed 's/^$//g') ;
else 
    CLIPBOARD=$(pbpaste) ;
fi

# Converting to all lowercase and removing all the strange characters with hyphens
URL=$(echo "$CLIPBOARD" | awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1' | sed -e 's/[{}\,! ()\-]/_/g' | sed -e 's/__*/-/g' | tr 'A-Z' 'a-z')


FRONTMATTER="---
title: \"$CLIPBOARD\"
url: /$(printf '%s' "$URL")/
date: $DATE
publishdate: $PUBDATE
lastmod: $PUBDATE
draft: false
tags: [ tag1, tag2 ]
---

"

printf '%s' "$FRONTMATTER"
