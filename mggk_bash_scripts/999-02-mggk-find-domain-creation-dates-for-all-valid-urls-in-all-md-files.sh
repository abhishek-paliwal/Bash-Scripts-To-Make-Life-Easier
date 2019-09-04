#!/bin/bash
################################################################################
## THIS PROGRAM PERFORMS THESE IN STEPS FROM MULTIPLE TEXT FILES:
#### First, finds all the URLs recursively in multiple text/md files, then:
#### STEP 1: EXTRACTS THE INDIVIDUAL URLS AND SAVE EACH IN A VARIABLE
#### STEP 2: FIND THE CREATION DATE OF THE DOMAIN OF THAT URL
#### STEP 3: THROUGH CLI, FIND THE DOMAIN AUTHORITY (DA) OR DOMAIN RANK (DR) OR PAGERANK
################################################################################
## DATE: Monday September 2, 2019
## CREATED BY: Pali
################################################################################
################################################################################

## VARIABLES SETUP
## SETTING UP THE DIRECTORY WHERE FILES ARE LOCATED:
FILEDIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/blog/99_uncategorized/_DONE_99_uncategorized/_ARCHIVED/_after_may2019" ;
HTML_OUTPUT_FILE="_TMP-999-OUTPUT-RESULT.html"
TMP_FILE="_TMP-999.txt" ;

##
echo ">>>> Current FILEDIR = $FILEDIR" ;
echo ">>>> HTML_OUTPUT_FILE = $HTML_OUTPUT_FILE" ;
##

## CD to Y directory on desktop
PWD="$HOME/Desktop/Y" ;
cd $PWD
echo ">>>> Current working directory is $PWD" ;

################################################################################
## STEP 1: EXTRACT THE INDIVIDUAL URLS AND SAVE IT IN A VARIABLE, THROUGH GREP
################################################################################

##############
##INITIALIZING HTML_OUTPUT_FILE
##############
# First line
echo "Output HTML created on: $(date) // From bash program: 999-02-mggk-find-domain-creation-dates-for-all-valid-urls-in-all-md-files.sh" > $HTML_OUTPUT_FILE
# Appending second line onwards
echo "<h1>INDEX of EXTERNAL URLs with their domain creation date</h1>" >> $HTML_OUTPUT_FILE
echo "<h3>(Found by whois command through CLI)</h3>" >> $HTML_OUTPUT_FILE

echo "<hr>" >> $HTML_OUTPUT_FILE

#########################################################
## FINDING URLS BY PARSING EACH MD FILE in $FILEDIR
echo "<h2 style='color:red;'>SECTION 1/3:<br> List of all external links found in each file in directory = <br>$FILEDIR</h2>" >> $HTML_OUTPUT_FILE

filecount=0;
for filename in $(find $FILEDIR -name '*.md' | sort) ;
do
  ((filecount++))

  echo "<hr>" >> $HTML_OUTPUT_FILE
  echo "<h3 style='color:blue;'>FILE# $filecount //</h3> <br>EXTERNAL URLs found in FILE = <strong>$filename</strong>" >> $HTML_OUTPUT_FILE


  echo "<pre>" >> $HTML_OUTPUT_FILE
  grep -rEoh "(http|https)://[a-zA-Z0-9./?=_-]*" $filename | grep -iv 'mygingergarlickitchen.com' >> $HTML_OUTPUT_FILE
  echo "</pre>" >> $HTML_OUTPUT_FILE

  ## finding the URL of the blog post in YAML frontmatter
  myurl=$(grep -rEoh "^url:.*[a-zA-Z0-9./?=_-]*" $filename | tr -d '[:space:]'| sed 's/url:/https:\/\/www.MyGingerGarlicKitchen.com/g') ;
  echo "<p>Direct Post link: <a href='$myurl'>$myurl</a></p>" >> $HTML_OUTPUT_FILE

  ## Where to find the DA (Domain Authority) in bulk
  echo "<p>Check DA for these here, upto 10 URLs at once: <a href='https://www.checkmoz.com'>https://www.checkmoz.com</a></p>" >> $HTML_OUTPUT_FILE

  ## PRINTING ON CLI FOR QUICK REFERENCE
  echo; echo "FILE# $filecount // EXTERNAL URLs found in FILE => $filename" ;
  grep -rEoh "(http|https)://[a-zA-Z0-9./?=_-]*" $filename  | grep -iv 'mygingergarlickitchen.com'| nl
