#/bin/bash

echo ">> THIS PROGRAM'S JOB IS DONE. SO IT WILL SIMPLY EXIT NOW WITHOUT DOING ANYTHING FURTHER. REMOVE THE EXIT BLOCK IF NEEDED." ;
exit ; ## remove this line to run again.

input_csv="awgp_merged_full_book_catalog.csv" ; 
output_csv="awgp_merged_full_book_catalog_with_hyperlinks.csv" ; 

## Calculate : put new columns based upon old columns
## convert normal link column values to proper html hyperlinks
## (following is multiline syntax for miller - mlr commands. Note the syntax.)
mlr --csv --ifs ';' --ofs ';' --from "$input_csv" put ' 
$BOOK_URL_NEW = "<a target='\''_blank'\'' href='\''" . $BOOK_URL . "'\''>" . $BOOK_URL . "</a>" ;
$BOOK_URL_HOME_NEW = "<a target='\''_blank'\'' href='\''" . $BOOK_URL_HOME . "'\''>" . $BOOK_URL_HOME . "</a>" ;
$PDF_URLS_NEW = "<a target='\''_blank'\'' href='\''" . $PDF_URLS . "'\''>" . $PDF_URLS . "</a>" ; 
$NUM_MAX_PAGES_NEW = "<a target='\''_blank'\'' href='\''" . $NUM_MAX_PAGES . "'\''>" . $NUM_MAX_PAGES . "</a>"
' > _tmp01.csv

## discard columns containing plain links
mlr --csv --ifs ';' --ofs ';' --from _tmp01.csv cut -f BOOK_SERIAL_NUMBER,BOOK_NAME,BOOK_NAME_ENGLISH_TRANSLITERATED,BOOK_TYPE,BOOK_URL_NEW,BOOK_URL_HOME_NEW,PDF_URLS_NEW,NUM_MAX_PAGES_NEW > _tmp02.csv

## rename the new calculated column names to same as the old names
mlr --csv --ifs ';' --ofs ';' --from _tmp02.csv rename BOOK_URL_NEW,BOOK_URL,BOOK_URL_HOME_NEW,BOOK_URL_HOME,PDF_URLS_NEW,PDF_URLS,NUM_MAX_PAGES_NEW,NUM_MAX_PAGES > "$output_csv" ; 

################################################################################
## Make html tables from all csv files in pwd
echo ">> Making html tables from all csv files in pwd ... "
bash $REPO_SCRIPTS_MGGK_PROJECTS/20210827-convert-all-csv-files-in-pwd-to-html-tables-bootstrap.sh ; 
echo ">>>>>>>>>>>>>>>>> PRINTING DIR TREE ..."  ;
tree ;  
################################################################################
