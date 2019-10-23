#!/bin/bash
################################################################################
THIS_SCRIPT_NAME="599-mggk-CHANGE-RECIPE-HTML-LD-JSON-DATES-BASED-ON-FRONTMATTER-DATE-VALUE.sh"
################################################################################
## VARIABLE SETTING
HUGO_CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content" ;
TMP_OUTPUT_FILE="_TMP_OUTPUT_599_MGGK_DATE_REPLACEMENT.TXT" ;

################################################################################
#################### DON'T CHANGE ANYTHING BELOW THIS LINE #####################
################################################################################

cat << EOF
  ###############################################################################
  ## THIS PROGRAM CHANGES THE POST DATES IN THE HTML AND LD-JSON RECIPE CODES OF
  ## THOSE POSTS WHICH HAVE THE RECIPE HTML AND LD-JSON CODE IN THEM. IT FINDS
  ## THOSE CODES BY SEARCHING FOR CORRESPONDING STRINGS.
  ###############################################################################
  ## CODED ON: Wednesday October 23, 2019
  ## CODED BY: PALI
  ###############################################################################
  ## STEPS OF LOGICAL EXECUTION:
  #### 1. Create a zip backup of full hugo-content-directory containing md files
  #### 2. Finding dates in yaml frontmatter of all files in content directory
  #### 3. Extract the frontmatter date substring and save as a variable from each file.
  #### 4. Create two new string variables; one for HTML recipe code and other for LD-JSON.
  #### 5. Insert these two new date string variables at suitable places in the current
  #### file under execution.
  #### 6. Check everything is as it should be in Github Desktop. Make sure that
  #### only two 'date' lines have changed after the execution of this bash script.
  ###############################################################################
  # USAGE (run the following command):
  # > bash $THIS_SCRIPT_NAME
  ############################################################################
EOF

################################################################################

PWD=$(pwd) ;
echo; echo ">>>> Present working directory: $PWD" ;
echo;

## User confirmation to continue
read -p "If PWD is correct, please press ENTER to continue ..." ;
echo ">>>>>>>>>>>>>>>>> GOOD TO GO ... >>>>>>>>>>>>>>>>>>>>" ;
################################################################################

## FIRST IMPORTANT THINGS FIRST, WE WILL MAKE A ZIP BACKUP OF THE ORIGINAL DIRECTORY
## BEFORE MAKING ANY CHANGES TO THE EXISTING FILE. THIS IS A PRECAUTION.
BACKUP_DATE_PREFIX=$(date '+%Y-%m-%d-%H%M%S') ;
BACKUP_ZIPFILE_NAME="$PWD/$BACKUP_DATE_PREFIX-BACKUP-of-2019-HUGO-MGGK-WEBSITE-OFFICIAL-content-directory.zip"

zip -r $BACKUP_ZIPFILE_NAME $HUGO_CONTENT_DIR ;
echo;
echo "==> BACKUP ZIP FILE CREATED of directory (= $HUGO_CONTENT_DIR) ==> $BACKUP_ZIPFILE_NAME " ;

################################################################################
## USER CONFIRMATION TO CONTNUE TO
## SEE IF EVERYTHING IS OKAY, ELSE PRESS CTRL+C to stop
echo;
read -p ">>>>>>>>>>>>>>>>> IF ALL IS OKAY, then press ENTER key to continue ... (else press ctrl+c to cancel)" ;
echo ;

