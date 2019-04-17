#!/bin/bash
THIS_FILENAME="509-nofollow-link-maker-from-input-csv-file.sh" ;
REQUIRED_FILE1="509-REQUIREMENT-FILE-COMMA_SEPARATED.CSV" ;

################################################################################
cat <<EOF
################################################################################
## FILENAME = $THIS_FILENAME
################################################################################
## REQUIREMENTS :
#### FILE = $REQUIRED_FILE1 should be present in PWD.
################################################################################
## THIS FILE CREATES READYMADE NOFOLLOW LINKS TEXT FROM AN INPUT CSV FILE.
## USAGE:
#### > sh $THIS_FILENAME
#### WHERE \$1 = INPUT CSV FILE WITH 3 COLUMNS [md_filename, anchorText, URL]
################################################################################
######### STRUCTURE OF MYFILE_COMMA_SEPARATED.CSV ##############################
## NOTE: This in a csv file with 3 columns => [md_filename, anchorText, URL]
#### ...
#### ...
#### 2018-03-19-gut-friendly-delicious-indian-kanji-for-your-tummy.md, Google is great, http://www.google.com
#### 2018-03-30-things-to-consider-for-the-right-cold-brew.md, Yahoo is great, http://www.google.com
#### 2018-04-02-examples-of-regional-dishes-in-south-france.md, Goto Concepro Website, https://www.concepro.com
#### ...
#### ...
################################################################################
EOF

PWD=$(pwd);
echo;
echo ">>>> PRESENT WORKING DIRECTORY = $PWD" ;
echo;

## USER COFIRMATION:
read -p "Confirm that PWD = $PWD is correct working directory. Press ENTER key to continue..." ;
echo;

################################################################################
## UNCOMMENT THE FOLLOWING LINE FOR TESTING
## REQUIRED_FILE1="$HOME/GitHub/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/_REQUIREMENT_FILES_MGGK/509-REQUIREMENT-FILE-COMMA_SEPARATED.CSV" ;
MY_FILE="$REQUIRED_FILE1" ;
TMP_OUTPUT_FILE="_TMP_$MY_FILE" ;
OUTPUT_HTML_FILE="_TMP_HTML_OUTPUT.HTML" ;

## CHECKING IF REQUIRED_FILE EXISTS ...
if [ -z $MY_FILE ]; then
  echo "REQUIRED_FILE not found= $MY_FILE " ;
  echo "Script exiting ...." ;
  exit 1
fi

################################################################################
## Initializing OUTPUT HTML FILE
echo "<p>Created on: $(date) </p>" > $OUTPUT_HTML_FILE ;
echo "<h1>List of created NoFollow links - ready for copy-pasting in markdown files</h1>" >> $OUTPUT_HTML_FILE ;

## Saving to TMP file with all blank lines are removed.
sed '/^$/d' $MY_FILE > $TMP_OUTPUT_FILE ;

## Going thru line by line
COUNT=0;
while IFS=, read -r col1 col2 col3
do
  ((COUNT++))

  ## FIRST LETS TRIM ALL LEADING AND TRAILING WHITESPACES FROM ALL THESE VARIABLES
  col1="$( echo "${col1}" | sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g' )" ;
  col2="$( echo "${col2}" | sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g' )" ;
  col3="$( echo "${col3}" | sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g' )" ;

    echo; echo ;
    echo "COUNT = $COUNT" ;
    echo "FILE_NAME = $col1"
    echo "ANCHOR_TEXT = $col2"
    echo "URL = $col3";
    echo "NO-FOLLOW LINK TO BE COPIED => <a href='$col3' rel='nofollow'>$col2</a>";

## PRINTING TO HTML OUTPUT FILE
tee -a $OUTPUT_HTML_FILE <<MYOUT
  <p>
  <span style='font-size: 30px ;'>$COUNT &rArr;</span>
  <br>FILE_NAME = $col1
  <br>ANCHOR_TEXT = $col2
  <br>URL = $col3
  <br><span style='color: blue;'>Copy this:</span>
  <textarea rows='1' cols='150'> <a href='$col3' rel='nofollow'>$col2</a> </textarea>
  </p>
MYOUT

done < $TMP_OUTPUT_FILE

################################################################################
################ PROGRAM ENDS###################################################

## Opening PWD
open $PWD
open $OUTPUT_HTML_FILE
