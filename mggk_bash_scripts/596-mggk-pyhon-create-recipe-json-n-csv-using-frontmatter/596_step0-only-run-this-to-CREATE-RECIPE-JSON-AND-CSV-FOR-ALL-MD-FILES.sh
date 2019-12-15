#!/bin/bash

MY_PWD="$HOME/Desktop/X/"
#cd $MY_PWD ;
echo "Current working directory = $MY_PWD" ;

HUGO_CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content" ;
HUGO_CONTENT_SUBDIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/popular-posts" ;

PYTHON_SCRIPT_NAME="$HOME/Github/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/596-mggk-pyhon-create-recipe-json-n-csv-using-frontmatter/596_step1-mggk-CREATE-RECIPE-JSON-AND-RECIPE-CSV-FROM-FRONTMATTER-USING-PYTHON.py" ;

################################################################################
#### BEGIN: DEFINING MAIN FUNCTIONS ############################################
## FUNCION_1 => OUTPUTS A MD FILENAME FROM AN ARGUMENT URL
FUNC_GET_MD_FILENAME_WITH_THIS_URL () {
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

## FUNCION_2 => CREATES RECIPE JSON AND CSV FILES FOR EACH MD FILE FOUND IN HUGO_CONTENT_SUBDIR
FUNC_CREATE_JSON_N_CSV_FILES_FOR_ALL_MD_FILES_IN_HUGO_CONTENT_SUBDIR () {
  ## RUNNING FOR EACH MD FILE FOUND IN HUGO_CONTENT_DIR
  for url_term_found in $(grep -irh 'url: ' $HUGO_CONTENT_SUBDIR/* | sed 's/url: //g'); do
    echo;
    echo "################################################################"
    echo "url_term_found => $url_term_found" ;
    url=$( echo $url_term_found | sed -e 's|^|https://www.mygingergarlickitchen.com|g' -e 's| ||g' ) ;
    echo "Modified url => $url" ;

    MY_MDFILENAME=$(FUNC_GET_MD_FILENAME_WITH_THIS_URL $url)

    ## RUNNING THE FINAL PYTHON SCRIPT TO CREATE A JSON and CSV FOR THIS URL.
    echo ">> USING PYTHON CREATING RECIPE JSON AND CSV FILES FOR THIS MD FILE => $MY_MDFILENAME" ;
    python3 $PYTHON_SCRIPT_NAME $MY_MDFILENAME
  done
}

## FUNCION_3 => CREATES RECIPE JSON AND CSV FILES ONLY FOR THIS USER INPUT URL
FUNC_CREATE_JSON_N_CSV_FILES_FOR_THIS_URL_ONLY () {
  ## PROMPT FOR USER TO ENTER THE URL
  read -p "Enter your MGGK URL for which you want the RECIPE JSON and CSV FILES FOR: " TMPURL
  MY_MDFILENAME=$(FUNC_GET_MD_FILENAME_WITH_THIS_URL $TMPURL)
  ## RUNNING THE FINAL PYTHON SCRIPT TO CREATE A JSON and CSV FOR THIS URL.
  echo ">> USING PYTHON CREATING RECIPE JSON AND CSV FILES FOR THIS MD FILE => $MY_MDFILENAME" ;
  python3 $PYTHON_SCRIPT_NAME $MY_MDFILENAME
}

#### END: DEFINING MAIN FUNCTIONS ############################################
################################################################################

##------------------------------------------------------------------------------
## RUNNING THE FUNCTION (UNCOMMENT IF NECESSARY)
#FUNC_CREATE_JSON_N_CSV_FILES_FOR_ALL_MD_FILES_IN_HUGO_CONTENT_DIR
FUNC_CREATE_JSON_N_CSV_FILES_FOR_THIS_URL_ONLY
##------------------------------------------------------------------------------

## PRETTY PRINTING (ON CLI) OF ALL JSON FILES THUS PRODUCED BY ABOVE PYTHON SCRIPT
for jsonfile in *.json ; do cat $jsonfile | jq ; done
