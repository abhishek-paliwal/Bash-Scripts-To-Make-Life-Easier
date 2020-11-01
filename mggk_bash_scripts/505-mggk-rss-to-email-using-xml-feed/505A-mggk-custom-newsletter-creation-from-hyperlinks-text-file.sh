#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
	###############################################################################
	## THIS PROGRAM READS TEXT FILES IN PWD CONTAINING HYPERLINKS AND CREATES 
    ## CUSTOM NEWSLETTER BY CREATING A
	## HTML FILE READY TO BE SENT THRU EMAIL TO EMAIL SUBSCRIBERS, AFTER COPYING
	## AND PASTING ITS SOURCE CODE INTO ANY EMAIL PROGRAM (SENDY, MAILCHIMP, ETC.)
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
## CD to temporary directory on desktop
PWD="$HOME_WINDOWS/Desktop/Y"
cd $PWD ;
echo ">>>> PWD is $PWD" ;

## DEFINE SOME VARIABLE FILENAMES
REQUIREMENTS_FILE="$(ls -1 $PWD/*.txt | head -1)" ;  ## first text file
REQUIREMENTS_FILE_BASENAME="$(basename $REQUIREMENTS_FILE)" ; 
LINKS_FILE_OUTPUT="$PWD/_TMP_MYLINKS.txt" ;
OUTPUT_HTML_FILE="$PWD/_TMP_505A_NEWSLETTER_FINAL_OUTPUT-$REQUIREMENTS_FILE_BASENAME.html"
TMP_CURL_FILE="$PWD/_TMP_mycurlfile.txt" ;
MD_FILENAME="$PWD/_TMP-$REQUIREMENTS_FILE_BASENAME.md";
###############################################################################

########### CREATING THE TMP LINKS FILES #############

## CHANGING THE INPUT FILE AND REMOVING SOME CONTENT AND SAVING TO OUTPUT FILE
## ONLY THOSE LINES ARE SAVED WHICH HAVE THE WORD 'HTTPS' IN THEM, CONSIDERING ONLY
## UNIQUE LINES. UNIQ ONLY WORKS WHEN THE LINES ARE SORTED FIRST. SO WE WILL SORT FIRST.
cat $REQUIREMENTS_FILE | sed 's/\[.*\]//g' | sed 's/(//g' | sed 's/)//g' | grep -i 'https' | uniq > $LINKS_FILE_OUTPUT

## PRINTING URLs BEFORE AND AFTER REMOVING DUPLICATES
echo; echo ">> PRINTING URLs BEFORE REMOVING DUPLICATES >>" ;
cat $REQUIREMENTS_FILE | grep -i 'https' | sort | nl
echo; echo ">> PRINTING URLs AFTER REMOVING DUPLICATES >>" ;
cat $LINKS_FILE_OUTPUT | nl
echo;


## Now run the for loop over all item node values (8 top entries are chosen because
## this particular rss feed file contains only 8 entries)
echo "Initializing the HTML file : $OUTPUT_HTML_FILE " ;

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
	<div class='container'>" > $OUTPUT_HTML_FILE ;

echo "<p>Hello [Name,fallback=]</p><p><strong>🍴Here are the latest recipes from <a href='https://www.mygingergarlickitchen.com/' target='_blank'>our blog</a> and recipe videos from <a href='https://www.youtube.com/user/anupamabhishek/' target='_blank'>our youtube channel</a> directly to your inbox.</strong></p><p>Simply click the buttons below to watch the how-to videos and to download recipes.</p>
<p style='text-align: center; color: #cd1c62; '>&bull; &bull; &bull; &bull; &bull; &bull; &bull; &bull;</p>" >> $OUTPUT_HTML_FILE ; ## WRITING THE FIRST EMPTY LINE, THEN APPENDING LATER

