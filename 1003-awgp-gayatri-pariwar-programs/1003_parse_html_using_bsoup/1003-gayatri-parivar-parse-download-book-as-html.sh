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
HTML_OUTPUT="$WORKDIR/_FINAL_RESULT.html" ;
DIR_PROJECT="$REPO_SCRIPTS_AWGP/1003_parse_html_using_bsoup" ; 
DIR_OUTPUT="$WORKDIR" ; 
tmpConfigFile="$WORKDIR/_tmp_config_file.txt" ; 
####
## Get all 'Text Book Version' NUM MAX PAGES URLs
## Run miller command 
textBookNumMaxURLsCSVFile="$WORKDIR/_tmp_textbook01_nummaxurls.csv" ;
mlr --csv --ifs ';' --ofs ';' filter '$BOOK_TYPE =~ "Text Book"' then cut -f BOOK_SERIAL_NUMBER,NUM_MAX_PAGES $CSV_AWGP | mlr --csv --ifs ';' --ofs ';' skip-trivial-records > $textBookNumMaxURLsCSVFile ; 
## Get all 'Text Book Version' BOOK URLs
textBookbookURLsCSVFile="$WORKDIR/_tmp_textbook02_bookurls.csv" ;
mlr --csv --ifs ';' --ofs ';' filter '$BOOK_TYPE =~ "Text Book"' then cut -f BOOK_SERIAL_NUMBER,BOOK_URL $CSV_AWGP | mlr --csv --ifs ';' --ofs ';' skip-trivial-records > $textBookbookURLsCSVFile ;  

## COMBINE THESE 2 FILES
textBookAllURLsCSVFile="$WORKDIR/_tmp_textbook03_allurls.csv" ;
cat "$textBookNumMaxURLsCSVFile" "$textBookbookURLsCSVFile" | sort -V > "$textBookAllURLsCSVFile" ; 


