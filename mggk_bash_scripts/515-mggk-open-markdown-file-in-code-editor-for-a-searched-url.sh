#!/bin/bash
###############################################################################
THIS_FILENAME="515-mggk-open-markdown-file-in-code-editor-for-a-searched-url.sh" ;
###############################################################################
SEARCHDIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content" ;
###############################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ###############################################################################
  ## FILENAME: $THIS_FILENAME
  ## USAGE: sh $THIS_FILENAME
  ###############################################################################
  ## THIS PROGRAM SEARCHES FOR ALL FILES LOCATED IN SEARCH_DIR = $SEARCHDIR
  ## IT FINDS ALL THE FILES WHICH HAVE THE A PARTICULAR SEARCHED URL IN YAML FRONTMATTER.
  ## FOR ALL THE LINES CONTAINING THE PHRASE 'url: SEARCHED_URL'
  ## THEN, IT LISTS ALL THOSE MARKDOWN FILENAMES IT FOUND
  ## THEM IN. THEN IT OPENS THE FIRST FOUND FILE IN CODE EDITOR FOR FURTHER MODIFICATION.
  ###############################################################################
  ## CODED ON: September 14, 2019
  ## CODED BY: PALI
  ###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


###############################################################################

PWD=$(pwd) ;
echo;
echo "Current working directory (NOTE: It does not matter where this script is run from) = $PWD" ;
echo;

## PROMPT FOR USER TO ENTER THE URL
read -p "Enter Your URL to search the MARKDOWN file: "  TMPURL

##------------------------------------------------------------------------------
## CREATING SEARCH_URL FROM THE USER INPUT
SEARCHURL=$(echo $TMPURL | sed 's|https://www.mygingergarlickitchen.com||g')

## EXIT THE SCRIPT IF THE ENTERED URL IS NOT PROPER
if [[ "$SEARCHURL" == "/" ]] || [[ "$SEARCHURL" == "" ]] ; then
  echo; echo ">> ERROR: INVALID SEARCH URL. Please don't enter the URL of homepage, or an empty URL. Any other mggk URL is okay." ;
  exit 1; ## Exit this script if invalid url.
fi
##------------------------------------------------------------------------------

echo;
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo "CURRENT SEARCHDIR = $SEARCHDIR" ;
echo "CURRENT SEARCHURL = $SEARCHURL" ;
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;

## COUNT THE NUMBER OF FILES WITH CURRENT URL IN YAML FRONTMATTER.
## THE ANSWER SHOULD ONLY BE 1. BUT JUST TO MAKE SURE, RUN THE FOLLOWING COMMAND.
NUM_FILES=$(grep -irl "url: $SEARCHURL" $SEARCHDIR | wc -l | tr -d '[:space:]') ;
echo ">>>> NUMBER OF FILES FOUND: $NUM_FILES" ;
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;

## Check, how many files with this url are returned.
if [[ "$NUM_FILES" -eq 0 ]] || [[ "$NUM_FILES" -gt 1 ]] ; then
  echo ">>>>>> ERROR: INVALID MGGK URL. Program found either zero, or more than 1 md files containing this URL." ;
  echo ">>>>>> ERROR NOTE: Make sure that the number of files found in the above output is exactly equal to 1. Else, it means that there are more than one markdown files with the same url in the YAML frontmatter, which should never happen. DOUBLE-CHECK THAT." ;
  exit 1; ## Exit this script
else
  echo ">>>>>> SUCCESS! Only 1 valid file is found with this URL. Good work!"
fi

## SEARCH FOR THE MD FILE WHERE THE URL LIES IN THE YAML FRONTMATTER
MY_COMMAND="grep -irl \"url: $SEARCHURL\" $SEARCHDIR | head -1" ;
echo;
echo ">> BASH COMMAND TO RUN = $MY_COMMAND" ;

## EXAMPLE SEARCH BELOW
echo;echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo ">> THIS MARKDOWN FILE IS FOUND FOR THE ENTERED SEARCH URL: "
#grep -irl 'url: /the-best-juice-combinations-to-try-out-this-year/' $HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content
eval $MY_COMMAND


## OPENING FILE IN EDITOR
echo;echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo ">> FINAL STEP: OPENING THIS FILE IN EDITOR: $(eval $MY_COMMAND)" ;
code $(eval $MY_COMMAND) ;
