#!/bin/bash
################################################################################
THIS_SCRIPT_NAME="599-mggk-ASSIGN-RANDOM-PUBLISHING-DATES-FOR-POSTS-IN-YAML-FRONTMATTER.sh"
################################################################################
## VARIABLE SETTING
SHIFT_BY_NUMDAYS="180" ; ## 120 DAYS, ABOUT 4 MONTHS
SUFFIX_STRING="d"; # d for days, w for weeks, m for months, y for years
DATE_SHIFT_BY_NUMDAYS="$SHIFT_BY_NUMDAYS$SUFFIX_STRING" ;
################################################################################
HUGO_CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content" ;
#HUGO_CONTENT_DIR="$HOME/GitHub/ZZ-HUGO-TEST/content" ;
################################################################################
#################### DON'T CHANGE ANYTHING BELOW THIS LINE #####################
################################################################################

cat << EOF
  ###############################################################################
  ## THIS PROGRAM CHANGES THE POST DATES IN THE YAML FRONTMATTER OF THOSE POSTS
  ## WHICH ARE OLDER THAN $SHIFT_BY_NUMDAYS DAYS FROM THE DAY OF THIS PROGRAM RUN.
  ## FOR THIS, WE NEED TO CONVERTED ALL DATES TO SECONDS FROM EPOCH (MEANING
  ## SECONDS PASSED FROM 1970-01-01:00:00:00)
  ###############################################################################
  ## CODED ON: Friday September 20, 2019
  ## CODED BY: PALI
  ###############################################################################
  ## STEPS OF LOGICAL EXECUTION:
  #### 1. Create a zip backup of full hugo-content-directory containing md files
  #### 2. Finding dates in yaml frontmatter of all files in content directory
  #### 3. Compare the date in each file thus found with the one we selected
  #### about $SHIFT_BY_NUMDAYS days ago from today.
  #### 4. If the date found is older, then assign a new date between
  #### 45 and $SHIFT_BY_NUMDAYS days ago from today, for that file.
  #### 5. Insert this new date in the current file under execution.
  #### 6. Check everything is as it should be in Github Desktop. Make sure that
  #### only the 'date' line in yaml frontmatter is changed after the
  #### execution of this bash script.
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
BACKUP_ZIPFILE_NAME="$PWD/$BACKUP_DATE_PREFIX-HUGO_CONTENT_DIR-BACKUP.zip"

zip -r $BACKUP_ZIPFILE_NAME $HUGO_CONTENT_DIR ;
echo;
echo "==> BACKUP ZIP FILE CREATED of directory (= $HUGO_CONTENT_DIR) ==> $BACKUP_ZIPFILE_NAME " ;

################################################################################
## USER CONFIRMATION TO CONTNUE TO
## SEE IF EVERYTHING IS OKAY, ELSE PRESS CTRL+C to stop
echo;
read -p ">>>>>>>>>>>>>>>>> IF ALL IS OKAY, then press ENTER key to continue ... (else press ctrl+c to cancel)" ;
echo ;

## PRINTING OUT ALL THE DATES IN FRONTMATTER SECION OF ALL FILES IN HUGO_CONTENT_DIR
#grep -irh '^date: ' $HUGO_CONTENT_DIR/* | sort -n | sed 's/date: //g' | sort -nr | nl

################################################################################
## FIND THE DATE WHICH WAS EXACTLY $DATE_SHIFT_BY_NUMDAYS DAYS AGO FROM TODAY
NEW_DATE=$(date -v -$DATE_SHIFT_BY_NUMDAYS) ;
NEW_DATE_EPOCH=$(date -v -$DATE_SHIFT_BY_NUMDAYS +%s) ;
NEW_DATE_FORMATTED=$(date -r $NEW_DATE_EPOCH +'%Y-%m-%dT%H:%M:%S') ;

echo; echo "CHOSEN OLDEST DATE ($DATE_SHIFT_BY_NUMDAYS days ago from today) = $NEW_DATE_FORMATTED // $NEW_DATE // $NEW_DATE_EPOCH (EPOCH)" ;
echo;echo "//////////////////////////////////////////////////////////////////////////" ;
echo;

################################################################################
TMP_OUTPUT_FILE="_TMP_OUTPUT_599_MGGK.TXT" ;

echo > $TMP_OUTPUT_FILE ; ## INITIALIZING THE TMP OUTPUT FILE

## SETTING SOME COUNTER VARIABLES
COUNT_NUMFILES=0;
COUNT_VALID=0;
COUNT_INVALID=0;

