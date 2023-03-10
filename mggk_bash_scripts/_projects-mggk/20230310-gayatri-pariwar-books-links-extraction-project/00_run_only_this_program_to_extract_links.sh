#/bin/bash

## THIS SCRIPT EXTRACTS THE CORRECT URLS FROM THE GIVEN LIST OF ANCHOR TEXTS FROM THE AWGP BOOK CATALOG PAGE.
## THIS SCRIPT ALSO OUTPUTS THE MAX NUMBER OF PAGES IN BOOK BY GOING TO THE CHOSEN BOOK URL AND FINDING THE FAST FORWARD KEYWORD

WORKDIR="$REPO_SCRIPTS_MGGK_PROJECTS/20230310-gayatri-pariwar-books-links-extraction-project" ; 
INDIR_MAIN="$WORKDIR/_input" ; 
OUTDIR_MAIN="$WORKDIR/_output" ; 

cd $WORKDIR  ;
echo ">> PWD IS => $WORKDIR" ; 

###################################
## VARIABLES
###################################
file_catalog_full="$INDIR_MAIN/book_catalog.html" ;
file_anchor_texts="$INDIR_MAIN/txt_list_of_anchor_texts.txt" ; 
##
file_result_correct_serialnums="$OUTDIR_MAIN/file_result_correct_serialnums.txt" ; 
file_result_correct_urls="$OUTDIR_MAIN/file_result_correct_urls.txt" ; 
file_with_all_urls_from_book_catalog="$OUTDIR_MAIN/_FINAL_file_with_all_urls_from_book_catalog.txt" ; 
##
outfile_step97="$OUTDIR_MAIN/_outfile_step97_my_booklist.txt" ; 
outfile_step99="$OUTDIR_MAIN/_outfile_step99_containing_max_number_of_pages.txt" ; 
###################################


