#!/bin/bash
#################################################################################
REQUIREMENTS_FILE="999-EVENT-NAMES-WITH-DATES.txt"
#################################################################################
cat << EOF
	###############################################################################
	## THIS PROGRAM READS A TEXT FILE CONTAINING DATES AND EVENTS IN SPECIFIED
  ## FORMAT, THEN PARSES THEM AND MAKES AN HTML EVENTS INDEX HTML FILE USING
  ## JAVASCRIPT MOMENT LIBRARY
  #### REQUIREMENTS FILE = $REQUIREMENTS_FILE
	##############################################################################
	## MADE BY: PALI
	## DATE: AUGUST 31 2019
	###############################################################################
EOF

## CD to a chosen directory on desktop
PWD="$HOME/Desktop/Y"
cd $PWD ;
echo ">>>> PWD is $PWD" ;

## DEFINE SOME VARIABLE FILENAMES
##########################################################
OUTPUT_HTML_FILE="INDEX-OF-OUR-EVENTS.html"
#prefix="swimming" ## for swimming
prefix="skating" ## for skating
##########################################################
##########################################################

## Initializing the HTML file : WRITING THE FIRST LINE, THEN APPENDING LATER
echo "Initializing the HTML file : $OUTPUT_HTML_FILE " ;

echo "<!DOCTYPE html>
<html lang='en' >

<head>
  <meta charset='UTF-8'>
  <title>INDEX OF OUR EVENTS</title>

  <meta http-equiv='refresh' content='30'> <!-- Refresh every 30 seconds -->

  <!-- Loading moment.js from CDN -->
  <script src='https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js'></script>
</head>

<body style='font-family: sans-serif;'>
  <center>

  <p style='color: #c0c0c0; '>// This page auto-refreshes every 30 seconds // </p>
  <h3>Right now, it's <span id='dateDisplay'></span> </h3>

  <h1>INDEX OF OUR EVENTS</h1>

  <hr>" > $OUTPUT_HTML_FILE ;

##########################################################
##########################################################
echo;
input1="tmp.txt"
count=0;
echo "// formatting: list of $prefix dates below, relative time from today" ;
while IFS= read -r line
do
  (( count++ ))
  #echo $count

  var1="let date$prefix$count = moment(\""
  var2="\", \"YYYYMMDD h:mm:dd\").fromNow();"

  echo "$var1$line$var2" ;

done < "$input1"
############################################################

############################################################
echo;
input2="tmp2.txt"
count2=0;
echo "// formatting: list of $prefix dates below for displaying as plain text"
while IFS= read -r line
do
  (( count2++ ))
  #echo $count
  var0="plain"
  var1="let date$prefix$count2$var0 = moment(\""
  var2="\").format('[on] dddd - MMMM Do YYYY, [at] h:mm:ss a'); "

  echo "$var1$line$var2" ;

done < "$input2"
############################################################


#############################################################
#############################################################
## Depending upon the number of lines in tmp files, on the
## basis of count and count2++ variables, we will publish some more
## info onto the CLI
##############################################################
echo;
echo "<!-- $prefix: The DIVs will be printed below -->" ;
for x in $(seq 1 $count) ; do
  echo "<h2 style=\"color: deeppink;\" id=\"$prefix$x\"></h2> " ;
done
###############
echo;
echo "// $prefix: Getting the values for the DIVs from variables" ;
for x in $(seq 1 $count) ; do
  echo "document.getElementById(\"$prefix$x\").innerHTML = date$prefix$x + \"<br><span style='color:silver;'>(\" + date$prefix$x$var0 + \")</span>\" ; " ;
done
##############
