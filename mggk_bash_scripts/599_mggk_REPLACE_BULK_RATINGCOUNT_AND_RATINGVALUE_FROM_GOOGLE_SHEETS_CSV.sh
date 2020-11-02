#!/bin/bash

#echo "VERY IMPORTANT NOTE: It's dangerous to run this script. Edit this original script if you want to execute it." ;
#exit 1

################################################################################
################################################################################
THIS_SCRIPT_NAME="$(basename $0)" ;
REQUIREMENTS_FILE="598_MGGK_RATING_REQUIREMENT_FILE_CSV_FROM_GOOGLE_SHEETS.csv" ;
############
## CALCULATION VARIABLES (CHANGE AS NEEDED)
############
NUM_DAYS_DATA_IN_REQUIREMENTS_CSVFILE="90" ;
PERCENTAGE_OF_USERS_WHO_RATED="0.04" ; ## Let's say that 4% users provided rating out of total users
NEW_RATINGVALUE_CHANGE_FACTOR="4.6" ; ## Let's say that average rating by new users is 4.5
################################################################################
#HUGO_CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/_FIXED" ;
HUGO_CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content" ;
MY_PWD="$HOME_WINDOWS/Desktop/Y"
cd $MY_PWD ;
echo "Current working directory = $MY_PWD" ;
################################################################################
## SETTING VARIABLES
TMP_OUTPUT_CSVFILE="$MY_PWD/_TMP_OUTPUT_598_MGGK_RATING_VALID_URLS.csv"
## INITIALIZING TMP OUTPUT CSV FILE
echo "MY_MDFILENAME, COUNT, CSVURL, CSVRATINGCOUNT, CSVRATINGVALUE" > $TMP_OUTPUT_CSVFILE
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ################################################################################
  ## THIS BASH SCRIPT REPLACES RATING COUNT AND RATING VALUE IN ORIGINAL MD FILES,
  ## USING A CSV FILE DOWNLOADED FROM GOOGLE SHEETS (REQUIREMENTS_FILE). THIS CSV
  ## FILE SHOULD BE PRESENT IN $(pwd) AND SHOULD ONLY HAVE TWO COLUMNS.
  ## COLUMNS = (URL, UNIQUE_PAGEVIEWS_PER_90_DAYS)
  ##------------------------------------------------------------------------------
  ## THE REQUIREMENTS_FILE IS $REQUIREMENTS_FILE
  ##------------------------------------------------------------------------------
  ## USAGE:
  ## bash $THIS_SCRIPT_NAME
  ##------------------------------------------------------------------------------
  ## IMPORTANT NOTE:
  ## This bash program uses a python command-line utility 'csvkit', which can be
  ## installed by running => pip3 install csvkit
  ## Learn more at: https://csvkit.readthedocs.io/en/latest/index.html
  ##------------------------------------------------------------------------------
  ## CREATED ON: November 2, 2020
  ## CREATED BY: Pali
  ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## GETTING COLUMN NAMES FROM CSV FILE:
echo "Following column names are found in CSV FILE => $REQUIREMENTS_FILE" ;
csvcut -n $REQUIREMENTS_FILE
################################################################################

##------------------------------------------------------------------------------
#### BEGIN: DEFINING MAIN FUNCTIONS ############################################
## FUNCION_1 => OUTPUTS A MD FILENAME FROM AN ARGUMENT URL
GET_MD_FILENAME_WITH_THIS_URL () {
  ## USAGE: THIS_FUNCION_NAME $1
  ## (WHERE, $1 = An MGGK URL, SUCH AS http://www.mygingergarlickitchen.com/example/)
  ## MY_MDFILENAME=$(GET_MD_FILENAME_WITH_THIS_URL MY_URL)
  TMPURL=$1
  SEARCHURL=$(echo "$TMPURL" | sed 's|https://www.mygingergarlickitchen.com||g');

  ## Check, how many files with this url are returned.
  NUM_FILES=$(grep -irl "^url: $SEARCHURL" $HUGO_CONTENT_DIR | wc -l | tr -d '[:space:]') ;
  ## Check whether this number is exactly 1.
  if [[ "$NUM_FILES" -eq 1 ]] ; then
    #echo ">>>>>> SUCCESS! Only 1 md file is found for this url. Good work :-)" ;
    MY_MDFILENAME=$(grep -irl "^url: $SEARCHURL" $HUGO_CONTENT_DIR) ;
  else
    #echo ">>>>>> ERROR: INVALID MGGK URL. Program found either zero, or more than 1 md files containing this URL." ;
    MY_MDFILENAME="" ; ## is blank.
  fi

  ## CHECK IF THE ENTERED URL IS NOT PROPER ( PROPER-URL = /some-text-here/ )
  if [[ "$SEARCHURL" == "/" ]] || [[ "$SEARCHURL" == "" ]] ; then
    MY_MDFILENAME="" ; ## is blank.
  fi

  ## RETURNING FINAL MY_MDFILENAME VAR VALUE.
  ## THIS SHOULD BE THE ONLY VALID ECHO OUTPUT IN WHOLE FUNCTION
  echo "$MY_MDFILENAME" ;
}