################################################################################
FUNC_STEP0_EXTRACT_ALL_LINKS_FOR_ALL_BOOKS_SEQUENTIALLY () {
    echo ">> RUNNING => FUNC_STEP0_EXTRACT_ALL_LINKS_FOR_ALL_BOOKS_SEQUENTIALLY" ; 
    TMPFILE="$OUTDIR_MAIN/_tmp0.txt" ;
    TMPFILE1="$OUTDIR_MAIN/_tmp1.txt" ;
    OUTFILE="$file_with_all_urls_from_book_catalog" ;
    echo >  $TMPFILE ; 
    ##
    for x in $(seq 1 1 1494) ; do
        echo ">> CURRENT BOOK SERIAL NUMBER = $x" ;  
        echo "========"  >> $TMPFILE ;
        echo "BOOK_SERIALNUM_$x"  >> $TMPFILE ; 
        grep -i "book_list_NAME_$x.set"  "$file_catalog_full" | grep -E '(VAL|\.set)' | grep -io '(.*)'  >> $TMPFILE
        grep -i "book_list_TYPE_$x.set"  "$file_catalog_full" | grep -iE '(value|\.set)' | grep -io '(.*)' >> $TMPFILE
    done
    ##------------------------
    ## CONVERT TMPFILE INTO A SINGLE LINE FOR EVERY SINGLE BOOK, USING AWK UTILITY
    awk -v RS="========" -F"\n" 'NF>=4{print $(NF-4) ";" $(NF-3) ";" $(NF-2) ";" $(NF-1)}' "$TMPFILE"  > "$TMPFILE1" ; 
    ## CLEAN OUTPUT BY DELETING UNWANTED CHARACTERS
    cat "$TMPFILE1" | sed -e 's/"//ig'  -e 's/VAL//ig' -e 's/BOOKNAME//ig' -e 's/,//ig' -e 's/(//ig' -e 's/)//ig'  > "$OUTFILE"

}
#####################
FUNC_STEP1_GET_SERIALNUMS_FROM_ANCHORS () {
    echo ">> RUNNING => FUNC_STEP1_GET_SERIALNUMS_FROM_ANCHORS" ; 
    echo ">> STEP 1 = GETTING CORRECT SERIAL NUMBERS FROM ANCHOR TEXTS ..." ; 
    while read line ; do grep -i "$line" "$file_catalog_full" | grep -io 'book_list.*set' | sd 'book_list_NAME_|.set' '' ;  done < "$file_anchor_texts" > "$file_result_correct_serialnums" ; 
}
#####################
FUNC_STEP2_GET_CORRECT_URLS_FROM_SERIALNUMS () {
    echo ">> RUNNING => FUNC_STEP2_GET_CORRECT_URLS_FROM_SERIALNUMS" ; 
    echo ">> STEP 2 = GETTING CORRECT URLS FROM SERIAL NUMBERS OBTAINED IN STEP 1 ..." ; 
    while read line; do echo "$line" ; ag 'book_list_url.*set' "$file_catalog_full" | grep -i "_$line.set" | grep -io 'http.*)' ; done < "$file_result_correct_serialnums" > "$file_result_correct_urls" ; 
}
#####################
FUNC_STEP97_EXTRACT_DETAILS_FOR_MY_CHOSEN_BOOKLIST_FROM_CORRECT_SERIALNUMS () {
    echo ">> RUNNING => FUNC_STEP97_EXTRACT_DETAILS_FOR_MY_CHOSEN_BOOKLIST_FROM_CORRECT_SERIALNUMS" ; 
    INFILE1="$file_result_correct_serialnums" ;
    INFILE2="$file_with_all_urls_from_book_catalog" ; 
    OUTFILE="$outfile_step97" ;
    echo > $OUTFILE ;  
    while read line ; do
        grep -i "BOOK_SERIALNUM_$line;" $INFILE2 >> $OUTFILE ; 
    done < $INFILE1
}
#####################
#####################
FUNC_STEP99_FIND_MAX_NUMBER_OF_PAGES_FROM_EACH_BOOK_URL () {
    echo ">> RUNNING => FUNC_STEP99_FIND_MAX_NUMBER_OF_PAGES_FROM_EACH_BOOK_URL" ; 
    echo ">> GETTING THE MAXIMUM NUMBER OF LINKS FOR A CORRESPONDING BOOK URL ..." ; 
    INFILE_BOOKLIST="$1" ; ## GET VALUE FROM CLI ARGUMENT
    TMPFILE="$OUTDIR_MAIN/_tmp99_urls.txt" ;
    TMPFILE1="$OUTDIR_MAIN/_tmp99_curl_output.txt" ;
    ## FIND MAX PAGES ONLY FOR TEXT BOOK TYPE, AND NOT SCANNED BOOK TYPE
    grep -i 'text book' $INFILE_BOOKLIST |  awk -F ";" '{print $3}' > $TMPFILE
    ##
    while read myurl; do 
        echo; echo; echo ">>>>>>>>" ; 
        myurl_book_serialnum=$(grep -i "$myurl" $INFILE_BOOKLIST |  awk -F ";" '{print $1}' ) ;
        myurl_book_realbookname=$(grep -i "$myurl" $INFILE_BOOKLIST |  awk -F ";" '{print $2}' ) ; 
        myurl_new="$myurl.1" ; 
        myurl_bookname="$(basename $(dirname $myurl))" ; 
        ##
        echo "  >> BOOK SERIALNUM = $myurl_book_serialnum" ; 
        echo "  >> MYURL_REALBOOKNAME = $myurl_book_realbookname" ; 
        echo "  >> URL_BASE = $myurl" ; 
        echo "  >> URL_NEW = $myurl_new" ; 
        echo "  >> MYURL_BOOKNAME = $myurl_bookname" ; 
        #Example => curl -sk http://literature.awgp.org/book/ham_sukh_shanti_se_vanchit_kyon_hai/v1.1 | grep -i 'fa-fast-forward'
        curl -sk "$myurl_new" >> $TMPFILE1 
        ## FIND LINES MATCHING MY URL
        grep -i "$myurl_bookname" $TMPFILE1 | grep -i 'fa-fast-forward' | head -2 ; 
    done < "$TMPFILE"
}
################################################################################


##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CALLING FUNCTIONS (COMMENT/UNCOMMENT AS NEEDED)
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ">> PRODUCING OUTPUTS. BUT BEFORE THAT, MAKE SURE TO COMMENT/UNCOMMENT THE FUNCTION IN THE BASH SCRIPT FILE ... THEN RERUN." ;

#FUNC_STEP0_EXTRACT_ALL_LINKS_FOR_ALL_BOOKS_SEQUENTIALLY ; 
#FUNC_STEP1_GET_SERIALNUMS_FROM_ANCHORS ; 
#FUNC_STEP2_GET_CORRECT_URLS_FROM_SERIALNUMS ; 
#FUNC_STEP97_EXTRACT_DETAILS_FOR_MY_CHOSEN_BOOKLIST_FROM_CORRECT_SERIALNUMS ; 
#FUNC_STEP99_FIND_MAX_NUMBER_OF_PAGES_FROM_EACH_BOOK_URL  "$outfile_step97" > "$outfile_step99" ; 

