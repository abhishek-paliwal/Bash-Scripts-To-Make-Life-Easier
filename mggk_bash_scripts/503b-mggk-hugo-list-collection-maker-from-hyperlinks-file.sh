#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ###############################################################################
    ## THIS SCRIPT CREATES AN HTML FILE FROM A TEXT FILE CONTAINING A LIST OF
    ## MGGK URLs, TO MAKE A FINAL COLLECTION. IT NEEDS AN ARGUMENT, ELSE THE DEFAULT
    ## FILE WILL BE USED (= $REQUIREMENTS_FILE).
    ## THIS PROGRAM AUTOMATICALLY EXRACTS UNIQUE URLs, SO EVEN IF THE DUPLICATES URLs ARE
    ## PRESENT IN $REQUIREMENTS_FILE, IT IS OKAY. THEY WILL BE TAKEN CARE OF.
    ## USAGE:
    #### sh 503b-mggk-hugo-list-collection-maker-from-hyperlinks-file.sh $REQUIREMENTS_FILE
    #### OR
    #### sh 503b-mggk-hugo-list-collection-maker-from-hyperlinks-file.sh \$1
    ###############################################################################
    ## NOTE: REQUIREMENTS_FILE should be present in => $HOME/Desktop/Y
    ## REQUIREMENTS_FILE="503b_mylinks.txt"
    ## OR
    ## REQUIREMENTS_FILE="\$1"
    ###############################################################################
    ## DATE: March 18 2019
    ## MADE BY: PALI
    ###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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

###############################################################################

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
## ONLY THOSE LINES ARE SAVED WHICH HAVE THE WORD 'HTTPS' IN THEM, CONSIDERING ONLY
## UNIQUE LINES. UNIQ ONLY WORKS WHEN THE LINES ARE SORTED FIRST. SO WE WILL SORT FIRST.
cat $REQUIREMENTS_FILE | sed 's/\[.*\]//g' | sed 's/(//g' | sed 's/)//g' | grep -i 'https' | sort | uniq > $LINKS_FILE_OUTPUT

## PRINTING URLs BEFORE AND AFTER REMOVING DUPLICATES
echo; echo ">> PRINTING URLs BEFORE REMOVING DUPLICATES >>" ;
cat $REQUIREMENTS_FILE | grep -i 'https' | sort | nl
echo; echo ">> PRINTING URLs AFTER REMOVING DUPLICATES >>" ;
cat $LINKS_FILE_OUTPUT | nl
echo;

###############################################################################
###############################################################################

########### USING THE TMP LINKS FILE AND FINDING CORRESPONDING MARKDOWN FILES #############

## NOW, FINDING THE MARKDOWN FILES WHICH HAVE THE LINES FROM THE ABOVE OUTPUT1 FILE
echo ">>>> Beginning WHILE LOOP" ;

echo "<div class='row'> <!--BEGIN: MAIN ROW -->" > $OUTPUT_HTML_FILE ; ## Initializing the html file

echo ""  >> $OUTPUT_HTML_FILE;

## UNCOMMENT THE FOLLOWING 3 LINES IF YOU ALSO WANT THIS BLOCK TO APPEAR IN HTML OUTPUT FILE
##
#echo "  <div class='col-12' align='center' style='background: rgba(205,30,100,0.1) ;'>"  >> $OUTPUT_HTML_FILE ;
#echo "  <h2>&bull; SECTION NAME: $REQUIREMENTS_FILE &bull;</h2>"  >> $OUTPUT_HTML_FILE ;
#echo "  </div>"  >> $OUTPUT_HTML_FILE ;
echo ""  >> $OUTPUT_HTML_FILE;

echo "  <div class='col-12'><div class='row'> <!-- BEGIN: ALL CONTENT COLUMN+ROW -->"  >> $OUTPUT_HTML_FILE ;

