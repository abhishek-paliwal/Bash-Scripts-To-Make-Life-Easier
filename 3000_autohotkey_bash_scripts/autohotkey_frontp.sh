#! /bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ##################################################################################
    ## Insert PaliNOTES - HUGO frontmatter with proper dates
    ## IMPORTANT NOTE: This script needs a command line argument to run.
    ##################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
BASEDIR="$DIR_Y"
cd $BASEDIR

echo ">>>> Current working directory is: $BASEDIR" ;
echo ">>>> IMPORTANT NOTE: This script needs a command line argument to run." ;

if [ "$(uname)" == "Linux" ] ; then 
    DATE=$(date -d '12 hour ago' +%Y-%m-%dT%H:%M:%S) ;
else
    DATE=$(date -v -12H +%Y-%m-%dT%H:%M:%S) ;
fi 

PUBDATE=$DATE ;

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

## FINAL WRITING TO FILE, AND OPENING FILE IN CODE EDITOR
FILENAME="$BASEDIR/$(date +%Y%m%d-%H%M%S)-generated-file-palinotes.md" 
printf '%s' "$FRONTMATTER" > $FILENAME
code $FILENAME ;
