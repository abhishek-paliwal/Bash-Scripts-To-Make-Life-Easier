#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
##################################################################################
## CD to temporary directory on desktop
PWD="$DIR_Y" ;
cd $PWD ;
echo ">>>> PWD is $PWD" ;
##
NEWSLETTER_TEMPLATE="$PWD/505A-newsletter-template.txt" ;
REQUIREMENTS_FILE="$NEWSLETTER_TEMPLATE" ;  ## first text file
REQUIREMENTS_FILE_BASENAME="$(basename $REQUIREMENTS_FILE)" ; 
##################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
	###############################################################################
	## THIS PROGRAM READS A NEWSLETTER TEMPLATE FILE IN PWD CONTAINING HYPERLINKS AND
  ## TEXT CONTENT. IF THIS FILE IS NOT FOUND, THE IT AUTOCREATES IT FOR THE 
  ## USER TO FILL, AND THEN THE USER NEEDS TO RUN THIS SCRIPT AGAIN. 
  #### IT THEN CREATES A 
  #### CUSTOM NEWSLETTER HTML FILE READY TO BE SENT THRU EMAIL TO
  #### EMAIL SUBSCRIBERS, AFTER COPYING AND PASTING ITS SOURCE CODE INTO ANY
  #### EMAIL PROGRAM (SENDY, MAILCHIMP, ETC.)
  ##############################################################################
  ## REQUIREMENTS => $REQUIREMENTS_FILE
  ## THIS SCRIPT NEEDS A NEWSLETTER TEMPLATE FILE IN PWD, CONTAINING HYPERLINKS
  ## AND TEXT CONTENT. 
	##############################################################################
	## MADE BY: PALI
	## DATE: NOV 01, 2020
	###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################

## CHECK WHETHER THE REQUIRED NEWSLETTER TEMPLATE FILE ALREADY EXISTS
## IF NOT, AUTOMATICALLY CREATE IT.
if [ -f "$NEWSLETTER_TEMPLATE" ]; then
    echo ">> SUCCESS: NEWSLETTER TEMPLATE FILE EXISTS => $NEWSLETTER_TEMPLATE"
else
    echo ">> FAILURE: NEWSLETTER TEMPLATE FILE DOES NOT EXIST. IT HAS BEEN CREATED FOR YOU." ;
    echo ">>>> NEXT STEP: Edit this file with your TEXT CONTENT and LINKS, then run this program again. => $NEWSLETTER_TEMPLATE" ;
    ## CREATING AN EMPTY NEWSLETTER TEMPLATE TO BE FILLED IN
echo "##begin_links
https://www.mygingergarlickitchen.com/LINK-1/
https://www.mygingergarlickitchen.com/LINK-2/
https://www.mygingergarlickitchen.com/LINK-3/
##end_links
##begin_content
CONTENT LINE 1
CONTENT LINE 2
CONTENT LINE 3
##end_content" > $NEWSLETTER_TEMPLATE ;
    ## EXIT THIS SCRIPT IN THIS CASE
    exit 1 ;
fi

###############################################################################
## DEFINE SOME VARIABLE FILENAMES
LINKS_FILE_OUTPUT="$PWD/_TMP_MYLINKS.txt" ;
OUTPUT_HTML_FILE="$PWD/_TMP_505A_NEWSLETTER_TMP_OUTPUT-$REQUIREMENTS_FILE_BASENAME.html"
OUTPUT_HTML_FILE_FINAL="$PWD/_TMP_505A_NEWSLETTER_FINAL_OUTPUT-$REQUIREMENTS_FILE_BASENAME.html"
TMP_CURL_FILE="$PWD/_TMP_mycurlfile.txt" ;
MD_FILENAME="$PWD/_TMP-$REQUIREMENTS_FILE_BASENAME.md";
##
## Using the power of sed to find all text between two phrases
echo ">> Dumping all text found between the required headings" ;
sed -n "/##begin_links/,/##end_links/p" $REQUIREMENTS_FILE | grep -v '#' > $REQUIREMENTS_FILE_BASENAME-links.txt
sed -n "/##begin_content/,/##end_content/p" $REQUIREMENTS_FILE | grep -v '#' > $REQUIREMENTS_FILE_BASENAME-content.txt
###############################################################################

