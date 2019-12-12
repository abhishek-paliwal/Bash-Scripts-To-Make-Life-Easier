#!/bin/bash

HUGO_CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/popular-posts" ;

MY_PWD="$HOME/Desktop/X/"
#cd $MY_PWD ;
echo "Current working directory = $MY_PWD" ;

################################################################################
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

################################################################################

PYTHON_SCRIPT_NAME="CREATE-RECIPE-JSON-AND-RECIPE-CSV-FROM-FRONTMATTER-USING-PYTHON.py" ;

## RUNNING FOR EACH MD FILE FOUND IN HUGO_CONTENT_DIR
for url_term_found in $(grep -irh 'url: ' $HUGO_CONTENT_DIR/* | sed 's/url: //g'); do
  echo;
  echo "################################################################"
  echo "url_term_found => $url_term_found" ;
  url=$( echo $url_term_found | sed -e 's|^|https://www.mygingergarlickitchen.com|g' -e 's| ||g' ) ;
  echo "Modified url => $url" ;
  #FUNC_MAKE_RECIPE_CSV_FROM_JSON_USING_PYTHON $url ;

  MY_MDFILENAME=$(GET_MD_FILENAME_WITH_THIS_URL $url)

  ## RUNNING THE FINAL PYTHON SCRIPT TO CREATE A CSV FOR THIS URL.
  echo "EXECUTING PYTHON SCRIPT NOW FOR MD FILE => $MY_MDFILENAME" ;
  python3 $PYTHON_SCRIPT_NAME $MY_MDFILENAME
done

##------------------------------------------------------------------------------
## PROMPT FOR USER TO ENTER THE URL
#read -p "Enter your MGGK URL for which you want the RECIPE JSON and CSV FILES FOR: "  TMPURL