echo "<center>" >> $OUTPUT_HTML_FILE; 

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

        ## SAving the url locally
        curl -s $line > $TMP_CURL_FILE ;

        ## EXTRACTING TITLE
        TITLE=$( cat $TMP_CURL_FILE | grep -i 'og:title' | sed 's/<meta property=\"og:title\" content=\"//g'  | sed 's/\" \/>//g' | sed 's|">||g') ;
        echo "TITLE = $TITLE " ;

        ## EXTRACTING META DESCRIPTION
        #### (long descriptions will be trimmed after 200 chars, so that all will have equal length)
        META_DESCRIPTION=$( cat $TMP_CURL_FILE | grep -i 'og:description' | sed 's/<meta property=\"og:description\" content=\"//g'  | sed 's/\" \/>//g' | sed 's|">||g' | cut -c1-180 ) ;

        LENGTH_METADESC=$(echo $META_DESCRIPTION | awk '{print length}') ;
        echo "===========> LENGTH_METADESC = $LENGTH_METADESC" ;
        ## ADD TRHEE DOTS IF LENGTH_METADESC IS > 170
        if [[ "$LENGTH_METADESC" -lt 170 ]] ; then
          META_DESCRIPTION=$META_DESCRIPTION
        else
          META_DESCRIPTION="$META_DESCRIPTION..." ;
        fi

        echo "META_DESCRIPTION = $META_DESCRIPTION " ;

        ## EXTRACTING URL
        URL=$( cat $TMP_CURL_FILE | grep -i 'og:url' | sed 's/<meta property=\"og:url\" content=\"//g'  | sed 's/\" \/>//g'  | sed 's|">||g') ;
        echo "PAGE URL = $URL " ;

        ## EXTRACTING IMAGE URL
        IMAGE=$( cat $TMP_CURL_FILE | grep -i 'og:image:secure_url' | sed 's/<meta property=\"og:image:secure_url\" content=\"//g'  | sed 's/\" \/>//g'  | sed 's|">||g') ;
        echo "IMAGE = $IMAGE " ;

          ## DOWNLOADING THE IMAGE INTO A SPECIFIC FOLDER (folder will be created if not present already)
          #wget -P _TMP_IMAGES_$REQUIREMENTS_FILE/ $IMAGE


        ## PRINTING TO HTML
        echo "<h3><a style='color: #cd1c62;' href='$URL'>$COUNT.) $TITLE</a></h3>" >> $OUTPUT_HTML_FILE;
        echo "<p>$META_DESCRIPTION</p>" >> $OUTPUT_HTML_FILE ;
        echo "<p><a href='$URL'><img src='$IMAGE' alt='$TITLE' width='400' height='600' /></a></p>" >> $OUTPUT_HTML_FILE;  

        echo "<div style='background-color: #cd1c62;
        border: 2px solid #cd1c62;
        padding: 10px;
        color: white;
        border-radius: 100px;
        text-align: center;
        display: inline-block;'>
        <a style='color: white;' href='$URL' target='_blank'>Check out full post &rarr;</a></div>" >> $OUTPUT_HTML_FILE ;
        
        echo "<p style='text-align: center; color: #cd1c62; '>&bull; &bull; &bull; &bull; &bull; &bull; &bull; &bull;</p>" >> $OUTPUT_HTML_FILE ;

        (( COUNT++ ))

    done < $LINKS_FILE_OUTPUT

  echo "</div></div> <!-- END: ALL CONTENT COLUMN+ROW -->"  >> $OUTPUT_HTML_FILE ;
###############################################################################

################################################################################
echo "<hr>
<strong>I hope you will love them.<br><br>Best wishes,</strong>
<br>
<img align='none' height='35' src='https://gallery.mailchimp.com/126a7c0d8271b7ec930c15e67/images/623b3f2b-7d5f-426d-857a-2c3175fdd285.png' style='width: 110px; height: 35px;'>

<!-- Google Analytics Image -->
<img src='http://www.google-analytics.com/collect?v=1&amp;tid=UA-48712319-2&amp;cid=mggkmailchimp&amp;t=event&amp;ec=dailyemailmailChimp&amp;ea=open&amp;el=dailyemailmailChimp&amp;cs=gmail-inbox&amp;cm=email&amp;cn=dailyemailmailChimp' style='border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;height: auto !important;'>" >> $OUTPUT_HTML_FILE ;


echo "<hr>" >> $OUTPUT_HTML_FILE ;
echo "<p>&nbsp;</p>" >> $OUTPUT_HTML_FILE ;
echo "<webversion>View web version</webversion> // <unsubscribe>Unsubscribe</unsubscribe>" >> $OUTPUT_HTML_FILE ;
echo "<p><a href='https://www.mygingergarlickitchen.com' target='_blank'><img src='https://www.mygingergarlickitchen.com/wp-content/uploads/2015/02/mggk-new-logo-transparent-150px.png' width='100px' ;></img></a></p>" >> $OUTPUT_HTML_FILE ;

echo "</center>" >> $OUTPUT_HTML_FILE ;

echo "<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src='https://code.jquery.com/jquery-3.3.1.slim.min.js' crossorigin='anonymous'></script>
<script src='https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js' crossorigin='anonymous'></script>
<script src='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js' crossorigin='anonymous'></script>
</body>
</html>" >> $OUTPUT_HTML_FILE ;

##########################################
## Replacing strange characters to formal html symbols and saving to final html file
cat $OUTPUT_HTML_FILE | sed 's/&lt;/</g' | sed 's/&gt;/>/g' | sed 's/&amp;lsquo;/"/g' | sed 's/&amp;rsquo;/"/g' | sed 's/&amp;#8216;/"/g' > $OUTPUT_HTML_FILE_FINAL
################################################################################

## Opening directory = PWD
# This command works only on mac
echo ">>>> OPENING HTML FILE IN BROWSER ..." ;
open $myPWD ;
open $OUTPUT_HTML_FILE ;
