#!/bin/bash
###############################################################################
THIS_FILENAME="515-mggk-open-markdown-file-in-atom-editor-for-a-searched-url.sh" ;
###############################################################################
SEARCHDIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content" ;
###############################################################################
cat<<EOF
  ###############################################################################
  ## FILENAME: $THIS_FILENAME
  ## USAGE: sh $THIS_FILENAME
  ###############################################################################
  ## THIS PROGRAM SEARCHES FOR ALL FILES LOCATED IN SEARCH_DIR = $SEARCHDIR
  ## IT FINDS ALL THE FILES WHICH HAVE THE A PARTICULAR SEARCHED URL IN YAML FRONTMATTER.
  ## FOR ALL THE LINES CONTAINING THE PHRASE 'url: SEARCHED_URL'
  ## THEN, IT LISTS ALL THOSE MARKDOWN FILENAMES IT FOUND
  ## THEM IN. THEN IT OPENS THE FIRST FOUND FILE IN ATOM EDITOR FOR FURTHER MODIFICATION.
  ###############################################################################
  ## CODED ON: September 14, 2019
  ## CODED BY: PALI
  ###############################################################################
EOF

###############################################################################

PWD=$(pwd) ;
echo;
echo "Current working directory (NOTE: It does not matter where this script is run from) = $PWD" ;
echo;

## PROMPT FOR USER TO ENTER THE URL
read -p "Enter Your URL to search the MARKDOWN file: "  TMPURL

##------------------------------------------------------------------------------
## CREATING SEARCH_URL FROM THE USER 1INPUT
SEARCHURL=$(echo $TMPURL | sed 's|https://www.mygingergarlickitchen.com||g')

## EXIT THE SCRIPT IF THE ENTERED URL IS NOT PROPER
if [[ "$SEARCHURL" == "/" ]] || [[ "$SEARCHURL" == "" ]] ; then
  echo; echo ">> ERROR: INVALID SEARCH URL. Please don't enter the URL of homepage. Any other page is okay." ;
  exit 1; ## Exit this script if invalid url.
fi
##------------------------------------------------------------------------------

echo;
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo "CURRENT SEARCHDIR = $SEARCHDIR" ;
echo "CURRENT SEARCHURL = $SEARCHURL" ;
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;

## COUNT THE NUMBER OF FILES WITH CURRENT URL IN YAML FRONTMATTER.
## THE ANSWER SHOULD ONLY BE ONE. BUT JUST TO MAKE SURE, RUN THE FOLLOWING COMMAND.
NUM_FILES=$(grep -irl "url: $SEARCHURL" $SEARCHDIR | wc -l) ;
echo;
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
ECHO ">>>> NUMBER OF FILES FOUND: $NUM_FILES" ;
ECHO ">>>>>>> IMPORTANT NOTE: Make sure that the number of files found in the above output is equal to 1. Else, it means that there are more than one markdown files with the same url in the YAML frontmatter, which should never happen. DOUBLE-CHECK THAT." ;
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;

## SEARCH FOR THE MD FILE WHERE THE URL LIES IN THE YAML FRONTMATTER
MY_COMMAND="grep -irl \"url: $SEARCHURL\" $SEARCHDIR | head -1" ;
echo;
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo ">> BASH COMMAND TO RUN = $MY_COMMAND" ;
echo;echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;

## EXAMPLE SEARCH BELOW
echo;echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo ">> THIS MARKDOWN FILE IS FOUND FOR THE ENTERED SEARCH URL: "
#grep -irl 'url: /the-best-juice-combinations-to-try-out-this-year/' $HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content
eval $MY_COMMAND


## OPENING FILE IN ATOM EDITOR
echo;echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo ">> FINAL STEP: OPENING THIS FILE IN ATOM EDITOR: $(eval $MY_COMMAND)" ;
atom $(eval $MY_COMMAND) ;
