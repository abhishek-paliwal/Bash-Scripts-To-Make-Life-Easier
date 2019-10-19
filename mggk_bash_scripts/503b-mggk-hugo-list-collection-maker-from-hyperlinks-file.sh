#!/bin/bash
################################################################################
## DEFINE REQUIREMENTS_FILE VARIABLE BASED UPON WHETHER CLI ARGUMENT IS PRESENT OR NOT ...
################################################################################
if [ -z "$1" ]
then
  echo "\$1 is EMPTY. Hence, REQUIREMENTS_FILE will be assigned as = 503b_mylinks.txt)." ;
  REQUIREMENTS_FILE="503b_mylinks.txt" ;
else
  echo "\$1 is NOT EMPTY. Hence, REQUIREMENTS_FILE will be assigned as = $1)." ;
  REQUIREMENTS_FILE="$1" ;
fi
################################################################################

cat << EOF
    ###############################################################################
    ## THIS SCRIPT CREATES AN HTML FILE FROM A TEXT FILE CONTAINING A LIST OF
    ## MGGK URLs, TO MAKE A FINAL COLLECTION. IT NEEDS AN ARGUMENT, ELSE THE DEFAULT
    ## FILE WILL BE USED (= $REQUIREMENTS_FILE)
    ## USAGE:
    #### sh 503b-mggk-hugo-list-collection-maker-from-hyperlinks-file.sh $REQUIREMENTS_FILE
    #### OR
    #### sh 503b-mggk-hugo-list-collection-maker-from-hyperlinks-file.sh \$1
    ###############################################################################
    ## NOTE: REQUIREMENTS_FILE should be present in $HOME/Desktop/Y
    ## REQUIREMENTS_FILE="503b_mylinks.txt"
    ## OR
    ## REQUIREMENTS_FILE="\$1"
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
LINKS_FILE_OUTPUT="_TMP_MYLINKS.txt" ;
OUTPUT_HTML_FILE="_TMP_503b_FINAL_OUTPUT-$REQUIREMENTS_FILE.html"
TMP_CURL_FILE="_TMP_mycurlfile.txt" ;
MD_FILENAME="_TMP-$REQUIREMENTS_FILE.md";
###############################################################################

echo ;
echo "## SCRIPT USAGE (Hint: It needs an argument):" ;
echo "sh 503b-mggk-hugo-list-collection-maker-from-hyperlinks-file.sh $REQUIREMENTS_FILE" ;
echo ;

########### PRINTING TO CLI : THE REQUIRED FORMAT FOR THE MYLINKS.TXT FILE
echo "STRUCTURE OF $REQUIREMENTS_FILE file should be:" ;
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

echo "<div class='row'> <!--BEGIN: MAIN ROW -->" > $OUTPUT_HTML_FILE ; ## Initializing the html file

