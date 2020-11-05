#!/bin/bash
################################################################################
THIS_SCRIPT_NAME="$(basename $0)" ;
REQUIREMENTS_FILE_DIR="$DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/_REQUIREMENT_FILES_MGGK" ;
REQUIREMENTS_FILE="$REQUIREMENTS_FILE_DIR/599_MGGK_RATING_REQUIREMENT_FILE_CSV_FROM_GOOGLE_SHEETS.csv" ;
##
SUMMARY_DIR="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL/_mggk_summary_files" ;
SUMMARY_FILE="$SUMMARY_DIR/_mggk_summary_rating_last_updated.txt" ;
##
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ################################################################################
  ## THIS BASH SCRIPT REPLACES RATING COUNT AND RATING VALUE IN ORIGINAL MD FILES,
  ## USING A CSV FILE DOWNLOADED FROM GOOGLE SHEETS (REQUIREMENTS_FILE). THIS CSV
  ## FILE SHOULD BE PRESENT IN REQUIREMENTS_DIRECTORY AND SHOULD ONLY HAVE TWO COLUMNS.
  ## COLUMNS = (URL, UNIQUE_PAGEVIEWS_PER_90_DAYS)
  ##------------------------------------------------------------------------------
  ## IMPORTANT NOTE:
  ## MAKE SURE TO DOWNLOAD THE LATEST CSV FILE FROM GOOGLE ANALYTICS EVERY MONTH
  ## TO UPDATE THE VALUES, CONTAINING DATA FOR LAST 90 DAYS.
  ## UPDATE DATA IN THIS GOOGLE SHEET ONLINE, THEN DOWNLOAD (AND RENAME) REQUIREMENTS CSV: 
  ## _For_script_599_MGGK-Analytics-last-90-days#2020_Aug03-Nov01
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

################################################################################
HUGO_CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content" ;
MY_PWD="$HOME_WINDOWS/Desktop/Y"
cd $MY_PWD ;
echo "Current working directory = $MY_PWD" ;
echo;echo;
################################################################################
## SETTING VARIABLES
DATEVAR="$(date +%Y%m%d-%H%M%S)";
TMP_OUTPUT_CSVFILE="$MY_PWD/_TMP_OUTPUT_SUMMARY_599_MGGK_RATING_VALID_URLS-$DATEVAR.csv"
## INITIALIZING TMP OUTPUT CSV FILE
echo "MY_MDFILENAME, COUNT, CSVURL, 90DAYS_PAGEVIEWS, EXISTING_CSVRATINGCOUNT, NEW_RATINGCOUNT_INCREASED_BY, NEW_RATINGCOUNT, EXISTING_CSVRATINGVALUE, NEW_RATINGVALUE, NEW_RATINGVALUE_CHANGE_FACTOR" > $TMP_OUTPUT_CSVFILE
################################################################################
## CALCULATION VARIABLES (CHANGE AS NEEDED)
NUM_DAYS_DATA_IN_REQUIREMENTS_CSVFILE="90" ;
PERCENTAGE_OF_USERS_WHO_RATED="0.04" ; ## Let's say that 4% users provided rating out of total users
################################################################################

## GETTING COLUMN NAMES FROM CSV FILE:
echo; echo; echo "Following column names are found in CSV FILE => $REQUIREMENTS_FILE" ;
csvcut -n $REQUIREMENTS_FILE
################################################################################

