#!/bin/bash
###############################################################################
THIS_SCRIPT_NAME="597b-mggk-REPLACING-first_published_on_VARIABLE-VALUE-IN-YAML-FRONTMATTER-from-CSV-file.sh"
REQUIREMENTS_FILE="597b_MGGK_REQUIREMENT_FILE_CSV.CSV"
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ################################################################################
  ## THIS BASH SCRIPT REPLACES FIRST_PUBLISHED_ON TAG VALUES IN ORIGINAL MD FILES,
  ## USING A CSV FILE (REQUIREMENTS_FILE). THIS CSV
  ## FILE SHOULD BE PRESENT IN $(pwd) AND SHOULD ONLY HAVE TWO COLUMNS.
  ## COLUMNS = (URL, PUBLISHED_DATETIME)
  ##------------------------------------------------------------------------------
  ## REQUIREMENTS_FILE = $REQUIREMENTS_FILE
  ##------------------------------------------------------------------------------
  ## USAGE:
  ## bash $THIS_SCRIPT_NAME
  ##------------------------------------------------------------------------------
  ## IMPORTANT NOTE:
  ## This bash program uses a python command-line utility 'csvkit', which can be
  ## installed by running => pip3 install csvkit
  ## Learn more at: https://csvkit.readthedocs.io/en/latest/index.html
  ##------------------------------------------------------------------------------
  ## CREATED ON: Monday December 2, 2019
  ## CREATED BY: Pali
  ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
##################################################################################
HUGO_CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content"
MY_PWD="$HOME/Desktop/X/"
cd $MY_PWD ;
echo "Current working directory = $MY_PWD" ;
################################################################################
## SETTING VARIABLES
TMP_OUTPUT_CSVFILE="_TMP_OUTPUT_597b_MGGK_VALID_URLS.CSV"
## INITIALIZING TMP OUTPUT CSV FILE
echo "MY_MDFILENAME, COUNT, CSVURL, CSV_PUBLISHED_DATETIME" > $TMP_OUTPUT_CSVFILE
################################################################################

##################################################################################
## GETTING COLUMN NAMES FROM CSV FILE:
echo "Following column names are found in CSV FILE => $REQUIREMENTS_FILE" ;
csvcut -n $REQUIREMENTS_FILE
################################################################################

##------------------------------------------------------------------------------
#### BEGIN: DEFINING MAIN FUNCTIONS ############################################
## FUNCION_1 => OUTPUTS A MD FILENAME FROM AN ARGUMENT URL
GET_MD_FILENAME_WITH_THIS_URL () {
  ## USAGE: THIS_FUNCION_NAME $1
  ## (WHERE, $1 = A WP.MGGK.COM URL, SUCH AS http://www.wp.mygingergarlickitchen.com/example/)
  ## MY_MDFILENAME=$(GET_MD_FILENAME_WITH_THIS_URL MY_URL)
  TMPURL=$1
  SEARCHURL=$(echo "$TMPURL" | sed 's|https://www.wp.mygingergarlickitchen.com||g')
  ## EXIT THE SCRIPT IF THE ENTERED URL IS NOT PROPER
  if [[ "$SEARCHURL" == "/" ]] || [[ "$SEARCHURL" == "" ]] ; then
    MY_MDFILENAME="" ; ## is blank.
  else
    MY_MDFILENAME=$(grep -irl "^url: $SEARCHURL" $HUGO_CONTENT_DIR | head -1)
  fi
  echo "$MY_MDFILENAME"
}

## FUNCION_2 => REPLACES ORIGINAL first_published_on VALUE IN MD FILE WITH NEW VALUE
REPLACE_ORIGINAL_FIRST_PUBLISHED_ON_TAG_VALUE_IN_THIS_MD_FILE_WITH_THIS_VALUE () {
  ## USAGE: THIS_FUNCION_NAME $1 $2
  ## (WHERE, $1 = MD_FILENAME // $2 = NEW_TAG_VALUE_in_DATETIME)
  ## REPLACE_ORIGINAL_FIRST_PUBLISHED_ON_TAG_VALUE_IN_THIS_MD_FILE_WITH_THIS_VALUE MY_MDFILE NEW_TAG_VALUE
  echo;
  mdfile="$1" ;
  NEW_TAG_VALUE="$2" ;
  EXISTING_TAG_VALUE="$(grep -irh '^first_published_on: ' $mdfile | sed 's/first_published_on: //g')" ;
  echo "    mdfile => $mdfile" ;
  echo "    OLD_TAG_VALUE => $EXISTING_TAG_VALUE" ;
  echo "    NEW_TAG_VALUE => $NEW_TAG_VALUE" ;
  echo "    >>>> SUCCESS // FIRST_PUBLISHED_ON tag value will be replaced in MD file." ;
  ## ACTUAL REPLACEMENT IN FILE INLINE
  sed -i .bak "s|first_published_on: .*$|first_published_on: $NEW_TAG_VALUE|" $mdfile ;
  rm $mdfile.bak ;
  echo;
}

#### END: DEFINING MAIN FUNCTIONS ############################################
##------------------------------------------------------------------------------

##------------------------------------------------------------------------------
## READING REQUIREMENTS CSV FILE LINE-BY-LINE AND REPLACING FIRST_PUBLISHED_ON TAG VALUE
## IN ORIGINAL MD FILE AFTER COMPARING EXISTING AND NEW VALUES
COUNT=0
while read line; do
  ((COUNT++))
  CSVURL=$(echo "$line" | csvcut -c 1) ## getting first_column
  CSV_PUBLISHED_DATETIME=$(echo "$line" | csvcut -c 2 | sed -e 's/ //g') ## getting second_column

  echo;
  echo "Currently working with line => $COUNT" ;
  echo $CSVURL
  echo $CSV_PUBLISHED_DATETIME
  MY_MDFILENAME=$(GET_MD_FILENAME_WITH_THIS_URL "$CSVURL")
  ########
  if [[ "$MY_MDFILENAME" != "" ]] ; then
    REPLACE_ORIGINAL_FIRST_PUBLISHED_ON_TAG_VALUE_IN_THIS_MD_FILE_WITH_THIS_VALUE "$MY_MDFILENAME" "$CSV_PUBLISHED_DATETIME"
    echo "\"$MY_MDFILENAME\",\"$COUNT\", \"$CSVURL\", \"$CSV_PUBLISHED_DATETIME\"" >> $TMP_OUTPUT_CSVFILE
  fi
  ########
done < $REQUIREMENTS_FILE;
##------------------------------------------------------------------------------
