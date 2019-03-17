#!/bin/bash
###############################################################################
## THIS PROGRAM PARSES THE INDEX.XML RSS FEED FILE FROM MGGK URL, AND CREATES
## AN HTML FILE READY TO BE SENT THRU EMAIL TO EMAIL SUBSCRIBERS, AFTER COPYING
## AND PASTING ITS SOURCE CODE INTO ANY EMAIL PROGRAM (SENDY, MAILCHIMP
## OR SENDGRID)
## MADE BY: PALI
## DATE: MARCH 17 2019
###############################################################################

OUTPUT_RSSFEED_FILE="mggk-rssfeed.xml" ;

## first download the xml file locally and save as feed.xml
curl -s https://www.mygingergarlickitchen.com/index.xml > $OUTPUT_RSSFEED_FILE

## Now run the for loop over all item node values (8 top entries are chosen because 
## this particular rss feed file contains only 8 entries)
for x in {1..8}
do
	xmlstarlet sel -t -v "/rss/channel/item[$x]/title" $OUTPUT_RSSFEED_FILE ;
	echo ;
	xmlstarlet sel -t -v "/rss/channel/item[$x]/pubDate" $OUTPUT_RSSFEED_FILE ;
	echo ;
	xmlstarlet sel -t -v "/rss/channel/item[$x]/link" $OUTPUT_RSSFEED_FILE ;
	echo ;
	xmlstarlet sel -t -v "/rss/channel/item[$x]/description" $OUTPUT_RSSFEED_FILE ;
	echo ;
done