##------------------------------------------------------------------------------
#### BEGIN: DEFINING MAIN FUNCTIONS ############################################
## FUNCTION_1 => OUTPUTS A MD FILENAME FROM AN ARGUMENT URL
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
REPLACE_ORIGINAL_RATINGCOUNT_RATINGVALUE_IN_THIS_MD_FILE_WITH_NEW_VALUES () {
  ## USAGE: THIS_FUNCION_NAME $1 $2
  ## (WHERE, $1 = MD_FILENAME // $2 = NEW_RATINGCOUNT)
  ##
  ################## RATING COUNT CALCULATIONS #######################
  echo;
  mdfile="$1" ;
  EXISTING_RATINGCOUNT="$(grep -irh 'ratingCount: ' $mdfile | sed 's/ratingCount: //g')" ;
  NEW_RATINGCOUNT_TMP="$2" ;

  ######################################
  ## RANDOM NUMBER GENERATION, GIVING EACH URL IN CSV FILE A 20% CHANCE TO
  ## INCREASE RATING IRRESPECTIVE OF THE NUMBER OF VISITORS
  MY_RANDOM=$(($RANDOM % 1000)) ; 
  if [ $MY_RANDOM -lt 200 ]; then 
    RANDOM_INCREASE_FACTOR=1 ;
  else
    RANDOM_INCREASE_FACTOR=0 ;
  fi
  ######################################

  CALCULATING_RATINGCOUNT_INCREASED_BY="(($NEW_RATINGCOUNT_TMP * $DAYS_SINCE_WEBSITE_LAST_UPDATED * $PERCENTAGE_OF_USERS_WHO_RATED) / $NUM_DAYS_DATA_IN_REQUIREMENTS_CSVFILE) + $RANDOM_INCREASE_FACTOR" ; ## adding random increase at the end ...
  echo "CALCULATING_RATINGCOUNT_INCREASED_BY = $CALCULATING_RATINGCOUNT_INCREASED_BY" ;
  
  NEW_RATINGCOUNT_INCREASED_BY=$(echo "scale=0; ($CALCULATING_RATINGCOUNT_INCREASED_BY)"  | bc ) ;
  NEW_RATINGCOUNT=$(echo "$EXISTING_RATINGCOUNT + $NEW_RATINGCOUNT_INCREASED_BY"  | bc ) ;

  echo "    mdfile => $mdfile" ;
  echo "    EXISTING_RATINGCOUNT => $EXISTING_RATINGCOUNT" ;
  echo "    NEW_RATINGCOUNT_INCREASED_BY => $NEW_RATINGCOUNT_INCREASED_BY" ;
  echo "    NEW_RATINGCOUNT => $NEW_RATINGCOUNT" ;
  ##
  echo "    >>>> Updating new ratingCount value ..." ;
  NEW_RATINGCOUNT=$(echo $NEW_RATINGCOUNT | tr -d [:space:]) ;
  ## Check the OS // MacOS (=Darwin) as well as Linux (=ubuntu)
  OS_NAME=$(uname) ;
  if [[ "$OS_NAME" == "Darwin" ]] ; then
    sed -i .bak "s|ratingCount: .*$|ratingCount: $NEW_RATINGCOUNT|" $mdfile ;
    rm $mdfile.bak ;
  else
    sed -i "s|ratingCount: .*$|ratingCount: $NEW_RATINGCOUNT|" $mdfile ;
  fi
  ##
  echo;
  ################## RATING VALUE CALCULATIONS #######################
  EXISTING_RATINGVALUE="$(grep -irh 'ratingValue: ' $mdfile | sed 's/ratingValue: //g')" ;
  ##
  ## Generating random raging value change factor, between 4.1 and 5.0
  ## This will be the average rating given by new users for this url
  NEW_RATINGVALUE_CHANGE_FACTOR=$( echo "scale=1; $(($RANDOM %10 + 41))/10" | bc ) ;
  ##
  ## Only change ratingValue when there is a change in ratingCount
  if [ $NEW_RATINGCOUNT_INCREASED_BY != 0 ]; then
    CALCULATING_RATINGVALUE="(($EXISTING_RATINGVALUE * $EXISTING_RATINGCOUNT) + ( $NEW_RATINGVALUE_CHANGE_FACTOR * $NEW_RATINGCOUNT_INCREASED_BY )) / ( $EXISTING_RATINGCOUNT + $NEW_RATINGCOUNT_INCREASED_BY)" ; 
    echo "CALCULATING_RATINGVALUE = $CALCULATING_RATINGVALUE" ;
    NEW_RATINGVALUE=$(echo "scale=1; $CALCULATING_RATINGVALUE"  | bc ) ;
  else 
    NEW_RATINGVALUE="$EXISTING_RATINGVALUE" ;
  fi 
  ##
  echo "    mdfile => $mdfile" ;
  echo "    EXISTING_RATINGVALUE => $EXISTING_RATINGVALUE" ;
  echo "    NEW_RATINGVALUE_CHANGE_FACTOR => $NEW_RATINGVALUE_CHANGE_FACTOR" ;
  echo "    NEW_RATINGVALUE => $NEW_RATINGVALUE" ;
  ##
  echo "    >>>> Updating new ratingValue value ..." ;
  NEW_RATINGVALUE=$(echo $NEW_RATINGVALUE | tr -d [:space:]) ;
  ## Check the OS // MacOS (=Darwin) as well as Linux (=ubuntu)
  OS_NAME=$(uname) ;
  if [[ "$OS_NAME" == "Darwin" ]] ; then
    sed -i .bak "s|ratingValue: .*$|ratingValue: $NEW_RATINGVALUE|" $mdfile ;
    rm $mdfile.bak ;
  else
    sed -i "s|ratingValue: .*$|ratingValue: $NEW_RATINGVALUE|" $mdfile ;
  fi
  ##
  echo;
  ##
  CSVURL="$3" ;
  echo "\"$mdfile\",\"$COUNT\", \"$CSVURL\", \"$NEW_RATINGCOUNT_TMP\",\"$EXISTING_RATINGCOUNT\", \"$NEW_RATINGCOUNT_INCREASED_BY\", \"$NEW_RATINGCOUNT\", \"$EXISTING_RATINGVALUE\", \"$NEW_RATINGVALUE\", \"$NEW_RATINGVALUE_CHANGE_FACTOR\"" >> $TMP_OUTPUT_CSVFILE
}