## PRINTING OUT ALL THE DATES IN HTML RECIPE CODE SECION OF ALL FILES IN HUGO_CONTENT_DIR
echo ; echo ">>>> PRINTING ALL DATES FOUND IN HTML RECIPE CODE:" ; echo ;
grep -irh -e "<strong>Date Published: </strong>" $HUGO_CONTENT_DIR/* | nl
echo "=======================================================================" ;

################################################################################

## INITIALIZING THE TMP OUTPUT FILE
echo "#####################################################"   > $TMP_OUTPUT_FILE ;
echo "## OUTPUT CREATED ON: $(date)"                          >> $TMP_OUTPUT_FILE ;
echo "## OUTPUT created from bash script = $THIS_SCRIPT_NAME" >> $TMP_OUTPUT_FILE ;
echo "#####################################################"  >> $TMP_OUTPUT_FILE ;

## SETTING SOME COUNTER VARIABLES
COUNT_NUMFILES=0;

for mdfile in $(find $HUGO_CONTENT_DIR -name '*.md' );
do
  (( COUNT_NUMFILES++ ))
  ##############################################################################
  ## PERFORM REGULAR STUFF FOR EACH FILE AND PRINT TO TMP OUTPUT FILE
  FRONTMATTER_DATE="$(grep -irh '^date: ' $mdfile | sort -n | sed -e 's/date: //g' -e 's/+00:00//g' )" ;
  REPLACEMENT_DATE=$(echo "$FRONTMATTER_DATE" | sed -e 's/date: //g' | cut -c1-10) ;

  DATE_FOUND_IN_RECIPE_BLOCK_HTML="$(grep -irh '<strong>Date Published: </strong>' $mdfile)" ;
  DATE_FOUND_IN_RECIPE_BLOCK_LDJSON="$(grep -irh '\"datePublished' $mdfile)" ;

  ## PRINTING SOME IMPORTANT STUFF FOR DEBUGGING
  echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
  echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
  echo "FILE = $COUNT_NUMFILES" ;
  echo "CURRENT FILENAME = $mdfile" ;
  echo "FRONTMATTER_DATE = $FRONTMATTER_DATE " ;
  echo "REPLACEMENT_DATE = $REPLACEMENT_DATE " ;
  echo "DATE_FOUND_IN_RECIPE_BLOCK_HTML = $DATE_FOUND_IN_RECIPE_BLOCK_HTML " ;
  echo "DATE_FOUND_IN_RECIPE_BLOCK_LDJSON = $DATE_FOUND_IN_RECIPE_BLOCK_LDJSON " ;

  ## PRINTING SOME DETAILS TO A TMP FILE
  echo >> $TMP_OUTPUT_FILE ;
  echo "FILE = $COUNT_NUMFILES" >> $TMP_OUTPUT_FILE ;
  echo "FILENAME = $mdfile" >> $TMP_OUTPUT_FILE ;
  echo "$FRONTMATTER_DATE = DATE FOUND IN YAML FRONTMATTER" >> $TMP_OUTPUT_FILE ;
  echo "$REPLACEMENT_DATE = DATE TO BE INSERTED IN HTML+LD-JSON RECIPE BLOCKS" >> $TMP_OUTPUT_FILE ;
  echo "  DATE_FOUND_IN_RECIPE_BLOCK_HTML = $DATE_FOUND_IN_RECIPE_BLOCK_HTML " >> $TMP_OUTPUT_FILE ;
  echo "  DATE_FOUND_IN_RECIPE_BLOCK_LDJSON = $DATE_FOUND_IN_RECIPE_BLOCK_LDJSON " >> $TMP_OUTPUT_FILE ;
  echo;

  ## REPLACING THE EXISTING DATE LINE IN HTML AND LD-JSON CODE BLOCKS WITH
  ## THE NEW REPLACEMENT DATE LINES
    #### On Mac OS, sed requires a chosen 'backup file extension' after using sed -i
    #### WE'LL USE .bak EXTENSION FOR THIS
  echo ">> PERFORMING ACTUAL REPLACEMENT OF THE DATES (HTML + JD-JSON RECIPE CODE BLOCKS) IN THIS ORIGINAL FILE = \n$mdfile" ;

    ####### Step 1 = Replacing the date block in html recipe code block
  sed -i .bak "s|<strong>Date Published: </strong>.*$|<strong>Date Published: </strong> <span itemprop='datePublished'>$REPLACEMENT_DATE</span>|" $mdfile ;
    ####### Step 2 = Replacing the date block in LD-JSON recipe code block
  sed -i .bak "s|\\\"datePublished.*$|\\\"datePublished\\\\\": \\\\\"$REPLACEMENT_DATE\\\\\",|" $mdfile ;

  echo; echo ">> DELETING THIS TEMPORARY BACKUP FILE CREATED DURING RUNNING SED COMMAND = \n$mdfile.bak" ;
  rm $mdfile.bak ;

  echo; echo;

################################################################################
## MAIN FOR LOOP ENDS BELOW
done
################################################################################

echo "=======================================================================" ;
echo "SUMMARY OF RESULTS:" ;
echo "-----------------------------------------------------------------------" ;
echo "// COUNT OF TOTAL FILES FOUND = $COUNT_NUMFILES files"
echo "-----------------------------------------------------------------------" ;

## OPENING TMP OUTPUT FILE
#open $TMP_OUTPUT_FILE