done
##########################################################

###############################################################################
## STEP 2: FIND THE CREATION DATE OF THE DOMAIN OF THE URL
# USING THE ABOVE TEXT FILE TO WORK WITH INDIVIDUAL LINES AS INDIVIDUAL URLs
# AND FINDING THEIR DOMAIN CREATION DATE (BECAUSE THIS AFFECTS DA IN GOOGLE RANKING)
##########################################################

## SAVING OUTPUT LINKS TO A TMP TEXT FILE WHICH WE WILL USE LATER
grep -rEoh "(http|https)://[a-zA-Z0-9./?=_-]*" $FILEDIR | sort | uniq | grep -iv 'mygingergarlickitchen.com' > $TMP_FILE

## PRINTING THE SAME OUTPUT ON CLI
grep -rEoh "(http|https)://[a-zA-Z0-9./?=_-]*" $FILEDIR | sort | uniq | grep -iv 'mygingergarlickitchen.com' |nl

## PRINTING THE SAME OUTPUT IN HTML FILE
echo "<hr><h2 style='color:red;'>SECTION 2/3:<br> All EXTERNAL URLs (Sorted Unique) found in all the files in directory = <br>$FILEDIR</h2>" >> $HTML_OUTPUT_FILE
echo "<pre>" >> $HTML_OUTPUT_FILE
grep -rEoh "(http|https)://[a-zA-Z0-9./?=_-]*" $FILEDIR | sort | uniq | grep -iv 'mygingergarlickitchen.com' |nl >> $HTML_OUTPUT_FILE
echo "</pre>" >> $HTML_OUTPUT_FILE

############
## READING THE TMP FILE LINE BY LINE, AND PROCESSING EACH LINE
echo "<hr><h2 style='color:red;'>SECTION 3/3:<br> Domain creation dates of all EXTERNAL URLs (Sorted Unique) found in all the files in directory = <br>$FILEDIR</h2>" >> $HTML_OUTPUT_FILE

echo;
echo "####################################################################" ;
count=0;
echo ">>>> READING LINE BY LINE FROM FILE = $TMP_FILE" ;
while IFS= read -r line
do
  (( count++ ))
  #echo $count

  echo;
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
  echo ;
  echo "$count //"

  ## REMOVING https://www. AND http://www. from the whole urls, then taking only the base url name
  baseurl=$( echo $line | sed 's|http\:\/\/||g' | sed 's|https\:\/\/||g' | sed 's|www.||g' | awk -F "/" '{print $1}'  )

  echo "<hr>" >> $HTML_OUTPUT_FILE

  echo "ORIGINAL URL FOUND = $line" ;
  echo "<br>BASE URL = $baseurl" ;

  echo "<H2>URL# $count</H2>" >> $HTML_OUTPUT_FILE
  echo "<br><strong>ORIGINAL URL FOUND = <a href="$line">$line</a> </strong>" >> $HTML_OUTPUT_FILE
  echo;
  echo "<br>BASE URL = $baseurl" >> $HTML_OUTPUT_FILE
  echo ;

  ########################################################################
  ## RUNNING WHOIS COMMAND
  echo "Running this command = whois $baseurl" ;
  whois $baseurl | grep -i 'creat*' ;

  echo "<pre>" >> $HTML_OUTPUT_FILE
  whois $baseurl | grep -i 'creat*' >> $HTML_OUTPUT_FILE
  echo "</pre>" >> $HTML_OUTPUT_FILE
  #########################################################################

done < $TMP_FILE

echo "<hr><H2>PROGRAM ENDS.</H2>" >> $HTML_OUTPUT_FILE
############################################################
############################################################
## OPENING HTML OUTPUT FILE
echo; echo ">>>> Opening file = $HTML_OUTPUT_FILE "
open $HTML_OUTPUT_FILE ;
#########################################
