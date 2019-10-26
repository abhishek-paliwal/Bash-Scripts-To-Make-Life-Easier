#!/bin/bash
cat << EOF
	###############################################################################
	## THIS PROGRAM PARSES THE INDEX.XML RSS FEED FILE FROM MGGK URL, AND CREATES
	## AN HTML FILE READY TO BE SENT THRU EMAIL TO EMAIL SUBSCRIBERS, AFTER COPYING
	## AND PASTING ITS SOURCE CODE INTO ANY EMAIL PROGRAM (SENDY, MAILCHIMP
	## OR SENDGRID)
	##############################################################################
	## MADE BY: PALI
	## DATE: MARCH 17 2019
	###############################################################################
EOF

## CD to temporary directory on desktop
PWD="$HOME/Desktop/Y"
cd $PWD ;
echo ">>>> PWD is $PWD" ;

## DEFINE SOME VARIABLE FILENAMES
OUTPUT_RSSFEED_FILE="_TMP_505_mggk-rssfeed.xml" ;
OUTPUT_HTML_FILE="_TMP_505_tmp-output-rss.html"
OUTPUT_HTML_FILE_FINAL="_TMP_505_FINAL_OUTPUT_HTML_FILE.html"

###############################################################################
## USER INPUT IS ASKED
echo;
echo "Enter the NUMBER OF POSTS you want in HTML output [KEEP EMPTY TO USE DEFAULTS = 8 ]: " ;
read numPosts ;
## CHECKING IF VALUES ARE ENTERED OR NOT. IF NOT ENTERED, FOLLOWING DEFAULT VALUES WILL BE USED.
if [ -z "$numPosts" ] ; then numPosts="8" ; fi
## PRINTING
echo; echo "NUMBER of posts to be included in HTML output = $numPosts" ;
###############################################################################

## first download the xml file locally and save as feed.xml
curl -s https://www.mygingergarlickitchen.com/index.xml > $OUTPUT_RSSFEED_FILE
echo "XML RSS FEED locally saved at $PWD" ;
echo ;

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


echo "<p>Hello [Name,fallback=]</p><p><strong>🍴Please find the latest food posts below published on the website:</strong></p><p>Simply click the buttons below to watch the how-to videos and to download recipes.</p>
<p style='text-align: center; color: #cd1c62; '>&bull; &bull; &bull; &bull; &bull; &bull; &bull; &bull;</p>" >> $OUTPUT_HTML_FILE ; ## WRITING THE FIRST EMPTY LINE, THEN APPENDING LATER

echo "<center>" >> $OUTPUT_HTML_FILE ;

echo ">>>> Beginning FOR LOOP" ;
for x in $(seq 1 $numPosts)
do
	TITLE=$( xmlstarlet sel -t -v "/rss/channel/item[$x]/title" $OUTPUT_RSSFEED_FILE ) ;
	PUBDATE=$( xmlstarlet sel -t -v "/rss/channel/item[$x]/pubDate" $OUTPUT_RSSFEED_FILE ) ;
	LINK=$( xmlstarlet sel -t -v "/rss/channel/item[$x]/link" $OUTPUT_RSSFEED_FILE ) ;
	DESCRIPTION=$( xmlstarlet sel -t -v "/rss/channel/item[$x]/description" $OUTPUT_RSSFEED_FILE ) ;

	echo "<h3><a style='color: #cd1c62;' href='$LINK'>$x.) $TITLE</a></h3>" >> $OUTPUT_HTML_FILE;
	echo "<p>Published: $PUBDATE</p>" >> $OUTPUT_HTML_FILE ;
	echo "<p>$DESCRIPTION</p>" >> $OUTPUT_HTML_FILE ;
	echo "<div style='background-color: #cd1c62;
	border: 2px solid #cd1c62;
	padding: 10px;
	color: white;
	border-radius: 100px;
	text-align: center;
	display: inline-block;'>
	<a style='color: white;' href='$LINK' target='_blank'>Read full post and watch video &rarr;</a></div>" >> $OUTPUT_HTML_FILE ;
	echo "<p style='text-align: center; color: #cd1c62; '>&bull; &bull; &bull; &bull; &bull; &bull; &bull; &bull;</p>" >> $OUTPUT_HTML_FILE ;

	echo ; echo "Running for: item[$x] : $TITLE " ;
	echo "DONE ... running for RSS XML NODE = item[$x]" ;
done


echo "<hr>
<strong>I hope you will love them.<br><br>Best wishes,</strong>
<br>
<img align='none' height='35' src='https://gallery.mailchimp.com/126a7c0d8271b7ec930c15e67/images/623b3f2b-7d5f-426d-857a-2c3175fdd285.png' style='width: 110px;height: 35px;>
<!-- Google Analytics Image -->
<img src='http://www.google-analytics.com/collect?v=1&amp;tid=UA-48712319-2&amp;cid=mggkmailchimp&amp;t=event&amp;ec=dailyemailmailChimp&amp;ea=open&amp;el=dailyemailmailChimp&amp;cs=gmail-inbox&amp;cm=email&amp;cn=dailyemailmailChimp' style='border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;height: auto !important;'>" >> $OUTPUT_HTML_FILE ;


echo "<hr>" >> $OUTPUT_HTML_FILE ;
echo "<p>&nbsp;</p>" >> $OUTPUT_HTML_FILE ;
echo "<webversion>View web version</webversion> // <unsubscribe>Unsubscribe</unsubscribe>" >> $OUTPUT_HTML_FILE ;
echo "<p><a href='https://www.mygingergarlickitchen.com' target='_blank'><img src='https://www.mygingergarlickitchen.com/wp-content/uploads/2015/02/mggk-new-logo-transparent-150px.png' width='100px' ;></img></a></p>" >> $OUTPUT_HTML_FILE ;

echo "</center>" >> $OUTPUT_HTML_FILE ; ## WRITING THE FIRST EMPTY LINE, THEN APPENDING LATER

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

## Opening directory = PWD
# This command works only on mac
open $PWD
open $OUTPUT_HTML_FILE_FINAL
