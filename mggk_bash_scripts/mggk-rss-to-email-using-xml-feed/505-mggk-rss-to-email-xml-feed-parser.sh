#!/bin/bash
###############################################################################
## THIS PROGRAM PARSES THE INDEX.XML RSS FEED FILE FROM MGGK URL, AND CREATES
## AN HTML FILE READY TO BE SENT THRU EMAIL TO EMAIL SUBSCRIBERS, AFTER COPYING
## AND PASTING ITS SOURCE CODE INTO ANY EMAIL PROGRAM (SENDY, MAILCHIMP
## OR SENDGRID)
## MADE BY: PALI
## DATE: MARCH 17 2019
###############################################################################

## CD to temporary directory on desktop
PWD="$HOME/Desktop/_TMP_Automator_results_"
cd $PWD ;
echo ">>>> PWD is $PWD" ;

## DEFINE SOME VARIABLE FILENAMES
OUTPUT_RSSFEED_FILE="mggk-rssfeed.xml" ;
OUTPUT_HTML_FILE="tmp-output-rss.html"

## first download the xml file locally and save as feed.xml
curl -s https://www.mygingergarlickitchen.com/index.xml > $OUTPUT_RSSFEED_FILE
echo "XML RSS FEED locally saved at $PWD" ;
echo ;

## Now run the for loop over all item node values (8 top entries are chosen because
## this particular rss feed file contains only 8 entries)
echo "Initializing the HTML file : $OUTPUT_HTML_FILE " ;
echo "" > $OUTPUT_HTML_FILE ; ## WRITING THE FIRST EMPTY LINE, THEN APPENDING LATER

echo ">>>> Beginning FOR LOOP" ;
for x in {1..8}
do
	TITLE=$( xmlstarlet sel -t -v "/rss/channel/item[$x]/title" $OUTPUT_RSSFEED_FILE ) ;
	PUBDATE=$( xmlstarlet sel -t -v "/rss/channel/item[$x]/pubDate" $OUTPUT_RSSFEED_FILE ) ;
	LINK=$( xmlstarlet sel -t -v "/rss/channel/item[$x]/link" $OUTPUT_RSSFEED_FILE ) ;
	DESCRIPTION=$( xmlstarlet sel -t -v "/rss/channel/item[$x]/description" $OUTPUT_RSSFEED_FILE ) ;

	echo "<h1><a href='$LINK'># $x : $TITLE</a></h1>" >> $OUTPUT_HTML_FILE;
	echo "<p>Updated: $PUBDATE</p>" >> $OUTPUT_HTML_FILE ;
	echo "<p>$DESCRIPTION</p><br>" >> $OUTPUT_HTML_FILE ;
	echo "<div style='width: 97% ; color : white ; background-color: pink ; padding: 5px ;'><a href='$LINK'>Read full post and watch video</a></div>" >> $OUTPUT_HTML_FILE ;
	echo "<hr>" >> $OUTPUT_HTML_FILE ;

	echo ; echo "Running for: item[$x] : $TITLE " ;
	echo "DONE ... running for NODE = item[$x]" ;
done

## Replacing strange characters to formal html symbols and saving to final html file
cat $OUTPUT_HTML_FILE | sed 's/&lt;/</g' | sed 's/&gt;/>/g' | sed 's/&amp;lsquo;/"/g' | sed 's/&amp;rsquo;/"/g' | sed 's/&amp;#8216;/"/g' > FINAL_OUTPUT_HTML_FILE.html

## Opening directory = PWD
# This command works only on mac
open $PWD