##------------------------------------------------------------------------------
## BEGIN: FUNCTION TO OUTPUT THE MARKDOWN FILE PATH FOR AN ENTERED MGGK URL
## AS COMMAND LINE ARGUMENT
function FUNCTION_OUTPUT_MDFILE_FULLPATH () {
  SEARCHDIR="$REPO_MGGK/content" ;
  ## CREATING SEARCH_URL FROM THE USER INPUT
  SEARCHURL=$(echo $1 | sed 's|https://www.mygingergarlickitchen.com||g')
  ## EXIT THE SCRIPT IF THE ENTERED URL IS NOT PROPER
  if [[ "$SEARCHURL" == "/" ]] || [[ "$SEARCHURL" == "" ]] ; then exit 1; fi
  ## COUNT THE NUMBER OF FILES WITH CURRENT URL IN YAML FRONTMATTER.
  ## THE ANSWER SHOULD ONLY BE 1. BUT JUST TO MAKE SURE, RUN THE FOLLOWING COMMAND.
  NUM_FILES=$(grep -irl "url: $SEARCHURL" $SEARCHDIR | wc -l | tr -d '[:space:]') ;
  ## Check, how many files with this url are returned. Exit, if more than 1.
  if [[ "$NUM_FILES" -eq 0 ]] || [[ "$NUM_FILES" -gt 1 ]] ; then exit 1; fi 
  ## SEARCH FOR THE MD FILE WHERE THE URL LIES IN THE YAML FRONTMATTER
  grep -irl "url: $SEARCHURL" $SEARCHDIR | head -1 ;
}
## END: FUNCTION
#MDFILE_WITH_CHOSEN_URL=$(FUNCTION_OUTPUT_MDFILE_FULLPATH "YOUR-CHOSEN-URL") ;
##------------------------------------------------------------------------------

COUNT=1;
while read -r line; do
    echo ; echo ;
    echo ">>> LINE NUMBER $COUNT = $line " # Reading each line

    MGGK_BASEURL="https://www.mygingergarlickitchen.com"

    MDFILE_WITH_CHOSEN_URL=$(FUNCTION_OUTPUT_MDFILE_FULLPATH "$line") ;
    echo "  >> Markdown file found => $MDFILE_WITH_CHOSEN_URL " ; 
    echo;
    
    ## EXTRACTING NEEDED DETAILS FROM MD FILE THUS FOUND
    TITLE=$(grep -irh '^title: ' $MDFILE_WITH_CHOSEN_URL | sed 's/"//g' | sed 's/title: //g' ) ;
    META_DESCRIPTION=$(grep -irh '^yoast_description: ' $MDFILE_WITH_CHOSEN_URL | sed 's/"//g' | sed 's/yoast_description: //g' | cut -c1-180 ) ;
    URL=$(grep -irh '^url: ' $MDFILE_WITH_CHOSEN_URL | sed 's/"//g' | sed "s+url: +$MGGK_BASEURL+g" ) ;
    IMAGE=$(grep -irh '^featured_image: ' $MDFILE_WITH_CHOSEN_URL | sed 's/"//g' | sed "s+featured_image: +$MGGK_BASEURL+g" ) ;
    IMAGE_TO_COPY=$(grep -irh '^featured_image: ' $MDFILE_WITH_CHOSEN_URL | sed 's/"//g' | sed "s+featured_image: +$REPO_MGGK/static+g" ) ;  

    ## Further processing of IMAGE + META_DESCRIPTION
    #### DOWNLOADING THE IMAGE INTO A SPECIFIC FOLDER (folder will be created if not present already)
    TmpImageDir="$myPWD/_TMP_IMAGES_$REQUIREMENTS_FILE" ;
    mkdir $TmpImageDir ;
    echo "    >>>> Getting the image for this URL ..." ;
    cp $IMAGE_TO_COPY $TmpImageDir/ ;
    ##
    #### Trimming description length to 170 characters
    LENGTH_METADESC=$(echo $META_DESCRIPTION | awk '{print length}') ;
    echo "===========> LENGTH_METADESC = $LENGTH_METADESC" ;
    ###### ADD THREE DOTS IF LENGTH_METADESC IS > 170
    if [[ "$LENGTH_METADESC" -lt 170 ]] ; then
      META_DESCRIPTION=$META_DESCRIPTION
    else
      META_DESCRIPTION="$META_DESCRIPTION..." ;
    fi
    ##

    ## PRINTING THE VARIABLES
    echo "TITLE = $TITLE " ;
    echo "PAGE URL = $URL " ;
    echo "META_DESCRIPTION = $META_DESCRIPTION " ;
    echo "IMAGE = $IMAGE " ;
    echo "IMAGE_TO_COPY = $IMAGE_TO_COPY " ;

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
        <a href='$URL'>$COUNT.) $TITLE</a></p><p style='font-family: sans-serif ; font-size: 0.9rem ; '>$META_DESCRIPTION<a href='$URL'> &rarr;</a>
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
title: $REQUIREMENTS_FILE (2021 edition)
author: Anupama Paliwal
type: post
date: $DATEVAR
first_published_on: $DATEVAR
url: /$REQUIREMENTS_FILE/
featured_image:

categories:
  - All-Recipes
  - Collections

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