#### END: DEFINING MAIN FUNCTIONS ############################################
##------------------------------------------------------------------------------

##################################################################################
## USER INPUT FOR THE TIME WHEN LAST TIME SITE WAS MADE
echo; echo "##################################################################################" ;
echo "####################### ENTER USER INPUT ####################################" ; echo; 
say "Updating Rating Count and Rating Value ... How many days ago did you make the website last time (ENTER an integer, Or simply press ENTER key for no rating update) ... " ;
echo ">> Now updating Rating Count and Rating Value ..." ; echo;
##
echo ">>> $(cat $SUMMARY_FILE | sed 's/RATING_LAST_UPDATED://g' | head -1) = [INFO // RATINGS LAST UPDATED ON]" ; 
echo ">>> $(date +%Y-%m-%d) = DATE RIGHT NOW" ; echo; 
##
echo ">>>> [SEE ABOVE INFO] How many days ago did you make the website last time (ENTER an integer // 0=EXIT THIS SCRIPT) [0=today, 1=yesterday, 2=2 days ago, etc.]:" ;
echo ">>>> Press 0 then ENTER key, or simply ENTER key to MAKE NO CHANGE TO EXISTING RATINGS ... " ;
read DAYS_SINCE_WEBSITE_LAST_UPDATED
## Exit this script if zero entered
if [ "$DAYS_SINCE_WEBSITE_LAST_UPDATED" == 0 ] || [ "$DAYS_SINCE_WEBSITE_LAST_UPDATED" == "" ] ; then 
  echo ">>> NO CHANGE WILL BE DONE. This script will exit now."; 
  exit 1 ; 
fi
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
        REPLACE_ORIGINAL_RATINGCOUNT_RATINGVALUE_IN_THIS_MD_FILE_WITH_NEW_VALUES "$MY_MDFILENAME" "$CSVRATINGCOUNT" "$CSVURL"
    fi
    ########

done < $REQUIREMENTS_FILE;
##------------------------------------------------------------------------------

###################################################################
## OUTPUTTTING TIME TO SUMMARY FILE
echo "RATING_LAST_UPDATED: $(date +%Y-%m-%dT%H:%M:%S)" > $SUMMARY_FILE