########### CREATING THE TMP LINKS FILES #############

## CHANGING THE INPUT FILE AND REMOVING SOME CONTENT AND SAVING TO OUTPUT FILE
## ONLY THOSE LINES ARE SAVED WHICH HAVE THE WORD 'HTTPS' IN THEM, CONSIDERING ONLY
## UNIQUE LINES. UNIQ ONLY WORKS WHEN THE LINES ARE SORTED FIRST. SO WE WILL SORT FIRST.
cat $REQUIREMENTS_FILE_BASENAME-links.txt | sed 's/\[.*\]//g' | sed 's/(//g' | sed 's/)//g' | grep -i 'https' | uniq > $LINKS_FILE_OUTPUT

## PRINTING URLs BEFORE AND AFTER REMOVING DUPLICATES
echo; echo ">> PRINTING URLs BEFORE REMOVING DUPLICATES >>" ;
cat $REQUIREMENTS_FILE | grep -i 'https' | sort | nl
echo; echo ">> PRINTING URLs AFTER REMOVING DUPLICATES >>" ;
cat $LINKS_FILE_OUTPUT | nl
echo;

## Initializing the HTML file
echo "<!doctype html>
<html lang='en'>
  <head>
    <!-- Required meta tags -->
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
    <!-- Bootstrap CSS -->
    <link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css' crossorigin='anonymous'>
		<title>Latest delicious recipes from My Ginger Garlic Kitchen</title>
	</head>
	<body>  
  <div class='container'>" > $OUTPUT_HTML_FILE ; ## Initializing the HTML file

  echo "<p style='font-size: 18px'; >Hello [Name,fallback=]</p>" >> $OUTPUT_HTML_FILE ;

## INSERTING TEXT CONTENT TO THE OUTPUT
cat $REQUIREMENTS_FILE_BASENAME-content.txt | grep -v '^$' | sed "s+^+<p style='font-size: 18px'; >+g" | sed 's+$+</p>+g' >> $OUTPUT_HTML_FILE ;

echo "<p style='font-size: 18px;'>Best wishes,</p>
<p style='font-size: 18px;'><img align='none' height='35' src='https://gallery.mailchimp.com/126a7c0d8271b7ec930c15e67/images/623b3f2b-7d5f-426d-857a-2c3175fdd285.png' style='width: 110px; height: 35px;'></p>" >> $OUTPUT_HTML_FILE ;

echo "<p style='font-size: 18px; text-align: center; color: #8F903C; '>&bull; &bull; &bull; &bull; &bull; &bull; &bull; &bull;</p>" >> $OUTPUT_HTML_FILE ;

echo "<center>" >> $OUTPUT_HTML_FILE; 



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

###############################################################################
########### USING THE TMP LINKS FILE AND FINDING CORRESPONDING MARKDOWN FILES #############
## NOW, FINDING THE MARKDOWN FILES WHICH HAVE THE LINES FROM THE ABOVE OUTPUT1 FILE
echo ">>>> Beginning WHILE LOOP" ;
echo "<div class='row'><div class='col-12'> <!--BEGIN: MAIN ROW+COLUMN -->" >> $OUTPUT_HTML_FILE ;
echo ""  >> $OUTPUT_HTML_FILE;

