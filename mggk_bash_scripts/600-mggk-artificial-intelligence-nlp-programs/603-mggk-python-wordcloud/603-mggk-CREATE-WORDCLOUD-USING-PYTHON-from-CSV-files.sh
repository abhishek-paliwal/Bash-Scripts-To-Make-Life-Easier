#!/bin/bash
###############################################################################
THIS_SCRIPT_NAME="603-mggk-CREATE-WORDCLOUD-USING-PYTHON-from-CSV-files.sh"
################################################################################
MY_PWD="$HOME/Desktop/X/"
cd $MY_PWD ;
echo "Current working directory = $MY_PWD" ;
################################################################################
## SETTING VARIABLES
INPUT_OUTPUT_DIR="$MY_PWD/_603_mggk_outputs"
mkdir $INPUT_OUTPUT_DIR
TMP_OUTPUT_CSVFILE="_TMP_OUTPUT_603_MGGK.CSV"
rm $TMP_OUTPUT_CSVFILE ## remove if already exists.
rm $INPUT_OUTPUT_DIR/*.png ## Remove all PNG wordcloud images, if exists.
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ################################################################################
  ## THIS BASH SCRIPT CREATES A WORDCLOUD IMAGES USING CSV FILES PRESENT IN PWD.
  ## THESE CSV FILES SHOULD HAVE A COLUMN_NAME = NLP_KEYWORDS
  ##------------------------------------------------------------------------------
  ## USAGE:
  ## bash $THIS_SCRIPT_NAME
  ##------------------------------------------------------------------------------
  ## IMPORTANT NOTE:
  ## This bash program uses two python command-line utilities: 'csvkit' and 'wordcloud_cli',
  ## which can be installed by running => pip3 install csvkit // pip3 install wordcloud
  ## Learn more at:
  ## https://csvkit.readthedocs.io/en/latest/index.html
  ## https://github.com/amueller/word_cloud
  ##------------------------------------------------------------------------------
  ## CREATED ON: Monday December 3, 2019
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
MAKE_WORDCLOUD_FROM_THIS_CSVFILE () {
  ## USAGE: MAKE_WORDCLOUD_FROM_THIS_CSVFILE $1 $2
  ## WHERE $1 = CSV_FILENAME // $2 = MINIMUM_WORD_LENGTH_TO_INCLUDE
  ########################################
  DATA_FILE="$1" ## can also be a simple text file with loads of text.
  MINIMUM_WORD_LENGTH_TO_INCLUDE="$2" ## 2nd ARGUMENT ON COMMAND LINE, IDEAL VALUE = 4
  WIDTH="1920"
  HEIGHT="1200"
  STOPWORDS_FILE="mggk_stopwords.txt"
  FONT_FILE="BebasNeue-Regular.otf"
  IMAGEFILE_TMP=$(echo $DATA_FILE | sed 's/\./_/g') ## replacing dots
  IMAGEFILE="$INPUT_OUTPUT_DIR/$IMAGEFILE_TMP-wordcloud-$MINIMUM_WORD_LENGTH_TO_INCLUDE-words.png"

  ########################################
  ## PRINTING
  echo ">>>> CURRENT RUNNING CSV FILE       = $DATA_FILE" ;
  echo ">>>> IMAGEFILE                      = $IMAGEFILE"
  echo ">>>> WIDTH                          = $WIDTH"
  echo ">>>> HEIGHT                         = $HEIGHT"
  echo ">>>> STOPWORDS_FILE                 = $STOPWORDS_FILE"
  echo ">>>> FONT_FILE                      = $FONT_FILE"
  echo ">>>> MINIMUM_WORD_LENGTH_TO_INCLUDE = $MINIMUM_WORD_LENGTH_TO_INCLUDE"
  ########################################

  ## GETTING COLUMN NAMES FROM CSV FILE:
  echo; echo "FOLLOWING COLUMN NAMES ARE FOUND IN THIS CSV FILE => $DATA_FILE" ;
  csvcut -n $DATA_FILE
  ## Select the keywords column and save as a new CSV file
  #csvcut -c NLP_KEYWORDS $DATA_FILE > $TMP_OUTPUT_CSVFILE
  #echo "NLP_KEYWORDS column has been saved to => $TMP_OUTPUT_CSVFILE" ;
  csvcut -c TITLE_TAG_VALUE $DATA_FILE > $TMP_OUTPUT_CSVFILE
  echo "TITLE_TAG_VALUE column has been saved to => $TMP_OUTPUT_CSVFILE" ;

  ## RUNNING THE ACTUAL WORDCLOUD MAKER FOR THIS CSV FILE
  echo; echo "Making final wordcloud ..." ;
  wordcloud_cli --text $TMP_OUTPUT_CSVFILE --imagefile $IMAGEFILE --width $WIDTH --height $HEIGHT --stopwords $STOPWORDS_FILE --fontfile $FONT_FILE --min_word_length $MINIMUM_WORD_LENGTH_TO_INCLUDE
  echo "++++ SUCCESS // wordcloud has been saved to => $IMAGEFILE" ;
}
## END: MAIN FUNCTION DEFINITION
##------------------------------------------------------------------------------

## Looping through all CSV/csv files in MY_PWD
for csvfile in $(find . -maxdepth 1 -iname '*.csv' -exec basename {} \;) ; do
  echo "///////////////////////////////////////////////////////////////////////";
  echo;
  MAKE_WORDCLOUD_FROM_THIS_CSVFILE $csvfile "3"
  MAKE_WORDCLOUD_FROM_THIS_CSVFILE $csvfile "4"
done
