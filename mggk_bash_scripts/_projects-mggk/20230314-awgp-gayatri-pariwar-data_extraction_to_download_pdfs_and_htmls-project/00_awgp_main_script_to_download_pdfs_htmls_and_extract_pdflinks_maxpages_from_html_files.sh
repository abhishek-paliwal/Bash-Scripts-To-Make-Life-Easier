#!/bin/bash
################################################################################
## THIS PROGRAM DOES THESE THINGS:
#### - download html webpages locally from awgp website (all 1400+ book urls)
#### - extracts pdflinks and downloads found pdfs locally
#### - extracts max number of pages from the book urls
#### - saves all these outputs as csv for future use as input data (if any)
################################################################################
## CREATED ON: 2023-03-14
## CREATED BY: PALI
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROJECT_DIR="DIR_Y" ; 
INDIR="$PROJECT_DIR/_outputs" ; 
OUTDIR_HTML="$INDIR/_outputs_html" ; 
mkdir -p $INDIR $OUTDIR_HTML; 
cd $INDIR ; 
##
INFILE="$PROJECT_DIR/urls_for_pdfs_FINAL.txt" ; 
file100="$INDIR/100.txt" ; 
file101="$INDIR/101.txt" ; 
file102="$INDIR/102.txt" ; 
##
OUTFILE_STEP04="$INDIR/_output_step04_FINAL_urls_with_pdflinks_and_max_pages.csv" ;
OUTFILE_STEP05_PDF="$INDIR/_output_step05_urls_with_pdflinks.csv" ;
OUTFILE_STEP05_NOPDF="$INDIR/_output_step05_urls_without_pdflinks.csv" ;
OUTFILE_STEP06_MAXPAGES="$INDIR/_output_step06_urls_with_maxpages.csv" ;
OUTFILE_STEP06_NO_MAXPAGES="$INDIR/_output_step06_urls_with_no_maxpages_listed.csv" ;
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#########################################################
FUNC_STEP01_DOWNLOAD_HTML_FILES () {
    c=10000; 
    while read line ; do 
        ((c++)) ; 
        line_new="$(echo $line | sed -e 's+http://+http_+ig' -e 's=/=+=ig' )" ; 
        echo "$c => $line_new" ; 
        curl -sk "$line" > "$OUTDIR_HTML/$c+$line_new.html"  ; 
    done < "$INFILE"
}
#########################################################
FUNC_STEP02_EXTRACT_PDF_LINKS_AND_DOWNLOAD_PDFS () {
    ## get pdf links
    grep -io '/var/.*.pdf">' $OUTDIR_HTML/*.html | sed -e 's+">++ig' -e 's+^.*/var/+http://literature.awgp.org/var/+ig' | sort -u > $file100
    ## get pdf server status
    while read line; do echo "================" ; echo $line ; curl -skI $line | grep -i 'HTTP'; done < $file100 > $file101
    ## convert obtained server status to one-line per pdf file
    awk 'RS="================"{print $1 ";" $2 $3 $4 $5 $6}' $file101 | grep -i '404NotFound' | awk -F ';' '{print $1}' > $file102
}
#########################################################
FUNC_STEP03_DOWNLOAD_PDFS () {
    # download pdfs
    PDF_DIR="$PROJECT_DIR/_pdfs_600X_ALL" ; 
    mkdir -p "$PDF_DIR" ; 
    # cd "$PDF_DIR" ;  
    while read line ; do wget "$line" -P "$PDF_DIR/" ; done < $file100
}
#########################################################
FUNC_STEP04_EXTRACT_PDF_LINKS_AND_MAX_PAGES_IN_HTML_FILES () {
    echo ">> CURRENTLY RUNNING => FUNC_STEP04_EXTRACT_PDF_LINKS_AND_MAX_PAGES_IN_HTML ..."
    TMPFILE="$INDIR/_tmp_step04.txt" ;
    TMPFILE1="$INDIR/_tmp1_step04.txt" ; 
    OUTFILE="$OUTFILE_STEP04" ; 
    echo > $TMPFILE ;
    echo > $TMPFILE1 ;
    c=0;
    for x in $OUTDIR_HTML/*.html ; do 
        ((c++)) ; 
        echo ">> CURRENT HTML FILE $c => $(basename $x)" ; 
        echo "========" >> $TMPFILE
        echo $(basename $x) >> $TMPFILE
        echo ";" >> $TMPFILE
        ## GETTING PDF LINKS
        grep -io '/var/.*.pdf">' $x | sed -e 's+">++ig' -e 's+^.*/var/+http://literature.awgp.org/var/+ig' | sort -u | gpaste -s -d '|' >> $TMPFILE  
        echo ";" >> $TMPFILE
        ## GETTING MAX NUMBER OF PAGES 
        grep -i 'fa-fast-forward' $x | grep -ioE '/book/.*/v[[:digit:]]\.[[:digit:]]+' |  sed 's|/book/|http://literature.awgp.org/book/|ig' | sort -u | gpaste -s -d '|' >> $TMPFILE
        #echo ";" >> $TMPFILE
    done
##
## CONVERING EVERYTHING TO A PROPER CSV FILE WITH ONE LINE PER HTML FILE
cat $TMPFILE | awk -v RS="========" -F"\n" '{print $1 $2 $3 $4 $5 $6 $7 $8 $9 $10}' > $TMPFILE1 ; 
## CONVERTING HTML FILENAMES TO PROPER URL FORMAT
echo "BOOK_URL;PDF_URLS;NUM_MAX_PAGES" > $OUTFILE ; 
cat $TMPFILE1 | sed -e 's|^.*http_|http://|ig' -e 's|+|/|ig' -e 's/.html//ig'  >> $OUTFILE ; 
}
#########################################################
FUNC_STEP05_SAVE_URLS_WITH_AND_WITHOUT_PDFLINKS () {
    echo ">> CURRENTLY RUNNING => FUNC_STEP05_SAVE_URLS_WITH_AND_WITHOUT_PDFLINKS ..."
    INFILE="$OUTFILE_STEP04" ; 
    OUTFILE_NOPDF="$OUTFILE_STEP05_NOPDF" ;
    OUTFILE_PDF="$OUTFILE_STEP05_PDF"  ; 
    awk -F ";" '{print $1 ";" $2}' $INFILE | grep -i '.pdf' > $OUTFILE_PDF ;
    awk -F ";" '{print $1}' $INFILE | grep -iv '.pdf' | grep -iv '^$' > $OUTFILE_NOPDF ; 
}
#########################################################
FUNC_STEP06_SAVE_URLS_WITH_AND_WITHOUT_MAXPAGES () {
    echo ">> CURRENTLY RUNNING => FUNC_STEP06_SAVE_URLS_WITH_AND_WITHOUT_MAXPAGES ..."
    INFILE="$OUTFILE_STEP04" ; 
    OUTFILE_MAXPAGES="$OUTFILE_STEP06_MAXPAGES" ;
    OUTFILE_NO_MAXPAGES="$OUTFILE_STEP06_NO_MAXPAGES" ; 
    ##
    echo "BOOK_URL;NUM_MAX_PAGES" > $OUTFILE_MAXPAGES ; 
    awk 'FS=";" {print $1 ";" $3}' $INFILE | grep -i  'http.*/v[[:digit:]].*[[:digit:]]$' >> $OUTFILE_MAXPAGES ; 
    ##
    echo "BOOK_URL;NUM_MAX_PAGES" > $OUTFILE_NO_MAXPAGES ; 
    awk 'FS=";" {print $1 ";" $3}' $INFILE | grep -iv 'http.*/v[[:digit:]].*[[:digit:]]$' | grep -i 'http' >> $OUTFILE_NO_MAXPAGES ; 
}
#########################################################

## CALLING FUNCTIONS (COMMENT/UNCOMMENT AS NEEDED)

#FUNC_STEP01_DOWNLOAD_HTML_FILES
#FUNC_STEP02_EXTRACT_PDF_LINKS_AND_DOWNLOAD_PDFS
#FUNC_STEP03_DOWNLOAD_PDFS
#FUNC_STEP04_EXTRACT_PDF_LINKS_AND_MAX_PAGES_IN_HTML_FILES
#FUNC_STEP05_SAVE_URLS_WITH_AND_WITHOUT_PDFLINKS
#FUNC_STEP06_SAVE_URLS_WITH_AND_WITHOUT_MAXPAGES