## FUNCTION_2 => REPLACES ORIGINAL RATINGCOUNT IN MD FILE WITH NEW VALUE
REPLACE_ORIGINAL_RATINGCOUNT_IN_THIS_MD_FILE_WITH_THIS_RATINGCOUNT () {
  ## USAGE: THIS_FUNCION_NAME $1 $2
  ## (WHERE, $1 = MD_FILENAME // $2 = NEW_RATINGCOUNT)
  echo;
  mdfile="$1" ;
  EXISTING_RATINGCOUNT="$(grep -irh 'ratingCount: ' $mdfile | sed 's/ratingCount: //g')" ;
  NEW_RATINGCOUNT_TMP="$2" ;
  NEW_RATINGCOUNT_INCREASED_BY=$(echo "(($NEW_RATINGCOUNT_TMP * $DAYSDIFF_FROM_OCT30_2020 * $PERCENTAGE_OF_USERS_WHO_RATED) / $NUM_DAYS_DATA_IN_REQUIREMENTS_CSVFILE)"  | bc ) ;
  NEW_RATINGCOUNT=$(echo "$EXISTING_RATINGCOUNT + $NEW_RATINGCOUNT_INCREASED_BY"  | bc ) ;

  echo "    mdfile => $mdfile" ;
  echo "    EXISTING_RATINGCOUNT => $EXISTING_RATINGCOUNT" ;
  echo "    NEW_RATINGCOUNT_INCREASED_BY => $NEW_RATINGCOUNT_INCREASED_BY" ;
  echo "    NEW_RATINGCOUNT => $NEW_RATINGCOUNT" ;
  #echo "    >>>> Updating new ratingCount value ..." ;
  #sed -i .bak "s|ratingCount: .*$|ratingCount: $NEW_RATINGCOUNT|" $mdfile ;
  #rm $mdfile.bak ;
  echo;
}

## FUNCTION_3 => REPLACES ORIGINAL RATINGVALUE IN MD FILE WITH NEW VALUE
REPLACE_ORIGINAL_RATINGVALUE_IN_THIS_MD_FILE_WITH_THIS_RATINGVALUE () {
  ## USAGE: THIS_FUNCION_NAME $1 $2
  ## (WHERE, $1 = MD_FILENAME // $2 = NEW_RATINGVALUE)
  echo;
  mdfile="$1" ;
  EXISTING_RATINGVALUE="$(grep -irh 'ratingValue: ' $mdfile | sed 's/ratingValue: //g')" ;
  NEW_RATINGVALUE_TMP="$2" ;
  NEW_RATINGVALUE=$(echo "scale=1; ($EXISTING_RATINGVALUE + $NEW_RATINGVALUE_CHANGE_FACTOR) / 2"  | bc ) ;

  echo "    mdfile => $mdfile" ;
  echo "    EXISTING_RATINGVALUE => $EXISTING_RATINGVALUE" ;
  echo "    NEW_RATINGVALUE => $NEW_RATINGVALUE" ;
  #echo "    >>>> Updating new ratingValue value ..." ;
  #sed -i .bak "s|ratingValue: .*$|ratingValue: $NEW_RATINGVALUE|" $mdfile ;
  #rm $mdfile.bak ;
  echo;
}

#### END: DEFINING MAIN FUNCTIONS ############################################
##------------------------------------------------------------------------------

##################################################################################
## FINDING THE DATES DIFFERENCE IN DAYS FROM OCT 30 2020 12PM TO THE PROGRAM RUNTIME ...
source $DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/9999_MGGK_TEMPLATE_SCRIPTS/9999_mggk_TEMPLATE_SCRIPT_FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS.sh ;
OLD_DATE="2020-10-30T12:00:00" ;
NEW_DATE="$(date +%Y-%m-%dT%H:%M:%S)" ;
DAYSDIFF_FROM_OCT30_2020=$(FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS_on_MacOS_or_Linux $OLD_DATE $NEW_DATE "days") ;
echo ">>>> NUMBER OF DAYS PASSED SINCE OCT_30_2020 => $DAYSDIFF_FROM_OCT30_2020" ;
##################################################################################

##------------------------------------------------------------------------------
## READING REQUIREMENTS CSV FILE LINE-BY-LINE AND REPLACING RATINGCOUNT AND
## RATINGVALUE VALUES IN ORIGINAL MD FILE
COUNT=0
while read line; do
    ((COUNT++))
    ## EXTRACT 1ST COLUMN, IF 1ST COLUMN VALUE IS A URL
    CSVURL=$(echo "$line" | csvcut -c 1) ## getting first_column

    ## EXTRACT 2ND COLUMN
    CSVRATINGCOUNT=$(echo "$line" | csvcut -c 2 | sed -e 's/"//g' -e 's/,//g') ## getting second_column
    CSVRATINGVALUE=$CSVRATINGCOUNT ;

    MY_MDFILENAME=$(GET_MD_FILENAME_WITH_THIS_URL "$CSVURL")
    MY_MDFILENAME=$(echo "$MY_MDFILENAME" | tr -d '[:space:]') ; ## leading + trailing spaces removed.

    echo ;
    echo "Currently working with line => $COUNT" ;
    echo ">>>> CSV_URL = $CSVURL" ;
    echo ">>>> CSVRATINGCOUNT = $CSVRATINGCOUNT" ;
    echo ">>>> MY_MDFILENAME = $MY_MDFILENAME" ;

    ########
    if [[ "$MY_MDFILENAME" != "" ]] ; then
        echo "  >>>> RUNNING FUNCTIONS ..." ;
        REPLACE_ORIGINAL_RATINGCOUNT_IN_THIS_MD_FILE_WITH_THIS_RATINGCOUNT "$MY_MDFILENAME" "$CSVRATINGCOUNT"
        REPLACE_ORIGINAL_RATINGVALUE_IN_THIS_MD_FILE_WITH_THIS_RATINGVALUE "$MY_MDFILENAME" "$CSVRATINGVALUE"
        echo "\"$MY_MDFILENAME\",\"$COUNT\", \"$CSVURL\", \"$CSVRATINGCOUNT\", \"$CSVRATINGVALUE\"" >> $TMP_OUTPUT_CSVFILE
    fi
    ########

done < $REQUIREMENTS_FILE;
##------------------------------------------------------------------------------