COUNT=1;
while read -r line; do
    echo ;
    echo ">>> LINE NUMBER $COUNT = $line " # Reading each line

    MGGK_BASEURL="https://www.mygingergarlickitchen.com"

    MDFILE_WITH_CHOSEN_URL=$(FUNCTION_OUTPUT_MDFILE_FULLPATH "$line") ;
    echo "  >> Markdown file found => $MDFILE_WITH_CHOSEN_URL " ; 
    echo;
    
    ## EXTRACTING NEEDED DETAILS FROM MD FILE THUS FOUND
    TITLE=$(grep -irh '^title: ' $MDFILE_WITH_CHOSEN_URL | sed 's/"//g' | sed 's/title: //g' ) ;
    TITLE_SANS_QUOTES=$(echo "$TITLE" | sed "s/'//ig" ) ; 
    META_DESCRIPTION=$(grep -irh '^yoast_description: ' $MDFILE_WITH_CHOSEN_URL | sed 's/"//g' | sed 's/yoast_description: //g' ) ;
    URL=$(grep -irh '^url: ' $MDFILE_WITH_CHOSEN_URL | sed 's/"//g' | sed "s+url: +$MGGK_BASEURL+g" ) ;
    IMAGE=$(grep -irh '^featured_image: ' $MDFILE_WITH_CHOSEN_URL | sed 's/"//g' | sed "s+featured_image: +$MGGK_BASEURL+g" ) ;

    ## PRINTING THE VARIABLES
    echo "TITLE = $TITLE " ;
    echo "PAGE URL = $URL " ;
    echo "META_DESCRIPTION = $META_DESCRIPTION " ;
    echo "IMAGE = $IMAGE " ;

    ## PRINTING TO HTML
    echo "<h3 style='font-size:24px;'><a style='color: #8F903C;' href='$URL'>$COUNT.) $TITLE</a></h3>" >> $OUTPUT_HTML_FILE;
    echo "<p style='font-size: 18px'; >$META_DESCRIPTION</p>" >> $OUTPUT_HTML_FILE ;
    echo "<p style='font-size: 18px'; ><a href='$URL'><img src='$IMAGE' alt='$TITLE_SANS_QUOTES' width='400' height='600' /></a></p>" >> $OUTPUT_HTML_FILE;  

    echo "<div style='background-color: #8F903C;
    border: 2px solid #8F903C;
    padding: 10px;
    color: white;
    border-radius: 100px;
    text-align: center;
    display: inline-block;'>
    <a style='color: white;' href='$URL' target='_blank'>Check out full post &rarr;</a></div>" >> $OUTPUT_HTML_FILE ;
    
    echo "<p style='font-size: 18px; text-align: center; color: #8F903C; '>&bull; &bull; &bull; &bull; &bull; &bull; &bull; &bull;</p>" >> $OUTPUT_HTML_FILE ;

    (( COUNT++ ))

done < $LINKS_FILE_OUTPUT

echo "</div></div> <!-- END: ALL CONTENT COLUMN+ROW -->"  >> $OUTPUT_HTML_FILE ;
###############################################################################

################################################################################


echo "<hr>" >> $OUTPUT_HTML_FILE ;
echo "<p><!-- Google Analytics Image -->
<img src='http://www.google-analytics.com/collect?v=1&amp;tid=UA-48712319-2&amp;cid=mggkmailchimp&amp;t=event&amp;ec=dailyemailmailChimp&amp;ea=open&amp;el=dailyemailmailChimp&amp;cs=gmail-inbox&amp;cm=email&amp;cn=dailyemailmailChimp' style='border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;height: auto !important;'></p>" >> $OUTPUT_HTML_FILE ;

echo "<webversion>View web version</webversion> // <unsubscribe>Unsubscribe</unsubscribe>" >> $OUTPUT_HTML_FILE ;
echo "<p><a href='https://www.mygingergarlickitchen.com' target='_blank'><img src='https://www.mygingergarlickitchen.com/logos/mggk-new-logo-transparent-150px.png' width='100px' ;></img></a></p>" >> $OUTPUT_HTML_FILE ;

echo "</center>" >> $OUTPUT_HTML_FILE ;

echo "<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src='https://code.jquery.com/jquery-3.3.1.slim.min.js' crossorigin='anonymous'></script>
<script src='https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js' crossorigin='anonymous'></script>
<script src='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js' crossorigin='anonymous'></script>
</body></html>" >> $OUTPUT_HTML_FILE ;

##########################################
## Replacing strange characters to formal html symbols and saving to final html file
cat $OUTPUT_HTML_FILE | sed 's/&lt;/</g' | sed 's/&gt;/>/g' | sed 's/&amp;lsquo;/"/g' | sed 's/&amp;rsquo;/"/g' | sed 's/&amp;#8216;/"/g' > $OUTPUT_HTML_FILE_FINAL
################################################################################

## Opening directory = PWD
# This command works only on mac
echo; echo;
echo ">>>> OPENING THIS HTML FILE IN BROWSER ... (This works only on MAC OS) => $OUTPUT_HTML_FILE_FINAL" ;
open $PWD ;
open $OUTPUT_HTML_FILE_FINAL ;
