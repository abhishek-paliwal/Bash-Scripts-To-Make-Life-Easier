#!/bin/bash
################################################################################
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
################################################################################
## VARIABLE SETTING
SHIFT_BY_NUMDAYS="396" ; ## 396 DAYS, ABOUT 13 MONTHS
SUFFIX_STRING="d"; # d for days, w for weeks, m for months, y for years
DATE_SHIFT_BY_NUMDAYS="$SHIFT_BY_NUMDAYS$SUFFIX_STRING" ;
################################################################################
HUGO_CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content" ;
################################################################################
#################### DON'T CHANGE ANYTHING BELOW THIS LINE #####################
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ###############################################################################
  ## THIS PROGRAM CHANGES THE POST DATES IN THE YAML FRONTMATTER OF THOSE POSTS
  ## WHICH ARE OLDER THAN $SHIFT_BY_NUMDAYS DAYS FROM THE DAY OF THIS PROGRAM RUN.
  ## FOR THIS, WE NEED TO CONVERTED ALL DATES TO SECONDS FROM EPOCH (MEANING
  ## SECONDS PASSED FROM 1970-01-01:00:00:00)
  ###############################################################################
  ## CODED ON: Friday August 17, 2021
  ## CODED BY: PALI
  ###############################################################################
  ## STEPS OF LOGICAL EXECUTION:
  #### 1. Create a zip backup of full hugo-content-directory containing md files
  #### 2. Finding dates in yaml frontmatter of all files in content directory
  #### 3. Compare the date in each file thus found with the one we selected
  #### about $SHIFT_BY_NUMDAYS days ago from today.
  #### 4. If the date found is older, then assign a new date between
  #### 30 and $SHIFT_BY_NUMDAYS days ago from today, for that file.
  #### 5. Insert this new date in the current file under execution.
  #### 6. Check everything is as it should be in Github Desktop. Make sure that
  #### only the 'date' line in yaml frontmatter is changed after the
  #### execution of this bash script.
  ###############################################################################
  # USAGE (run the following command):
  # > bash $THIS_SCRIPT_NAME
  ############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

PWD=$WORKDIR ;
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