echo ""  >> $OUTPUT_HTML_FILE;
echo "  <div class='col-12' align='center' style='background: rgba(205,30,100,0.1) ;'>"  >> $OUTPUT_HTML_FILE ;
echo "  <h2>&bull; ANY SECTION NAME &bull;</h2>"  >> $OUTPUT_HTML_FILE ;
echo "  </div>"  >> $OUTPUT_HTML_FILE ;
echo ""  >> $OUTPUT_HTML_FILE;

  echo "  <div class='col-12'><div class='row'> <!-- BEGIN: ALL CONTENT COLUMN+ROW -->"  >> $OUTPUT_HTML_FILE ;

    COUNT=1;
    while read -r line; do
        echo ;
        echo ">>> LINE NUMBER $COUNT = $line " # Reading each line

        ## SAving the url locally
        curl -s $line > $TMP_CURL_FILE ;

        ## EXTRACTING TITLE
        TITLE=$( cat $TMP_CURL_FILE | grep -i 'og:title' | sed 's/<meta property=\"og:title\" content=\"//g'  | sed 's/\" \/>//g' ) ;
        echo "TITLE = $TITLE " ;

        ## EXTRACTING META DESCRIPTION
        #### (long descriptions will be trimmed after 200 chars, so that all will have equal length)
        META_DESCRIPTION=$( cat $TMP_CURL_FILE | grep -i 'og:description' | sed 's/<meta property=\"og:description\" content=\"//g'  | sed 's/\" \/>//g' | cut -c1-200 ) ;
        echo "META_DESCRIPTION = $META_DESCRIPTION " ;

        ## EXTRACTING URL
        URL=$( cat $TMP_CURL_FILE | grep -i 'og:url' | sed 's/<meta property=\"og:url\" content=\"//g'  | sed 's/\" \/>//g' ) ;
        echo "PAGE URL = $URL " ;

        ## EXTRACTING IMAGE URL
        IMAGE=$( cat $TMP_CURL_FILE | grep -i 'og:image:secure_url' | sed 's/<meta property=\"og:image:secure_url\" content=\"//g'  | sed 's/\" \/>//g' ) ;
        echo "IMAGE = $IMAGE " ;

          ## DOWNLOADING THE IMAGE INTO A SPECIFIC FOLDER (folder will be created if not present already)
          #wget -P _TMP_IMAGES_$REQUIREMENTS_FILE/ $IMAGE

        ## PRINTING RESPONSIVE GRID COLUMNS
        echo ""  >> $OUTPUT_HTML_FILE;
        echo "<!-- Keep the column sizes intact below. Make sure to define all column view-port sizes explicitly, namely, sm, md ,lg and xl -->"  >> $OUTPUT_HTML_FILE;

        echo ""  >> $OUTPUT_HTML_FILE;
        echo "  <div class='col-sm-12 col-md-6 col-lg-4 col-xl-4'> <!-- BEGIN: single element column -->
            <div class='row'> <!-- BEGIN: nested column row -->"  >> $OUTPUT_HTML_FILE;

        echo ""  >> $OUTPUT_HTML_FILE;
        echo "      <div class='col-5 col-sm-5 col-md-12 col-lg-12 col-xl-12'>
        <a href='$URL'><img class='lazy' src='$IMAGE' data-src='$IMAGE' alt='$TITLE' width='100%' \></a>
        </div>" >> $OUTPUT_HTML_FILE ;

        echo ""  >> $OUTPUT_HTML_FILE;
        echo "      <div class='col-7 col-sm-7 col-md-12 col-lg-12 col-xl-12' style='margin-top: 10px;'>
        <p style='font-family: sans-serif ; font-size: 0.9rem ; font-weight: 700;'>
        <a href='$URL'>$COUNT.) $TITLE</a></p><p style='font-family: sans-serif ; font-size: 0.9rem ; '>$META_DESCRIPTION...<a href='$URL'> &rarr;</a>
        </p>
        </div>" >> $OUTPUT_HTML_FILE;

        echo ""  >> $OUTPUT_HTML_FILE;
        echo "      </div> <!-- END: nested column row -->
            </div> <!-- END: single element column -->" >> $OUTPUT_HTML_FILE;

        (( COUNT++ ))

    done < $LINKS_FILE_OUTPUT

  echo "   </div></div> <!-- END: ALL CONTENT COLUMN+ROW -->
  </div> <!--END: MAIN ROW -->"  >> $OUTPUT_HTML_FILE ;

###############################################################################
###############################################################################
## NOW CREATE A NEW POST MARKDOWN FILE USING THE ABOVE CREATED HTML FILE

## Date is assigned in mdfile as 12 hours in the past from current time, to take care
#### of various timezones errors, so that it gets published when the hugo site is made.
DATEVAR=$(date -v -12H +%Y-%m-%dT%H:%M:%S) ;

################ BEGIN: CREATE MD FILE BY DUMPING ALL TEXT
echo "---
title: $REQUIREMENTS_FILE (2019 edition)
author: Anupama Paliwal
type: post
date: $DATEVAR
url: /$REQUIREMENTS_FILE/
featured_image:

categories:
  - All-Recipes
  -

tags:
  - All-Recipes
  -

yoast_description: \"SOME TEXT HERE\"

---

SOME DESCRIPTION.

<!--more-->

SOME MORE DESCRIPTION.

" > $MD_FILENAME

## HUGO SHORTCODE TO RENDER HTML AS SUCH WITHOUT MODIFYING
echo "{{< mggkrecipeHTMLcode >}}" >> $MD_FILENAME ;
echo "" >> $MD_FILENAME ;
echo "<!-- ////////////// BEGIN: WHOLE COLLECTION BLOCK /////////////////// -->" >> $MD_FILENAME ;
cat $OUTPUT_HTML_FILE >> $MD_FILENAME ; ## CONCATENATING ALL HTML CONTENT GENERATED ABOVE
echo "<!-- ////////////// END: WHOLE COLLECTION BLOCK ///////////////////// -->" >> $MD_FILENAME ;
echo "" >> $MD_FILENAME ;
echo "{{< /mggkrecipeHTMLcode >}}" >> $MD_FILENAME ;

################ END: CREATE MD FILE BY DUMPING ALL TEXT

###############################################################################
## Opening directory = PWD
# This command works only on mac
open $myPWD ;
open $OUTPUT_HTML_FILE ;
