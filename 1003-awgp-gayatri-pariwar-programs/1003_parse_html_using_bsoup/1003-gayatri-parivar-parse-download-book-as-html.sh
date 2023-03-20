#!/bin/bash
################################################################################
## THIS PROGRAM DOWNLOAD WEBPAGES AND PARSES THEM INTO A COMBINED HTML FILE RESUTING IN A SINGLE PAGE BOOK
################################################################################

THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
####
WORKDIR="$DIR_Y/_output_$THIS_SCRIPT_NAME_SANS_EXTENSION" ; 
mkdir -p $WORKDIR ; 
cd $WORKDIR ; 
####
inFileCSV="$CSV_AWGP" ## get from env variable
searchResultCSV="$WORKDIR/_tmp_searchResult.csv" ;
DIR_PROJECT="$REPO_SCRIPTS_AWGP/1003_parse_html_using_bsoup" ; 
DIR_OUTPUT="$WORKDIR" ; 
tmpConfigFile="$WORKDIR/_tmp_config_file.txt" ; 
echo > $tmpConfigFile ; ## initializing
####

##------------------------------------------------------------------------------
## sample configuration ##
#DIR_PROJECT="$REPO_SCRIPTS/1003-gayatri-parivar-book-making-programs"
#DIR_OUTPUT="$DIR_Y/_tmp_output_1003-gayatri-parivar-book-making-programs"
#BOOKNAME="Audiobook - अंधविश्वास को उखाड़ फेंकिये"
#BOOK_URL_PREFIX_WITH_DOT_IN_END="http://literature.awgp.org/book/andhvishwas_ko_ukhad_fenkiye/v1."
#LOCALPATH_PREFIX_WITH_DOT="file://$DIR_OUTPUT/v1." ;
#NUMPAGES_TO_EXTRACT=48 ;
##------------------------------------------------------------------------------

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## FUNCITON DEFINITIONS
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_SEARCH_VARS_BASED_UPON_NUM_MAXPAGES_URL () {
    ## USER INPUT:
    echo;  echo ">>>> PLEASE PROVIDE THE NUM MAXPAGES URL (OR press ENTER key to exit) =>" ;
    read search_term ; 
    echo;
    ##
    TMPFILE1="$WORKDIR/_tmp1.txt" ; 
    TMPFILE2="$WORKDIR/_tmp2.txt" ; 
    OUTFILE="$searchResultCSV" ; 
    ##
    head -1 $inFileCSV > $TMPFILE1
    grep -i "$search_term" $inFileCSV > $TMPFILE2
    cat $TMPFILE1 $TMPFILE2 > $OUTFILE
    ## Using miller command (mlr) to print the result in xtab format (c2x =  csv to xtab)
    echo ">>PRINTING THE FOUND BOOK DETAILS ..." ; 
    mlr --c2x --ifs ';' cat "$OUTFILE" ; 
    echo "##------------------------------------" ; 
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
### FOLLIWING ARE THE HEADING NAMES FROM THE MAIN AWGP CSV FILE
#BOOK_SERIAL_NUMBER
#BOOK_TYPE
#BOOK_NAME
#BOOK_NAME_TRANSLATED_ENGLISH
#BOOK_URL
#BOOK_NAME_ENGLISH_TRANSLITERATED
#BOOK_URL_HOME
#PDF_URLS
#NUM_MAX_PAGES
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_GET_SOME_PARAM_VALUES () {
    inFile="$searchResultCSV" ;
    ## consider first result line only
    ## PRIMARY VARIABLES
    BOOK_SERIAL_NUMBER=$(mlr --csv --ifs ';' --headerless-csv-output cut -f BOOK_SERIAL_NUMBER then head -n 1 $inFile) ; 
    BOOK_TYPE=$(mlr --csv --ifs ';' --headerless-csv-output cut -f BOOK_TYPE then head -n 1 $inFile) ; 
    BOOK_NAME=$(mlr --csv --ifs ';' --headerless-csv-output cut -f BOOK_NAME then head -n 1 $inFile) ; 
    BOOK_NAME_ENGLISH_TRANSLITERATED=$(mlr --csv --ifs ';' --headerless-csv-output cut -f BOOK_NAME_ENGLISH_TRANSLITERATED then head -n 1 $inFile) ; 
    NUM_MAX_PAGES_URL=$(mlr --csv --ifs ';' --headerless-csv-output cut -f NUM_MAX_PAGES then head -n 1 $inFile) ; 
    ####
    ## SECONDARY VARIABLES EXTRACTED FROM PRIMARY VARS
    BOOKNAME="$BOOK_NAME" ; 
    NUMPAGES_TO_EXTRACT=$(echo "$NUM_MAX_PAGES_URL" | awk -F '.' '{print $NF}') ; 
    BOOK_URL_PREFIX_WITH_DOT_IN_END=$(echo "$NUM_MAX_PAGES_URL" | awk -F '.' '{$NF=""; print} ' | sd ' ' '.') ; 
    LOCALPATH_PREFIX_WITH_DOT=$(echo "$NUM_MAX_PAGES_URL" | awk -F '.' '{$NF=""; print}' | awk -F '/' '{print "file://$DIR_OUTPUT/" $NF "."}' | sd ' ' '') ; 
    ####
    echo ">> PRINTING SECONDARY INPUT VARIABLES FOR PYTHON ... " ; 
    echo $BOOKNAME // $NUMPAGES_TO_EXTRACT // $BOOK_URL_PREFIX_WITH_DOT_IN_END // $LOCALPATH_PREFIX_WITH_DOT ;
####
####
## WRITE A TMP CONFIG FILE TO BE USED BY PYTHON FUNCTIONS
cat << EOF | tee -a "$tmpConfigFile"
DIR_PROJECT="$REPO_SCRIPTS_AWGP/1003_parse_html_using_bsoup" ; 
DIR_OUTPUT="$WORKDIR" ; 
BOOKNAME="Audiobook - $BOOKNAME"
BOOK_URL_PREFIX_WITH_DOT_IN_END="$BOOK_URL_PREFIX_WITH_DOT_IN_END"
LOCALPATH_PREFIX_WITH_DOT="$LOCALPATH_PREFIX_WITH_DOT" ;
NUMPAGES_TO_EXTRACT=$NUMPAGES_TO_EXTRACT ;
EOF
####
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_DOWNLOAD_ALL_PAGES_LOCALLY () {
    ## Firstly, sourcing the config file
    source "$tmpConfigFile" ; 
    ## download all pages one by one
    for x in $(seq 1 1 $NUMPAGES_TO_EXTRACT) ; do wget -P "$WORKDIR" "$BOOK_URL_PREFIX_WITH_DOT_IN_END"$x ; done
    ## add html file extension
    for x in v* ; do mv $x $x.html ; done
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_RUN_PYTHON_PROGRAMS_FOR_OUTPUTS () {
    ## Firstly, sourcing the config file
    source "$tmpConfigFile" ; 
    ## run the python bsoup program to extract the desired data from locally present html files
    python_program_path="$DIR_PROJECT/1003-gayatri-parivar-parse-local-html-book-data-using-beautiful-soup.py" ;
    ## Check output
    python3 $python_program_path "$BOOKNAME" "$NUMPAGES_TO_EXTRACT" "$LOCALPATH_PREFIX_WITH_DOT" ; 
    ## Then run again to save output to html
    python3 $python_program_path "$BOOKNAME" "$NUMPAGES_TO_EXTRACT" "$LOCALPATH_PREFIX_WITH_DOT" > $WORKDIR/_FINAL_RESULT.html ; 
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_CALL_STEP01_FUNCTIONS () {
    FUNC_DOWNLOAD_ALL_PAGES_LOCALLY ; 
}
FUNC_CALL_STEP02_FUNCTIONS () {
    FUNC_RUN_PYTHON_PROGRAMS_FOR_OUTPUTS ; 
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################
## CALL FUNCTIONS
FUNC_SEARCH_VARS_BASED_UPON_NUM_MAXPAGES_URL ;
FUNC_GET_SOME_PARAM_VALUES ;
####
echo "##+++++++++++++++++++++++++++++++++++++++" ; 
echo ">> WHAT DO YOU WANT TO DO? " ; echo; 
##
while true
do
    echo "1. Download HTMLs locally"
    echo "2. Parse local HTMLs using python"
    echo "3. Exit prompt"
   read Input
   case "$Input" in
        1) FUNC_CALL_STEP01_FUNCTIONS ;;
        2) FUNC_CALL_STEP02_FUNCTIONS  ;;
        3) exit
   esac
done
echo "##+++++++++++++++++++++++++++++++++++++++" ; 
################################################################################

