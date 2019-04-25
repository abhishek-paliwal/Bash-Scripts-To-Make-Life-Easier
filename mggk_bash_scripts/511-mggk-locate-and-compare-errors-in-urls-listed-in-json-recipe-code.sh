#!/bin/bash
###############################################################################
THIS_FILENAME="511-mggk-locate-and-compare-errors-in-urls-listed-in-json-recipe-code.sh" ;
SEARCH_DIR="/Users/abhishek/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/" ;
###############################################################################
cat<<EOF
  ###############################################################################
  ## FILENAME: $THIS_FILENAME
  ## USAGE: sh $THIS_FILENAME
  ###############################################################################
  ## THIS PROGRAM REQUIES GNU-SED (gsed) TO RUN on MacOS
  ## INSTALL IT BY RUNNING > brew install gnu-sed
  ## Then, use it by running gsed on command line
  ###############################################################################
  ## THIS PROGRAM SEARCHES FOR ALL FILES LOCATED IN SEARCH_DIR = $SEARCH_DIR
  ## IT FINDS ALL THE FILES WHICH HAVE THE 'json' KEYWORD IN THEM, THEN SEARCHES
  ## FOR ALL THE LINES CONTAINING THE PHRASE 'url: '
  ## THEN, IT LISTS ALL THOSE LINES ALONG WITH THE MARKDOWN FILENAME IT FOUND
  ## THEM IN.
  #########################################
  #### THE MAIN IDEA HERE IS TO FIND THE URLs in the markdown files, and see if
  #### the URL in the mggk_json_recipe_code is the same as the one in the frontmatter.
  #########################################
  ## IT creates a temporary text file output, which needs to be checked manually
  ## for any url errors.
  ###############################################################################
  ## CODED ON: APRIL 25, 2019
  ## CODED BY: PALI
  ###############################################################################
EOF

###############################################################################

PWD=$(pwd) ;
echo;
echo "Current working directory = $PWD" ;
echo;

## USER CONFIRMATION
read -p "If this working directory is OK, please press ENTER key to continue ..." ;
echo;

## CREATING A TEMPORARY TEXT FILE TO STORE OUTPUT
TMP_FILE="_TMP_OUTPUT_OF_511_MGGK_SCRIPT.TXT" ;
## INITIALIZING
echo "#########################################################################" > $TMP_FILE ;
echo "#### SCRIPT OUTPUT OF = $THIS_FILENAME ####" >> $TMP_FILE ;
echo "#### Output File created on: $(date) #### " >> $TMP_FILE ;
echo "#########################################################################" >> $TMP_FILE ;

## LOOPING OVER ALL FILES WITH 'json' KEYWORD
COUNT=0;
for x in $(grep -irl 'json' $SEARCH_DIR/*) ;
do
  ((COUNT++))
  echo; echo; echo;

  echo $COUNT
  echo "FILE= $x" ;
  echo;

  ## FINDING URL IN FRONTMATTER
  ECHO "URL (FOUND IN FRONTMATTER) ==>" ;
  grep -i 'url: ' $x;

  ## FINDING URL EVERYWHERE ELSE (IN JSON RECIPE CODE BLOCK)
  ECHO "URL(s) (FOUND IN JSON RECIPE CODE) ==>" ;
  grep -i '\\\"url\\\": ' $x;

  #### BEGIN:  SAVING RESULTS TO TMP FILE ####
  echo "$COUNT" >> $TMP_FILE ;
  echo "FILE-NAME= $x" >> $TMP_FILE ;

  echo "" >> $TMP_FILE ;
  echo ">>>>>>>>>>>>>>>> URL (FOUND IN FRONTMATTER) ==>" >> $TMP_FILE ;
  grep -i 'url: ' $x >> $TMP_FILE ;

  echo "" >> $TMP_FILE ;
  echo ">>>>>>>>>>>>>>>> URL(s) (FOUND IN JSON RECIPE CODE) ==>" >> $TMP_FILE ;
  grep -i '\\\"url\\\": ' $x >>$TMP_FILE ;

  echo "" >> $TMP_FILE ;
  echo "" >> $TMP_FILE ;
  echo "" >> $TMP_FILE ;
  #### END:  SAVING RESULTS TO TMP FILE ####
done

## CREATING FINAL OUTPUT FILE by removing unnecessary characters and FULL MGGK URL ##
cat $TMP_FILE | gsed 's|\\\"||Ig' | gsed 's|https://www.mygingerGarlicKitchen.com||gI' > _FINAL_$TMP_FILE ;

###############################################################################
## Opening pwd (this commnad works only on MacOS)
echo;  echo "opening PWD ..." ;
open $PWD ;
