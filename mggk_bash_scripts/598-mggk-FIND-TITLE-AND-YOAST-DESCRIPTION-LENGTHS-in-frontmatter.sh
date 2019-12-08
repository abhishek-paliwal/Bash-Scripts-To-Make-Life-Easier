#!/bin/bash
###############################################################################
THIS_SCRIPT_NAME="598-mggk-FIND-TITLE-AND-YOAST-DESCRIPTION-LENGTHS-in-frontmatter.sh"
################################################################################
## SETTING VARIABLES
MY_PWD="$HOME/Desktop/Y" ;
cd $MY_PWD ;

HUGO_CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content" ;
OUTPUT_CSV="$MY_PWD/_TMP_OUTPUT_598_MGGK_FIND-TITLE-AND-YOAST-DESCRIPTION-LENGTHS_ALL.CSV" ;
OUTPUT_CSV_VALID="$MY_PWD/_TMP_OUTPUT_598_MGGK_FIND-TITLE-AND-YOAST-DESCRIPTION-LENGTHS_VALID.CSV" ;
MAX_LENGTH_TITLE=57;
MAX_LENGTH_YOAST_DESC=157;
################################################################################

cat << EOF
  ################################################################################
  ## THIS BASH SCRIPT FINDS LENGHTS OF TITLES AND YOAST_DESCRIPTION IN ALL MD FILES,
  ## PRESENT IN ORIGINAL $HUGO_CONTENT_DIR, AND SAVES THEM TO A CSV FILE.
  ## IT ALSO SAVES A NEW VALID CSV WITH ALL THOSE TITLES AND YOAST_DESCRIPTIONS WHICH
  ## HAVE A LENGTH GREATER THAN $MAX_LENGTH_TITLE AND $MAX_LENGTH_YOAST_DESC RESPECTIVELY.
  ##------------------------------------------------------------------------------
  ## USAGE:
  ## bash $THIS_SCRIPT_NAME
  ##------------------------------------------------------------------------------
  ## CREATED ON: Sunday December 8, 2019
  ## CREATED BY: Pali
  ################################################################################
EOF
################################################################################

echo "Current working directory = $MY_PWD" ;

## Removing output files if already exists
rm $OUTPUT_CSV $OUTPUT_CSV_VALID

## INITIALIZING OUTPUT CSV FILE
echo "COUNT, FILENAME, TITLE, LENGTH_TITLE, YOAST_DESCRIPTION, LENGTH_YOAST_DESCRIPTION" | tee -a $OUTPUT_CSV $OUTPUT_CSV_VALID
################################################################################

##------------------------------------------------------------------------------
## LOOPING THROUGH ALL MD FILES IN HUGO_CONTENT_DIR
COUNT=0
COUNT_VALID=0
TOTAL_FILES=$(find $HUGO_CONTENT_DIR -name '*.md' | wc -l | sed 's/ //g')

for filename in $(find $HUGO_CONTENT_DIR -name '*.md'); do
  ((COUNT++))
  echo "FILE $COUNT of $TOTAL_FILES" ;
  title=$(grep -irh '^title: ' $filename | sed -e 's/title: //g' -e 's/"//g') ;
  yoast_description=$(grep -irh '^yoast_description: ' $filename | sed -e 's/yoast_description: //g' -e 's/"//g') ;

  len_title=$(printf "%s" "$title" | wc -c | sed 's/ //g')
  len_yoast_description=$(printf "%s" "$yoast_description" | wc -c | sed 's/ //g')

  echo "$COUNT, \"$filename\", \"$title\", \"$len_title\", \"$yoast_description\", \"$len_yoast_description\"" >> $OUTPUT_CSV ;

  ## SAVE TO CSV THOSE LINES WHERE TITLE AND META_DESC LENGTHS ARE ABOVE GOOGLE SERP LIMITS
  if [[ "len_title" -gt $MAX_LENGTH_TITLE ]] || [[ "len_yoast_description" -gt $MAX_LENGTH_YOAST_DESC ]] ; then
    ((COUNT_VALID++))
    echo "  >>>> SUCCESS // len_title = $len_title // len_yoast_description = $len_yoast_description"
    echo "$COUNT_VALID, \"$filename\", \"$title\", \"$len_title\", \"$yoast_description\", \"$len_yoast_description\"" >> $OUTPUT_CSV_VALID ;
  fi
done
##------------------------------------------------------------------------------

## PRINTING SUMMARY
echo;
echo ">>>> PROGRAM RUN SUMMARY: " ;
echo "$COUNT => COUNT OF ALL MARKDOWN FILES // SAVED IN: $OUTPUT_CSV" ;
echo "$COUNT_VALID => COUNT OF ALL VALID MARKDOWN FILES WHERE len_title > $MAX_LENGTH_TITLE AND len_yoast_description > $MAX_LENGTH_YOAST_DESC // SAVED IN: $OUTPUT_CSV_VALID" ;
