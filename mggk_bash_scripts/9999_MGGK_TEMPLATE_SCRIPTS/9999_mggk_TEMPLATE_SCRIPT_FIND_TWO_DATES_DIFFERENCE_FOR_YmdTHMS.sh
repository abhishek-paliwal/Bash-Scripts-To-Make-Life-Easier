#!/bin/bash
################################################################################
THIS_PROGRAM_NAME="9999_mggk_TEMPLATE_SCRIPT_FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS.sh" ;
MAIN_FUNCION_NAME="FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS_on_MacOS_or_Linux" ;
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ################################################################################
  ## THIS PROGRAM CALCULATES THE DIFFERENCE BETWEEN TWO DATES.
  ## Whether the program is being run on Mac OS or Linux, it works accordingly.
  ## Just for reference, uname on Mac OS = "Darwin", and uname on Linux = "Linux"
  ## The only thing for you to remember is to format the input dates as: %Y-%m-%dT%H:%M:%S
  ################################################################################
  ## USAGE -> ARGUMENTS EXPLANATION:
  ## Call the function by assigning it to a variable:
  ## YOUR_OUTPUT_VAR=\$($MAIN_FUNCION_NAME \$1 \$2 \$3)
  #### where,
  #### \$1 (smaller date) and \$2 (bigger date) are two date variables,
  ####### ... formatted as %Y-%m-%dT%H:%M:%S (eg: 2019-09-21T15:32:56)
  #### \$3 = Any of "days" OR "minutes" OR "seconds"
  #### COMMAND EXAMPLE:
  #### YOUR_OUTPUT_VAR=\$($MAIN_FUNCION_NAME \$OLD_DATE \$NEW_DATE "seconds" \$uname)
  ################################################################################
  ## USAGE -> FROM ANOTHER BASH SCRIPT:
  ## This function should be called from an another bash script. Run these commands for that:
  ## >>>>
  ## DIR_SCRIPT="\$DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/9999_MGGK_TEMPLATE_SCRIPTS"
  ## source \$DIR_SCRIPT/9999_mggk_TEMPLATE_SCRIPT_FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS.sh ;
  ## OLD_DATE="2020-10-30T12:00:00" ; ## Example past date ...
  ## NEW_DATE="\$(date +%Y-%m-%dT%H:%M:%S)" ;
  ## DATE_DIFFERENCE_IN_MINUTES=\$(FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS_on_MacOS_or_Linux \$OLD_DATE \$NEW_DATE "minutes")
  ## DATE_DIFFERENCE_IN_SECONDS=\$(FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS_on_MacOS_or_Linux \$OLD_DATE \$NEW_DATE "seconds")
  ## DATE_DIFFERENCE_IN_DAYS=\$(FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS_on_MacOS_or_Linux \$OLD_DATE \$NEW_DATE "days")
  ################################################################################
  ## CREATED ON: November 16, 2019
  ## CREATED BY: Pali
  ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
##------------------------------------------------------------------------------
## BEGIN: MAIN FUNCTION DEFINITION
##------------------------------------------------------------------------------
FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS_on_MacOS_or_Linux() {
  OLD_DATE="$1" ;
  NEW_DATE="$2" ;
  OUTPUT_DURATION="$3" ;

  ## Check the OS, and then transform the dates differently to work in a similar
  ## way on MacOS (=Darwin) as well as Linux
  OS_NAME=$(uname) ;
  if [[ "$OS_NAME" == "Darwin" ]] ; then
  OLD_DATE_FORMATTED=$(date -j -f '%Y-%m-%dT%H:%M:%S' "$OLD_DATE" +%s) ;
  NEW_DATE_FORMATTED=$(date -j -f '%Y-%m-%dT%H:%M:%S' "$NEW_DATE" +%s) ;
  else
    OLD_DATE_FORMATTED=$(date -d "$OLD_DATE" +%s) ;
    NEW_DATE_FORMATTED=$(date -d "$NEW_DATE" +%s) ;
  fi

  ## Caculate date difference based upon OUTPUT_DURATION
  if [[ "$OUTPUT_DURATION" == "days" ]] ; then
    ## Date Difference in days
    datediff=$(echo "scale=6; ($NEW_DATE_FORMATTED - $OLD_DATE_FORMATTED)/86400" | bc) ;
  elif [[ "$OUTPUT_DURATION" == "minutes" ]] ; then
    ## Date Difference in minutes
    datediff=$(echo "scale=2; ($NEW_DATE_FORMATTED - $OLD_DATE_FORMATTED)/60" | bc) ;
  elif [[ "$OUTPUT_DURATION" == "seconds" ]] ; then
    ## Date Difference in seconds
    datediff=$(echo "scale=2; ($NEW_DATE_FORMATTED - $OLD_DATE_FORMATTED)" | bc) ;
  fi

  ## PRINTING THE FINAL RESULT
  echo $datediff ;
}
##------------------------------------------------------------------------------
## END: MAIN FUNCTION DEFINITION
##------------------------------------------------------------------------------

## CREATING A TESTING FUNCION TO TEST THE ABOVE FUNCTION WITH DEFAULT VALUES
TESTING_THE_MAIN_FUNCTION() {
  OLD_DATE=$(date '+%Y-%m-%dT%H:%M:%S')
  sleep 2s ## Wait for 9 seconds
  NEW_DATE=$(date '+%Y-%m-%dT%H:%M:%S')

  echo "INPUT_OLD_DATE = $OLD_DATE" ;
  echo "INPUT_NEW_DATE = $NEW_DATE" ;
  echo;

  ## FINAL RESULTS PRINTING
  datediff_in_days=$( FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS_on_MacOS_or_Linux $OLD_DATE $NEW_DATE "days")
  datediff_in_minutes=$( FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS_on_MacOS_or_Linux $OLD_DATE $NEW_DATE "minutes")
  datediff_in_seconds=$( FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS_on_MacOS_or_Linux $OLD_DATE $NEW_DATE "seconds")

  echo "Dates difference = $datediff_in_days days"
  echo "Dates difference = $datediff_in_minutes minutes"
  echo "Dates difference = $datediff_in_seconds seconds"
}

##------------------------------------------------------------------------------
## Testing block
## (Uncomment for development and testing purposes. Otherwise, comment the following line when in production)
#TESTING_THE_MAIN_FUNCTION

##------------------------------------------------------------------------------
## For calling the main function from another bash script, test it by creating
## a blank test.sh file and copy-paste the following code (and uncomment all lines there.)
## ====================================
#   #!/bin/bash
#   source 9999_mggk_TEMPLATE_SCRIPT_FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS.sh
#   START_TIME=$(date '+%Y-%m-%dT%H:%M:%S') ;
#   sleep 2s ;
#   END_TIME=$(date '+%Y-%m-%dT%H:%M:%S') ;
#   DURATION_RAN=$( FIND_TWO_DATES_DIFFERENCE_FOR_YmdTHMS_on_MacOS_or_Linux $START_TIME $END_TIME "minutes") ;
#   echo "  >> DURATION: $DURATION_RAN minutes" ;
## =====================================
