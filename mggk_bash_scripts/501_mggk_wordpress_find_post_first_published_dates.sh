#!/bin/bash
############################################################################
# MADE FOR MGGK:
# THIS PROGRAM EXTRACTS THE first publishedDate OF AN ARTICLE THROUGH curl
# command FROM A LIST
# of URLs WHICH WERE COPY-PASTED FROM THE ORIGINAL sitemap.xml file, FROM
# THE ORIGINAL URL https://www.EXAMPLE.com/sitemap.xml
######################
# NOTE: It is found that the dates are presented as yyyy-mm-ddThh:MM in
# all the wordpress posts html, so we make use of a REGEX of such kind.
######################
# CREATION DATE: Sunday January 13, 2019
# CREATED BY: PALI
############################################################################
############################################################################
# USAGE:
#    - Make sure that there are two folders in PWD,
# _input (containing the sitemap.csv files) and _output (empty folder),
# The directory structure should be like:
# ├── PWD
# │   ├── _input
# │   │   ├── YOURWEBSITENAME_sitemap1.csv
# │   │   └── YOURWEBSITENAME_sitemap2.csv
# │   └── _output
############################################################################
############################## BEGIN #######################################

## DECLARING SOME VARIABLES
INPUT_DIR="_input" ;
OUTPUT_DIR="_output" ;
HTML_FOLDER="_downloaded_html_files" ;
mkdir $HTML_FOLDER ;

DATE_VAR=$(date "+%Y-%m-%d")

###################
PWD=$(pwd)
echo "Present working directory: $PWD"
###################

SITE_PREFIX=$(basename "$PWD") ## GETS THE PRESENT FOLDER NAME
OUTPUT_FILE="$OUTPUT_DIR/$SITE_PREFIX-FINAL-OUTPUT.txt"

############################################################################
############################ REAL MAGIC BEGINS #############################

## Checking which lines have 'http' in them (meaning only those are valid urls)
## Also combining the CSV sitemap files into one file
cat $PWD/$INPUT_DIR/*.csv | grep -i 'http' > _tmp_merged_urls0.csv

### Finding the URLs from sitemap files because they are in column 1
awk -F "," '{print $1}' _tmp_merged_urls0.csv > _tmp_merged_urls1.csv

############################################################################
## Reading each line (url) and extracting date (if it appears in the specificied regex format)

echo "" > $OUTPUT_FILE ## Writing first line

counter=1
while read line; do

    echo "" >> $OUTPUT_FILE ## one blank line (we will need it for perl operation later)
    echo "####################################" >> $OUTPUT_FILE
    echo "LINE: $counter" ## to print on command prompt
    echo "$line"  ## to print on command prompt

    echo "LINE: $counter" >> $OUTPUT_FILE
    echo "$line"  >> $OUTPUT_FILE ## printing URL

    ## Getting the last part of the URL
    URL_TEXT=$(basename "$line") ;

    ## Saving a local copy of the webpage URL
    NEWFILE="$HTML_FOLDER/$DATE_VAR-$counter-$URL_TEXT.html"
    wget -q -O - "$line" > "$NEWFILE"

    echo ">>>> $NEWFILE : HTML file saved."

    ## FINDING THE META DESCRIPTION (FOR EXISTING SEO thru YOAST plugin on WP)
    ## (Getting it from the locally downloaded copy)
        grep -h "^<meta property=\"og:description\" content=\".*\" />" $NEWFILE >> $OUTPUT_FILE

    ## USING curl with regex for the format = yyyy-mm-ddThh:MM (dddd-dd-ddTdd:dd -> d = digit)
    ## (CURL = Getting it from the online copy )
        #curl -s "$NEWFILE" | egrep -oi '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]T[0-9][0-9]:[0-9][0-9]' | sort -nu >> $OUTPUT_FILE
    ## (Getting it from the locally downloaded copy)
        cat "$NEWFILE" | egrep -oi '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]T[0-9][0-9]:[0-9][0-9]' | sort -nu >> $OUTPUT_FILE

    ## Finding the popularity of the post, by finding the number of comments on each post
    ## (CURL = Getting it from the online copy )
        #curl -s "$NEWFILE" | egrep -oi '[0-9]+.comments' | sort -nu  >> $OUTPUT_FILE
    ## (Getting it from the locally downloaded copy)
        cat "$NEWFILE" | egrep -oi '[0-9]+.comments' | sort -nu  >> $OUTPUT_FILE


    ((counter++))

done < _tmp_merged_urls1.csv

############################################################################
## NOW, CONVERTING THE GENERATED OUTPUT FILE TO VALID CSV
## using PERL ONE-LINER (converting from rows to columns)
## More info: <https://stackoverflow.com/questions/25317736/convert-rows-to-columns-with-bash>
perl -00 -lpe 's/\n/,/g' $OUTPUT_FILE > $OUTPUT_FILE-FINAL.csv

############################################################################
################################# END ######################################
############################################################################