for mdfile in $(find $HUGO_CONTENT_DIR -name '*.md' );
do
  (( COUNT_NUMFILES++ ))
  ##############################################################################
  ## PERFORM REGULAR STUFF FOR EACH FILE AND PRINT TO TMP OUTPUT FILE
  FRONTMATTER_DATE="$(grep -irh '^date: ' $mdfile | sort -n | sed -e 's/date: //g' -e 's/+00:00//g' )" ;
  FRONTMATTER_DATE_EPOCH_TIME=$(date -j -f '%Y-%m-%dT%H:%M:%S' "$FRONTMATTER_DATE" +'%s') ;

  ## PRINTING SOME IMPORTANT STUFF FOR DEBUGGING
  echo "CURRENT FILENAME = $mdfile" ;
  echo "FRONTMATTER_DATE = $FRONTMATTER_DATE // NEW_DATE (=> date $DATE_SHIFT_BY_NUMDAYS days ago from today) = $NEW_DATE_FORMATTED" ;

  ## CALCULATING THE DIFFERENCE BETWEEN TWO DATES IN THE NUMBER OF DAYS
  datediff_in_days=$(echo "($NEW_DATE_EPOCH - $FRONTMATTER_DATE_EPOCH_TIME)/86400" | bc) ;
  echo "$datediff_in_days days difference";
  echo;

  ## PRINTING SOME DETAILS TO A TMP FILE
  echo >> $TMP_OUTPUT_FILE ;
  echo "$datediff_in_days days difference // $mdfile // FRONTMATTER_DATE = $FRONTMATTER_DATE // NEW_DATE (=> date $DATE_SHIFT_BY_NUMDAYS days ago from today) = $NEW_DATE" >> $TMP_OUTPUT_FILE ;

  ################## BEGIN : IF-ELSE LOOP ######################################
  ## ONLY UPDATING THE DATES IF THE DATE IN EXISTING FRONTMATTER IS OLDER
  #### AND THE DATE DIFFERENCE IS MORE THAN ONE.

  if [[ $datediff_in_days -gt 1 ]]
  then
    (( COUNT_VALID++ ))
    echo;
    echo;echo "//// datediff_in_days => $datediff_in_days is more than 0 days. Hence, the date WILL BE updated." ;
    echo ;
    ##############################################################################
    ## NOW WE NEED TO CREATE A RANDOM DATE WHICH IS 45 DAYS TO $SHIFT_BY_NUMDAYS DAYS OLDER THAN TODAY
    ## HENCE, FOR THAT WE NEED TO CREATE A RANDOM NUMBER BETWEEN 45 AND 120
    REMAINDER_VAR=$(( $SHIFT_BY_NUMDAYS -45 | bc )) ;
    RAND_DATENUM=$(( ($RANDOM % $REMAINDER_VAR) + 45 | bc )) ;

    ## SINCE THE ASSIGNED DATE WILL HAVE THE H:M:S THE SAME AS THE TIME OF THIS
    #### PROGRAM RUN TIME, ALL THE ASSIGNED DATES WILL HAVE THE SAME H:M:S VALUES
    #### HENCE WE NEED TO RANDMOIZE THAT TOO IN A ONE DAY WINDOW (86400 SECONDS)
    #### FOR THIS, WE WILL USE BUILTIN $RANDOM FUNCION WHICH GIVES OUT A RANDOM
    #### INTEGER VALUE IN THE RANGE OF 0 - 32767
    ASSIGNED_DATE=$(date -v -$RAND_DATENUM$SUFFIX_STRING) ;
    ASSIGNED_DATE_EPOCH=$(date -v -$RAND_DATENUM$SUFFIX_STRING +%s) ;
    ASSIGNED_DATE_EPOCH_RAND=$(echo "$ASSIGNED_DATE_EPOCH + $RANDOM" | bc ) ;
    ASSIGNED_DATE_FORMATTED=$(date -r $ASSIGNED_DATE_EPOCH_RAND +'%Y-%m-%dT%H:%M:%S') ;

    echo "ORIGINAL ASSIGNED_DATE = $ASSIGNED_DATE // MODIFIED H:M:S ASSIGNED DATE = $ASSIGNED_DATE_FORMATTED " ;
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
    echo;

    ## REPLACING THE EXISTING DATE LINE WITH THE NEW ASSIGNED DATE LINE
    #### On Mac OS, sed requires a chosen 'backup file extension' after using sed -i
    #### WE'LL USE .bak EXTENSION FOR THIS
    echo ">> PERFORMING ACTUAL REPLACEMENT OF THE DATE IN ORIGINAL FILE = $mdfile" ;
    #sed -i .bak "s/date:.*$/date: $ASSIGNED_DATE_FORMATTED/" $mdfile ;

    echo ">> DELETING TEMPORARY BACKUP FILE CREATED DURING RUNNING SED COMMAND = $mdfile.bak" ;
    rm $mdfile.bak

    echo; echo;

  else
    (( COUNT_INVALID++ ))
    echo;echo "//// datediff_in_days => $datediff_in_days is less than 0 days. Hence, the date WILL NOT BE updated." ;
    echo ;
  fi
  ################## END : IF-ELSE LOOP ######################################

################################################################################
## MAIN FOR LOOP ENDS BELOW
done
################################################################################

echo "=======================================================================" ;
echo "SUMMARY OF RESULTS:" ;
echo "// COUNT OF TOTAL FILES = $COUNT_NUMFILES files"
echo "// DATE CHANGE IS NEEDED = $COUNT_VALID files"
echo "// DATE IS ALREADY OKAY = $COUNT_INVALID files" ;
