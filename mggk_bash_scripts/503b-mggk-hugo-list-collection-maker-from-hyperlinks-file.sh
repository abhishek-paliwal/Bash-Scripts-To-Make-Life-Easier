#!/bin/bash
################################################################################
REQUIREMENTS_FILE="503b_mylinks.txt"
################################################################################
cat << EOF
    ###############################################################################
    ## THIS SCRIPT CREATES AN HTML FILE FROM A TEXT FILE CONTAINING A LIST OF
    ## MGGK URLs, TO MAKE A FINAL COLLECTION
    ## USAGE:
    #### sh 503b-mggk-hugo-list-collection-maker-from-hyperlinks-file.sh $REQUIREMENTS_FILE
    ###############################################################################
    ## REQUIREMENT-FILE="503b_mylinks.txt"
    ###############################################################################
    ## DATE: March 18 2019
    ## MADE BY: PALI
    ###############################################################################
    ###############################################################################
EOF

## CD to temporary directory on desktop
myPWD="$HOME/Desktop/Y" ;
cd $myPWD ;
echo ">>>> PWD is $myPWD" ;
echo "<<<< IN CASE OF ERROR: Make sure that there is a file named mylinks.txt in $myPWD >>>>" ;

## DEFINE SOME VARIABLE FILENAMES
LINKS_FILE_OUTPUT="TMP_MYLINKS.txt" ;
OUTPUT_HTML_FILE="TMP_503b_FINAL_OUTPUT.html"
TMP_CURL_FILE="TMP_mycurlfile.txt" ;
###############################################################################

echo ;
echo "## SCRIPT USAGE (Hint: It needs an argument):" ;
echo "sh 503b-mggk-hugo-list-collection-maker-from-hyperlinks-file.sh $REQUIREMENTS_FILE" ;
echo ;

########### PRINTING TO CLI : THE REQUIRED FORMAT FOR THE MYLINKS.TXT FILE
echo "STRUCTURE OF $1 file should be:" ;
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" ;
echo "
...
...
[Gajar Ka Halwa](https://www.mygingergarlickitchen.com/how-to-make-gajar-ka-halwa-carrot-halwa-video-recipe/)
[Jaipuri Malai Ghevar](https://www.mygingergarlickitchen.com/how-to-make-ghevar-jaipuri-malai-ghevar-ghewar-video-recipe/)
[Best Gulab Jamun](https://www.mygingergarlickitchen.com/best-gulab-jamun-recipe-dessert-sweets-video-recipe/)
...
...
" ;
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;
echo; echo "OR simply," ; echo;
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" ;
echo "
...
...
https://www.mygingergarlickitchen.com/how-to-make-gajar-ka-halwa-carrot-halwa-video-recipe/
https://www.mygingergarlickitchen.com/how-to-make-ghevar-jaipuri-malai-ghevar-ghewar-video-recipe/
https://www.mygingergarlickitchen.com/best-gulab-jamun-recipe-dessert-sweets-video-recipe/
...
...
" ;
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;
###############################################################################

########### CREATING THE TMP LINKS FILES #############

## CHANGING THE INPUT FILE AND REMOVING SOME CONTENT AND SAVING TO OUTPUT FILE
## ONLY THOSE LINES ARE SAVED WHICH HAVE THE WORD 'HTTPS' IN THEM
cat $REQUIREMENTS_FILE | sed 's/\[.*\]//g' | sed 's/(//g' | sed 's/)//g' | grep -i 'https' > $LINKS_FILE_OUTPUT

###############################################################################

########### USING THE TMP LINKS FILE AND FINDING CORRESPONDING MARKDOWN FILES #############

## NOW, FINDING THE MARKDOWN FILES WHICH HAVE THE LINES FROM THE ABOVE OUTPUT1 FILE
echo ">>>> Beginning WHILE LOOP" ;

echo "<!--BEGIN: row-->"  > $OUTPUT_HTML_FILE ; ## Initializing the html file
echo "<div class='row'>"  >> $OUTPUT_HTML_FILE ;

echo ""  >> $OUTPUT_HTML_FILE;
echo "  <div class='col-12' align='center' style='background: rgba(205,30,100,0.1) ;'>"  >> $OUTPUT_HTML_FILE ;
echo "  <h2>&bull; ANY SECTION NAME &bull;</h2>"  >> $OUTPUT_HTML_FILE ;
echo "  </div>"  >> $OUTPUT_HTML_FILE ;
echo ""  >> $OUTPUT_HTML_FILE;

    COUNT=1;
    while read -r line; do
        echo ;
        echo ">>> LINE NUMBER $COUNT = $line " # Reading each line

        ## SAving the url locally
        curl -s $line > $TMP_CURL_FILE ;

        ## EXTRACTING TITLE
        TITLE=$( cat $TMP_CURL_FILE | grep -i 'og:title' | sed 's/<meta property=\"og:title\" content=\"//g'  | sed 's/\" \/>//g' ) ;
        echo "TITLE = $TITLE " ;

        ## EXTRACTING URL
        URL=$( cat $TMP_CURL_FILE | grep -i 'og:url' | sed 's/<meta property=\"og:url\" content=\"//g'  | sed 's/\" \/>//g' ) ;
        echo "PAGE URL = $URL " ;

        ## EXTRACTING IMAGE URL
        IMAGE=$( cat $TMP_CURL_FILE | grep -i 'og:image:secure_url' | sed 's/<meta property=\"og:image:secure_url\" content=\"//g'  | sed 's/\" \/>//g' ) ;
        echo "IMAGE = $IMAGE " ;

        ## PRINTING RESPONSIVE GRID COLUMNS
        echo ""  >> $OUTPUT_HTML_FILE;
        echo "  <div class=\"col-6 col-sm-3 col-md-3 col-lg-3 col-xl-3 blog-main\">"  >> $OUTPUT_HTML_FILE;
        echo "  <article class=\"blog-post\" style=\"border: 0px solid #c0c0c0 ;\" >"  >> $OUTPUT_HTML_FILE;
        echo "  <header>"  >> $OUTPUT_HTML_FILE;

            echo "  <p><a href='$URL'><img class='lazy' src='$IMAGE' data-src='$IMAGE' alt='$TITLE' width='100%' \></a></p>" >> $OUTPUT_HTML_FILE ;
            echo "  <p style=\"font-family: 'Playfair Display', serif ; font-size: 0.8rem ; \"><a href='$URL'>$COUNT : $TITLE</a></p>" >> $OUTPUT_HTML_FILE;

        echo "  </header>" >> $OUTPUT_HTML_FILE;
        echo "  </article> " >> $OUTPUT_HTML_FILE;
        echo "  </div>" >> $OUTPUT_HTML_FILE;

        (( COUNT++ ))

    done < $LINKS_FILE_OUTPUT

echo "</div>" >> $OUTPUT_HTML_FILE ;
echo "<!--END: row-->"  >> $OUTPUT_HTML_FILE ;

###############################################################################
## Opening directory = PWD
# This command works only on mac
open $myPWD ;
open $OUTPUT_HTML_FILE ;
