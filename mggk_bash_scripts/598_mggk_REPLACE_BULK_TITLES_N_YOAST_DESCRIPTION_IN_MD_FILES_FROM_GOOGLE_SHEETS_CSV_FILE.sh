#!/bin/bash
#echo "It's dangerous to run this script. Edit this original script if you want to execute it." ;
#exit 1

################################################################################
################################################################################
THIS_SCRIPT_NAME="598_mggk_REPLACE_BULK_TITLES_N_YOAST_DESCRIPTION_IN_MD_FILES_FROM_GOOGLE_SHEETS_CSV_FILE.sh"
REQUIREMENTS_FILE="598_MGGK_REQUIREMENT_FILE_CSV_FROM_GOOGLE_SHEETS.CSV"
################################################################################
HUGO_CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content"
MY_PWD="$HOME/Desktop/X/"
cd $MY_PWD ;
echo "Current working directory = $MY_PWD" ;
################################################################################
## SETTING VARIABLES
TMP_OUTPUT_CSVFILE="_TMP_OUTPUT_598_MGGK_VALID_URLS.CSV"
## INITIALIZING TMP OUTPUT CSV FILE
echo "MY_MDFILENAME, COUNT, CSVURL, CSVTITLE, CSVYOASTDESC" > $TMP_OUTPUT_CSVFILE
################################################################################

cat << EOF
  ################################################################################
  ## THIS BASH SCRIPT REPLACES TITLES AND YOAST_DESCRIPTION IN ORIGINAL MD FILES,
  ## USING A CSV FILE DOWNLOADED FROM GOOGLE SHEETS (REQUIREMENTS_FILE). THIS CSV
  ## FILE SHOULD BE PRESENT IN $(pwd) AND SHOULD ONLY HAVE THREE COLUMNS.
  ## COLUMNS = (URL, TITLE_VALUE, YOAST_DESCRIPTION_VALUE)
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
  ## CREATED ON: Monday December 2, 2019
  ## CREATED BY: Pali
  ################################################################################
EOF

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

## FUNCION_2 => REPLACES ORIGINAL TITLE IN MD FILE WITH NEW VALUE
REPLACE_ORIGINAL_TITLE_IN_THIS_MD_FILE_WITH_THIS_TITLE () {
  ## USAGE: THIS_FUNCION_NAME $1 $2
  ## (WHERE, $1 = MD_FILENAME // $2 = NEW_TITLE_VALUE)
  ## REPLACE_ORIGINAL_TITLE_IN_THIS_MD_FILE_WITH_THIS_TITLE MY_MDFILE NEW_TITLE_VALUE
  echo;
  mdfile="$1" ;
  NEW_TITLE="\"$2\"" ;
  EXISTING_TITLE="$(grep -irh '^title: ' $mdfile | sed 's/title: //g')" ;
  echo "    mdfile => $mdfile" ;
  echo "    OLD_TITLE => $EXISTING_TITLE" ;
  echo "    NEW_TITLE => $NEW_TITLE" ;
  if [ "$EXISTING_TITLE" = "$NEW_TITLE" ] ; then
    echo "    >>>> FAILURE // NEW TITLE = OLD TITLE. Hence, TITLE tag will not be changed in MD file." ;
  else
    echo "    >>>> SUCCESS // NEW TITLE != OLD TITLE. Hence, MD file TITLE tag will be updated." ;
    sed -i .bak "s|title: .*$|title: $NEW_TITLE|" $mdfile ;
    rm $mdfile.bak ;
  fi
  echo;
}

## FUNCION_3 => REPLACES ORIGINAL YOAST_DESCRIPTION IN MD FILE WITH NEW VALUE
REPLACE_ORIGINAL_METADESC_IN_MD_FILE_WITH_THIS_METADESC () {
  ## USAGE: THIS_FUNCION_NAME $1 $2
  ## (WHERE, $1 = MD_FILENAME // $2 = NEW_METADESC_VALUE)
  ## REPLACE_ORIGINAL_METADESC_IN_MD_FILE_WITH_THIS_METADESC MY_MDFILE NEW_METADESC_VALUE
  echo;
  mdfile="$1" ;
  NEW_METADESC="\"$2\"" ;
  EXISTING_METADESC="$(grep -irh '^yoast_description: ' $mdfile | sed 's/yoast_description: //g')" ;
  echo "    mdfile => $mdfile" ;
  echo "    OLD_METADESC => $EXISTING_METADESC" ;
  echo "    NEW_METADESC => $NEW_METADESC" ;
  if [ "$EXISTING_METADESC" = "$NEW_METADESC" ] ; then
    echo "    >>>> FAILURE // NEW_METADESC = OLD_METADESC. Hence, YOAST_DESCRIPTION tag will not be changed in MD file." ;
  else
    echo "    >>>> SUCCESS // NEW_METADESC != OLD_METADESC. Hence, MD file YOAST_DESCRIPTION tag will be updated." ;
    sed -i .bak "s|yoast_description: .*$|yoast_description: $NEW_METADESC|" $mdfile ;
    rm $mdfile.bak ;
  fi
  echo;
}
#### END: DEFINING MAIN FUNCTIONS ############################################
##------------------------------------------------------------------------------

##------------------------------------------------------------------------------
## READING REQUIREMENTS CSV FILE LINE-BY-LINE AND REPLACING TITLE AND
## YOAST_DESCRIPTION VALUES IN ORIGINAL MD FILE AFTER COMPARING EXISTING
## AND NEW VALUES
COUNT=0
while read line; do
  ((COUNT++))
  CSVURL=$(echo "$line" | csvcut -c 1) ## getting first_column
  CSVTITLE=$(echo "$line" | csvcut -c 2 | sed -e 's/"//g' -e 's/&/and/g') ## getting second_column
  CSVYOASTDESC=$(echo "$line" | csvcut -c 3 | sed -e 's/"//g' -e 's/&/and/g') ## getting third_column

  if [[ $CSVTITLE != "#N/A" ]]; then
    #echo
    echo "Currently working with line => $COUNT" ;
    #echo $CSVURL
    #echo $CSVTITLE
    #echo $CSVYOASTDESC
    MY_MDFILENAME=$(GET_MD_FILENAME_WITH_THIS_URL "$CSVURL")
    MY_MDFILENAME=$(echo "$MY_MDFILENAME" | tr -d '[:space:]') ; ## leading + trailing spaces removed.
    ########
    if [[ "$MY_MDFILENAME" != "" ]] ; then
      REPLACE_ORIGINAL_TITLE_IN_THIS_MD_FILE_WITH_THIS_TITLE "$MY_MDFILENAME" "$CSVTITLE"
      #REPLACE_ORIGINAL_METADESC_IN_MD_FILE_WITH_THIS_METADESC "$MY_MDFILENAME" "$CSVYOASTDESC"
      echo "\"$MY_MDFILENAME\",\"$COUNT\", \"$CSVURL\", \"$CSVTITLE\", \"$CSVYOASTDESC\"" >> $TMP_OUTPUT_CSVFILE
    fi
    ########
  else
    echo "Currently working with line => $COUNT. This line will not be included, because CSVTITLE = #N/A ." ;
  fi

done < $REQUIREMENTS_FILE;
##------------------------------------------------------------------------------