## PRINTING OUT ALL THE DATES IN FRONTMATTER SECION OF ALL FILES IN HUGO_CONTENT_DIR
grep -irh '^date: ' $HUGO_CONTENT_DIR/* | sort -n | sed 's/date: //g' | sort -nr | nl
echo "=======================================================================" ;

################################################################################
## FIND THE DATE WHICH WAS EXACTLY $DATE_SHIFT_BY_NUMDAYS DAYS AGO FROM TODAY
NEW_DATE=$(date -v -$DATE_SHIFT_BY_NUMDAYS) ;
NEW_DATE_EPOCH=$(date -v -$DATE_SHIFT_BY_NUMDAYS +%s) ;
NEW_DATE_FORMATTED=$(date -r $NEW_DATE_EPOCH +'%Y-%m-%dT%H:%M:%S') ;

echo; echo "CHOSEN OLDEST DATE ($DATE_SHIFT_BY_NUMDAYS days ago from today) = $NEW_DATE_FORMATTED // $NEW_DATE // $NEW_DATE_EPOCH (EPOCH)" ;
echo;echo "//////////////////////////////////////////////////////////////////////////" ;
echo;

################################################################################
TMP_OUTPUT_FILE="$PWD/_TMP_OUTPUT_599_MGGK.TXT" ;

## INITIALIZING THE TMP OUTPUT FILE
echo "#####################################################" > $TMP_OUTPUT_FILE ;
echo "## OUTPUT CREATED ON: $(date)" >> $TMP_OUTPUT_FILE ;
echo "## OUTPUT created from bash script = $THIS_SCRIPT_NAME" >> $TMP_OUTPUT_FILE ;
echo "#####################################################" >> $TMP_OUTPUT_FILE ;

## SETTING SOME COUNTER VARIABLES
COUNT_NUMFILES=0;
COUNT_VALID=0;
COUNT_INVALID=0;

##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
function func_calculate_days_difference_btwn_two_epoch_dates () {
    ## CALCULATE THE DIFFERENCE BETWEEN TWO DATES AS NUMBER OF DAYS
    NEW_DATE_EPOCH="$1" ;
    FRONTMATTER_DATE_EPOCH_TIME="$2" ;
    ##
    datediff_in_days=$(echo "($NEW_DATE_EPOCH - $FRONTMATTER_DATE_EPOCH_TIME)/86400" | bc) ;
    echo "$datediff_in_days" ;
}
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
function func_calculate_randomly_assigned_date_30days_ago () {
    ## NOW WE NEED TO CREATE A RANDOM DATE WHICH IS 30 DAYS TO SHIFT_BY_NUMDAYS DAYS OLDER THAN TODAY
    ## HENCE, FOR THAT WE NEED TO CREATE A RANDOM NUMBER BETWEEN 30 AND SHIFT_BY_NUMDAYS
    REMAINDER_VAR=$(( $SHIFT_BY_NUMDAYS -30 | bc )) ;
    RAND_DATENUM=$(( ($RANDOM % $REMAINDER_VAR) + 30 | bc )) ;
    ## SINCE THE ASSIGNED DATE WILL HAVE THE H:M:S THE SAME AS THE TIME OF THIS
    ## PROGRAM RUN TIME, ALL THE ASSIGNED DATES WILL HAVE THE SAME H:M:S VALUES
    ## HENCE WE NEED TO RANDOMIZE THAT TOO BY ADDING RANDOM SECONDS TO EPOCH SECONDS.
    ######
    #### FOR THIS, WE WILL USE BUILTIN $RANDOM FUNCTION WHICH GIVES OUT A RANDOM
    #### INTEGER VALUE IN THE RANGE OF 0 - 32767. THIS IS SUFFICIENT FOR US BCOZ
    #### 32767 SECONDS MEAN ABOUT 9 HOURS. SO FINAL ASSIGNED EPOCH SECONDS WILL
    #### ADD ANYHING FROM 0 TO 9 HOURS.
    ####
    ASSIGNED_DATE=$(date -v -$RAND_DATENUM$SUFFIX_STRING) ;
    ASSIGNED_DATE_EPOCH=$(date -v -$RAND_DATENUM$SUFFIX_STRING +%s) ;
    ASSIGNED_DATE_EPOCH_RAND=$(echo "$ASSIGNED_DATE_EPOCH + $RANDOM" | bc ) ;
    ASSIGNED_DATE_FORMATTED=$(date -r $ASSIGNED_DATE_EPOCH_RAND +'%Y-%m-%dT%H:%M:%S') ;
    ##
    #echo "ORIGINAL ASSIGNED_DATE = $ASSIGNED_DATE // MODIFIED H:M:S ASSIGNED DATE = $ASSIGNED_DATE_FORMATTED " ;
    #echo "##-------------------------------------" ;
    #echo "$ASSIGNED_DATE = ASSIGNED_DATE BY PROGRAM - ORIGINAL" >> $TMP_OUTPUT_FILE ;
    echo "$ASSIGNED_DATE_FORMATTED" ;
}
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
function func_calculate_exact_date_1year_ago_from_frontmatter_date () {
    ## Now we need to calculate a date which needs to satisfy the following 3 conditions:
    ### 1. date should be exactly around 1/2/3/etc year from existing frontmatter date value
    ### 2. date needs to be in current year, or in last year for remaining months from current month.
    ### 3. date needs to be between 1month to 13months ago from today
    ####
    ## FOR THIS, WE WILL USE BUILTIN $RANDOM FUNCTION WHICH GIVES OUT A RANDOM
    ## INTEGER VALUE IN THE RANGE OF 0 - 32767. THIS IS SUFFICIENT FOR US BCOZ
    ## 32767 SECONDS MEAN ABOUT 9 HOURS. SO FINAL ASSIGNED EPOCH SECONDS WILL
    ## ADD ANYHING FROM 0 TO 9 HOURS.
    ####
    ## PS: We'll use 367 instead of 365 to force 1-2 days yearly addition
    RANDNUM=$(echo "$RANDOM * 2" | bc) ; ## gives between 0-18 hours of randomness
    ASSIGNED_DATE_EPOCH=$(echo "$FRONTMATTER_DATE_EPOCH_TIME + (3600*24*367)" | bc ) 
    ASSIGNED_DATE_EPOCH_RAND=$(echo "$ASSIGNED_DATE_EPOCH + $RANDNUM" | bc ) ;
    ASSIGNED_DATE_FORMATTED=$(date -r $ASSIGNED_DATE_EPOCH_RAND +'%Y-%m-%dT%H:%M:%S') ;
    ##
    echo "$ASSIGNED_DATE_FORMATTED" ;
}
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
function func_replace_date_in_existing_mdfile () {
    ## REPLACING THE EXISTING DATE LINE WITH THE NEW ASSIGNED DATE LINE
    mdfile="$1" ;
    ASSIGNED_DATE_FORMATTED="$2" ;
    echo ">> PERFORMING ACTUAL REPLACEMENT OF THE DATE IN ORIGINAL FILE = $mdfile" ;
    #### On Mac OS, sed requires a chosen 'backup file extension' after using sed -i
    #### WE'LL USE .bak EXTENSION FOR THIS
    #### COMMENT THE FOLLOWING LINE IF YOU ARE JUST DOING A TEST TO SEE WHICH FILES WILL BE CHANGED BEFORE
    #### ACTUALLY UPDATING THEM IN PLACE. CURRENTLY UPDATING THE CURRENT FILE IN PLACE.
    sed -i .bak "s/^date:.*$/date: $ASSIGNED_DATE_FORMATTED/" $mdfile ;
    ##
    #echo ">> DELETING TEMPORARY BACKUP FILE CREATED DURING RUNNING SED COMMAND = $mdfile.bak" ;
    rm $mdfile.bak
    ##
}

##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
function func_MAIN_get_dates_from_frontmatter_and_replace_date () {
    ## PERFORM DATE EXTRACTION FOR EACH FILE AND PRINT OUTPUTS TO TMP FILE
    (( COUNT_NUMFILES++ ))
    mdfile="$1" ;
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
    FRONTMATTER_DATE="$(grep -irh '^date: ' $mdfile | sort -n | sed -e 's/date: //g' -e 's/+00:00//g' )" ;
    FRONTMATTER_DATE_EPOCH_TIME=$(date -j -f '%Y-%m-%dT%H:%M:%S' "$FRONTMATTER_DATE" +'%s') ;

    ## PRINTING SOME IMPORTANT STUFF FOR DEBUGGING
    echo "CURRENT FILENAME = $mdfile" ;
    echo "FRONTMATTER_DATE = $FRONTMATTER_DATE // NEW_DATE (=> date $DATE_SHIFT_BY_NUMDAYS days ago from today) = $NEW_DATE_FORMATTED" ;

    datediff_in_days=$(func_calculate_days_difference_btwn_two_epoch_dates "$NEW_DATE_EPOCH" "$FRONTMATTER_DATE_EPOCH_TIME") ;

    ## PRINTING SOME DETAILS TO A TMP FILE
    echo >> $TMP_OUTPUT_FILE ; ## writing blank line
    echo "FILE_COUNT = $COUNT_NUMFILES" >> $TMP_OUTPUT_FILE ;
    echo "FILENAME = $mdfile" >> $TMP_OUTPUT_FILE ;
    echo "$FRONTMATTER_DATE = DATE FOUND IN YAML FRONTMATTER" >> $TMP_OUTPUT_FILE ;
    echo "$NEW_DATE = NEW_DATE (=> date $DATE_SHIFT_BY_NUMDAYS days ago from today)" >> $TMP_OUTPUT_FILE ;

    ################## BEGIN : IF-ELSE LOOP ######################################
    ## Only updating the dates if the date in existing frontmatter is older
    ## and the date difference is more than zero.
    if [[ $datediff_in_days -gt 0 ]] ; then
        (( COUNT_VALID++ ))
        msg_succ="//SUCCESS: $datediff_in_days days difference is more than 0 days. DATE WILL BE REPLACED." ; 
        echo "$msg_succ" ;       
        echo "$msg_succ" >> $TMP_OUTPUT_FILE ;
        ##################
        ## IMPORTANT NOTE: Choose only one option from below (uncomment the desired one)
        #### option#1: calculate radom date
        #ASSIGNED_DATE_FORMATTED="$(func_calculate_randomly_assigned_date_30days_ago)" ;
        #### option#2: calculate exact date relative to original frontmatter date
        ASSIGNED_DATE_FORMATTED="$(func_calculate_exact_date_1year_ago_from_frontmatter_date)" ;
        ##################
        echo "$ASSIGNED_DATE_FORMATTED = ASSIGNED DATE FINAL (AFTER MODIFIED H:M:S)" >> $TMP_OUTPUT_FILE ;
        ## Actual date replacement in original md file
        func_replace_date_in_existing_mdfile "$mdfile" "$ASSIGNED_DATE_FORMATTED" ;
        ##
    else
        (( COUNT_INVALID++ ))
        msg_fail="//FAILURE = datediff_in_days => $datediff_in_days days difference is less than 0. DATE WILL NOT BE REPLACED." ; 
        echo "$msg_fail" ;       
        echo "$msg_fail" >> $TMP_OUTPUT_FILE ;
    fi
    ################## END : IF-ELSE LOOP ######################################
}
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
function func_display_summary () {
    echo "=======================================================================" ;
    echo "SUMMARY OF RESULTS:" ;
    echo "-----------------------------------------------------------------------" ;
    echo "CHOSEN OLDEST DATE ($DATE_SHIFT_BY_NUMDAYS days ago from today) = $NEW_DATE_FORMATTED // $NEW_DATE // $NEW_DATE_EPOCH (EPOCH)" ;
    echo "-----------------------------------------------------------------------" ;
    echo "// COUNT OF TOTAL FILES = $COUNT_NUMFILES files"
    echo "// DATE CHANGE COMPLETED FOR = $COUNT_VALID files"
    echo "// DATE IS ALREADY OKAY FOR = $COUNT_INVALID files" ;
}
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
function func_rename_backup_zipfile () {
    ## FINALLY RENAMING THE BACKUP ZIP FILE WITH NEW INFORMATION POINTERS
    #### Getting the basename of the zipfile
    NEW_ZIPFILE_FULL_PREFIX=$(basename $BACKUP_ZIPFILE_NAME .zip) ;
    NEW_ZIPFILE_FULL_NAME="$PWD/$NEW_ZIPFILE_FULL_PREFIX-Total-$COUNT_NUMFILES-Changed-$COUNT_VALID-Unchanged-$COUNT_INVALID.zip" ;
    #### Renaming
    mv "$BACKUP_ZIPFILE_NAME" "$NEW_ZIPFILE_FULL_NAME" ;
    ##
    echo;
    echo "BACKUP file renamed from =>" ;
    echo "// OLD_NAME => $BACKUP_ZIPFILE_NAME" ;
    echo "// NEW_NAME => $NEW_ZIPFILE_FULL_NAME" ;
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


################################################################################
for mdfile in $(find $HUGO_CONTENT_DIR -name '*.md' );
do
    func_MAIN_get_dates_from_frontmatter_and_replace_date "$mdfile"
done
################################################################################

func_display_summary ;
func_rename_backup_zipfile ;