##------------------------------------------------------------------------------
## sample configuration ##
#DIR_PROJECT="$REPO_SCRIPTS/1003-gayatri-parivar-book-making-programs"
#DIR_OUTPUT="$DIR_Y/_tmp_output_1003-gayatri-parivar-book-making-programs"
#BOOKNAME="अंधविश्वास को उखाड़ फेंकिये"
#BOOK_URL_PREFIX_WITH_DOT_IN_END="http://literature.awgp.org/book/andhvishwas_ko_ukhad_fenkiye/v1."
#LOCALPATH_PREFIX_WITH_DOT="file://$DIR_OUTPUT/v1." ;
#NUMPAGES_TO_EXTRACT=48 ;
##------------------------------------------------------------------------------

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## FUNCITON DEFINITIONS
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
source "$REPO_SCRIPTS_MINI/00200a_source_script_to_print_fancy_divider.sh" ;
echo ">> Now you can use => palidivider => to print a fancy divider" ;
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_SEARCH_VARS_BASED_UPON_NUM_MAXPAGES_URL () {
    palidivider ; 
    ## USER INPUT:
    ########
    echo ">> CONFIG FILE = $tmpConfigFile" ; 
    ## DO NOT ASK FOR USER INPUT IF CONFIG FILE ALREADY EXISTS
    if [[ -f "$tmpConfigFile" ]]; then
        ## CHOOSE URL FROM CONFIG FILE
        source "$tmpConfigFile" ## firstly, source the config file
        echo ">> CONFIG FILE exists. URL will be chosen from the config file ..." ; 
        search_url="$NUM_MAX_PAGES_URL" ## from the sourced config file
    else
        ## ASK USER TO CHOOSE FROM LIST
        echo; echo ">> CONFIG FILE does not exist. User will be asked to choose the URL ..." ; 
        echo ">>>> PLEASE CHOOSE THE URL WITH MORE PAGES, IF MULTIPLE URLs exist for single book. (Press ENTER key to select) =>" ;
        search_url=$(cat $textBookAllURLsCSVFile | fzf | awk -F ';' '{print $2}' ) ;
    fi
    ########
    echo ">> CHOSEN SEARCH URL IS = $search_url";
    ## Exit the program if search url is empty.
    if [ -z "$search_url" ]
    then
        echo "\$search_url is empty. Program will exit now." ; exit ; 
    else
        echo "\$search_url is NOT empty. Program will continue." ; 
    fi
    ########
    echo "##+++++++++++++++++++++++++++++++++++++++" ; 
    ########
    TMPFILE1="$WORKDIR/_tmp1.txt" ; 
    TMPFILE2="$WORKDIR/_tmp2.txt" ; 
    OUTFILE="$searchResultCSV" ; 
    ##
    head -1 $inFileCSV > $TMPFILE1
    grep -i "$search_url" $inFileCSV > $TMPFILE2
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
    palidivider ; 
    echo; echo ">> RUNNING FUNCTION => FUNC_GET_SOME_PARAM_VALUES ..."  ; 
    inFile="$searchResultCSV" ;
    ## PRIMARY VARIABLES
    ## consider first result line only
    BOOK_SERIAL_NUMBER=$(mlr --csv --ifs ';' --headerless-csv-output cut -f BOOK_SERIAL_NUMBER then head -n 1 $inFile) ; 
    BOOK_TYPE=$(mlr --csv --ifs ';' --headerless-csv-output cut -f BOOK_TYPE then head -n 1 $inFile) ; 
    BOOK_NAME=$(mlr --csv --ifs ';' --headerless-csv-output cut -f BOOK_NAME then head -n 1 $inFile) ; 
    BOOK_NAME_ENGLISH_TRANSLITERATED=$(mlr --csv --ifs ';' --headerless-csv-output cut -f BOOK_NAME_ENGLISH_TRANSLITERATED then head -n 1 $inFile) ; 
    NUM_MAX_PAGES_URL=$(mlr --csv --ifs ';' --headerless-csv-output cut -f NUM_MAX_PAGES then head -n 1 $inFile) ; 
    BOOK_URL=$(mlr --csv --ifs ';' --headerless-csv-output cut -f BOOK_URL then head -n 1 $inFile) ;
    ####
    ## If NUM_MAX_PAGES_URL is empty, then replace it with BOOK_URL
    if [ -z "$NUM_MAX_PAGES_URL" ]
    then
        echo "\$NUM_MAX_PAGES_URL is empty. \$BOOK_URL will be used instead." ; 
        NUM_MAX_PAGES_URL="$BOOK_URL" ; 
    else
        echo "\$NUM_MAX_PAGES_URL is NOT empty. Program will continue." ; 
    fi
    ####
    ####
    ## SECONDARY VARIABLES EXTRACTED FROM PRIMARY VARS
    BOOKNAME="$BOOK_NAME" ; 
    NUMPAGES_TO_EXTRACT=$(echo "$NUM_MAX_PAGES_URL" | awk -F '.' '{print $NF}') ; 
    BOOK_URL_PREFIX_WITH_DOT_IN_END=$(echo "$NUM_MAX_PAGES_URL" | awk -F '.' '{$NF=""; print} ' | sd ' ' '.') ; 
    LOCALPATH_PREFIX_WITH_DOT=$(echo "$NUM_MAX_PAGES_URL" | awk -F '.' '{$NF=""; print}' | awk -F '/' '{print "file://$DIR_OUTPUT/" $NF "."}' | sd ' ' '') ; 
    URL_BOOK_PART=$(echo "$NUM_MAX_PAGES_URL" | awk -F '/' '{print $(NF-1)}') ; 
    ####
    echo; echo ">> PRINTING SECONDARY INPUT VARIABLES FOR PYTHON ... " ; 
    echo $BOOKNAME // $NUMPAGES_TO_EXTRACT // $BOOK_URL_PREFIX_WITH_DOT_IN_END // $LOCALPATH_PREFIX_WITH_DOT // $URL_BOOK_PART // $BOOK_SERIAL_NUMBER ;
    echo; echo; 
####
####
## WRITE A TMP CONFIG FILE TO BE USED BY PYTHON FUNCTIONS
echo > $tmpConfigFile ; ## initializing
cat << EOF | tee -a "$tmpConfigFile"
DIR_PROJECT="$REPO_SCRIPTS_AWGP/1003_parse_html_using_bsoup"
DIR_OUTPUT="$WORKDIR"
BOOK_SERIAL_NUMBER="$BOOK_SERIAL_NUMBER"
NUM_MAX_PAGES_URL="$NUM_MAX_PAGES_URL" 
BOOKNAME="$BOOKNAME"
BOOK_URL_PREFIX_WITH_DOT_IN_END="$BOOK_URL_PREFIX_WITH_DOT_IN_END"
LOCALPATH_PREFIX_WITH_DOT="$LOCALPATH_PREFIX_WITH_DOT"
NUMPAGES_TO_EXTRACT=$NUMPAGES_TO_EXTRACT
URL_BOOK_PART="$URL_BOOK_PART"
BOOKNAME_HTML_MD_FINAL="${BOOK_SERIAL_NUMBER}_XX_${URL_BOOK_PART}"
EOF
####
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_DOWNLOAD_ALL_PAGES_LOCALLY () {
    palidivider ; 
    ## Firstly, sourcing the config file
    source "$tmpConfigFile" ; 
    ## download all pages one by one
    for x in $(seq 1 1 $NUMPAGES_TO_EXTRACT) ; do wget -P "$WORKDIR" "$BOOK_URL_PREFIX_WITH_DOT_IN_END"$x ; done
    ## add html file extension
    for x in v* ; do mv $x $x.html ; done
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_RUN_PYTHON_PROGRAMS_FOR_OUTPUTS () {
    palidivider ; 
    ## Firstly, sourcing the config file
    source "$tmpConfigFile" ; 
    ## run the python bsoup program to extract the desired data from locally present html files
    python_program_path="$DIR_PROJECT/1003-gayatri-parivar-parse-local-html-book-data-using-beautiful-soup.py" ;
    ## Check output
    python3 $python_program_path "$BOOKNAME" "$NUMPAGES_TO_EXTRACT" "$LOCALPATH_PREFIX_WITH_DOT" ; 
    ## Then run again to save output to html
    python3 $python_program_path "$BOOKNAME" "$NUMPAGES_TO_EXTRACT" "$LOCALPATH_PREFIX_WITH_DOT" > "$HTML_OUTPUT" ; 
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_PANDOC_CONVERT_HTML_TO_MARKDOWN () {
    palidivider ; 
    echo ">> RUNNING ... FUNC_PANDOC_CONVERT_HTML_TO_MARKDOWN" ; 
    ## Firstly, sourcing the config file
    source "$tmpConfigFile" ; 
    pandoc --wrap=none --from=html --to=markdown_strict "$HTML_OUTPUT" -o "$BOOKNAME_HTML_MD_FINAL.md" ;
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################
## CALL FUNCTIONS
FUNC_SEARCH_VARS_BASED_UPON_NUM_MAXPAGES_URL ;
FUNC_GET_SOME_PARAM_VALUES ;
####
while true
do
    palidivider ; 
    echo ">> WHAT DO YOU WANT TO DO? " ; echo; 
    ##
    echo "1. Download HTMLs locally"
    echo "2. Parse local HTMLs using python"
    echo "3. Convert result HTML to markdown using pandoc"
    echo "4. Exit prompt"
   read Input
   case "$Input" in
        1) FUNC_DOWNLOAD_ALL_PAGES_LOCALLY ;;
        2) FUNC_RUN_PYTHON_PROGRAMS_FOR_OUTPUTS  ;;
        3) FUNC_PANDOC_CONVERT_HTML_TO_MARKDOWN  ;;
        4) exit
   esac
done
####
echo "##+++++++++++++++++++++++++++++++++++++++" ; 
################################################################################

