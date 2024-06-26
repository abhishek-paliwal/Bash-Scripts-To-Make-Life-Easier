#!/bin/bash
#################################################################################
REQUIREMENTS_FILE="999_01-ONLY-EDIT-THIS-FILE-WITH-EVENT-NAMES-AND-DATES.txt"
#################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
	###############################################################################
	## THIS PROGRAM READS A TEXT FILE CONTAINING DATES AND EVENTS IN SPECIFIED
	## FORMAT, THEN PARSES THEM AND MAKES AN HTML EVENTS INDEX HTML FILE USING
	## JAVASCRIPT MOMENT LIBRARY
	#### REQUIREMENTS FILE = $REQUIREMENTS_FILE
	#################### FORMAT OF REQUIREMENTS FILE: #############################
	# 20190902,16:10:00,deeppink,Skating-Class
	# 20190909,16:10:00,deeppink,Skating-Class
	# 20190916,16:10:00,deeppink,Skating-Class
	# 20190923,16:10:00,deeppink,Skating-Class
	# ...
	# ...
	##############################################################################
	## CODED BY: PALI
	## DATE: SEPTEMBER 04 2019
	###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


## CD to a chosen directory on desktop
#PWD="$HOME/Desktop/Y"
PWD="$(pwd)"
cd $PWD ;
echo; echo ">>>> PWD is $PWD" ; echo;

## DEFINE SOME VARIABLE FILENAMES
##########################################################
OUTPUT_HTML_FILE="INDEX-OF-OUR-EVENTS.html"
#prefix="swimming" ## for swimming
prefix="Event" ## for skating
##########################################################
##########################################################

## BEFORE DOING ANYTHING, SORT THE REQUIREMENTS FILE AND CREATE A TEMPORARY FILE
## SO THAT ALL THE DATES ARE IN SORTED ORDER, SO THAT LINES APPEAR CHRONOLOGICALLY.
REQUIREMENTS_FILE_SORTED="_TMP_SORTED_$REQUIREMENTS_FILE" ;
rm $REQUIREMENTS_FILE_SORTED

## CREATE A TEMP FILE BY REMOVING ALL LINES CONTAINING #'s
cat $REQUIREMENTS_FILE | grep -v '#' | sort -n > _TMP1.TXT ;

while IFS= read -r line
do
	## EXTRACT THE DATES FROM EACH LINE, MEANING FIRST 8 CHARS OF EACH LINE
	## after removing the leading and trailing whitespaces thru sed
	myVar=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | cut -c1-8) ;
	myDateVar=$(date +%Y%m%d) ;

	## COMPARE THE TWO DATES
	## IF THE DATE HAS PASSED, DELETE THAT LINE FROM THE SORTED FILE.
	if [ "$myVar" -gt "$myDateVar" ]; then
    echo "Event on $myVar will BE INCLUDED in html output. It means it's after today (= $myDateVar), in the future." ;
		echo "$line" >> $REQUIREMENTS_FILE_SORTED ;
	elif [ "$myVar" -eq "$myDateVar" ]; then
		echo "Event on $myVar will BE INCLUDED in html output. Because it's today (= $myDateVar)." ;
		echo "$line" >> $REQUIREMENTS_FILE_SORTED ;
	else
		echo "Event on $myVar will NOT BE INCLUDED in html output. Because it was in the past." ;
	fi

done < "_TMP1.TXT"

###############################################################################

## Initializing the HTML file : WRITING THE FIRST LINE, THEN APPENDING LATER
echo "Initializing the HTML file : $OUTPUT_HTML_FILE " ;

echo "<!DOCTYPE html>
<html lang='en' >

<head>
    <!-- Required meta tags -->
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>

    <!-- Bootstrap CSS -->
    <link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css' crossorigin='anonymous'>

		<meta http-equiv='refresh' content='60'> <!-- Refresh every 60 seconds -->
	  <!-- Loading moment.js from CDN -->
	  <script src='https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js'></script>

		<style>
		.bgtheme1 {background: rgb(18,18,18) ; padding: 15px; }
		.bgtheme2 {background: rgb(45,45,45) ; padding: 15px; }
		</style>

	<title>INDEX OF OUR EVENTS</title>

  </head>

<body style='font-family: sans-serif; background:#121212; color:white;'>
  <center>

	<div class='container-fluid'> <!--  BEGIN: CONTAINER -->

	<hr>
	<div style='padding: 3px; background:white; color:#121212;'>
	<h3>INDEX OF OUR EVENTS</h3>
  <h5>Right now, it's <span id='dateDisplay'></span> </h5>
	</div>
  <hr>" > $OUTPUT_HTML_FILE ;

##########################################################

############################################################
## OUTPUT BLOCK 1
############################################################
echo;
echo "<!-- $prefix: The DIVs will be printed below -->" >> $OUTPUT_HTML_FILE ;
x=0;
while IFS= read -r line
do
  (( x++ ))
	mycolor=$( echo "$line" | awk -F "," '{print $3}' ) ;

	if (( $x%2 == 0 )) ; then
		echo "<h4 class='bgtheme1' style=\"color: $mycolor;\" id=\"$prefix$x\"></h2> " >> $OUTPUT_HTML_FILE ;
	else
		echo "<h4 class='bgtheme2' style=\"color: $mycolor;\" id=\"$prefix$x\"></h2> " >> $OUTPUT_HTML_FILE ;
	fi

done < "$REQUIREMENTS_FILE_SORTED"

echo ">>>> OUTPUT BLOCK 1 ... DONE!!" ;
############################################################

########## ++++++++++ BEGIN HEADER: SCRIPT BLOCK  ++++++++++++ ############
		echo "<!-- BEGIN: Scripts will load below -->
		<script type='text/javascript'>
		// format TODAY
		let today = moment().format('MMMM Do YYYY, h:mm:ss a') ;
		document.getElementById('dateDisplay').innerHTML = today;" >> $OUTPUT_HTML_FILE ;
########## ++++++++++ END HEADER: SCRIPT BLOCK  ++++++++++++ ############


############################################################
## OUTPUT BLOCK 2
############################################################

echo;
count=0;
echo "// formatting: list of $prefix dates below, relative time from today" >> $OUTPUT_HTML_FILE ;
while IFS= read -r line
do
  (( count++ ))
  #echo $count

	mydate=$( echo "$line" | awk -F "," '{print $1}' ) ;
	mytime=$( echo "$line" | awk -F "," '{print $2}' ) ;
	mycolor=$( echo "$line" | awk -F "," '{print $3}' ) ;
	mytitle=$( echo "$line" | awk -F "," '{print $4}' ) ;

  var1="let date$prefix$count = moment(\""
  var2="\", \"YYYYMMDD h:mm:dd\").fromNow();"

  echo "$var1$mydate $mytime$var2" >> $OUTPUT_HTML_FILE ;

done < "$REQUIREMENTS_FILE_SORTED"

echo ">>>> OUTPUT BLOCK 2 ... DONE!!" ;
############################################################

############################################################
## OUTPUT BLOCK 3
############################################################
echo;
count2=0;
echo "// formatting: list of $prefix dates below for displaying as plain text" >> $OUTPUT_HTML_FILE ;
while IFS= read -r line
do
  (( count2++ ))
  #echo $count

	mydate=$( echo "$line" | awk -F "," '{print $1}' ) ;
	mytime=$( echo "$line" | awk -F "," '{print $2}' ) ;
			mytime1=$(echo "$mytime" | sed "s/://g") ; ## Removing : from mytime var

	mycolor=$( echo "$line" | awk -F "," '{print $3}' ) ;
	mytitle=$( echo "$line" | awk -F "," '{print $4}' ) ;

  var0="plain"
  var1="let date$prefix$count2$var0 = moment(\""
  var2="\").format('[on] dddd - MMMM Do YYYY, [at] h:mm:ss a'); "

	finalTextVar=$(echo $mydate"T"$mytime1) ;

  echo "$var1$finalTextVar$var2" >> $OUTPUT_HTML_FILE ;

done < "$REQUIREMENTS_FILE_SORTED"

echo ">>>> OUTPUT BLOCK 3 ... DONE!!" ;
############################################################

############################################################
## OUTPUT BLOCK 4
############################################################
echo;
echo "// $prefix: Getting the values for the DIVs from variables" >> $OUTPUT_HTML_FILE ;
x=0;
while IFS= read -r line
do
  (( x++ ))
	mycolor=$( echo "$line" | awk -F "," '{print $3}' ) ;
	mytitle=$( echo "$line" | awk -F "," '{print $4}' ) ;

	echo "document.getElementById(\"$prefix$x\").innerHTML = \"<span style='text-transform: uppercase;'>\" + date$prefix$x + \"</span> - $mytitle\" + \"<br><span style='color:silver;'>(\" + date$prefix$x$var0 + \")</span>\" ; " >> $OUTPUT_HTML_FILE ;

done < "$REQUIREMENTS_FILE_SORTED"

echo ">>>> OUTPUT BLOCK 4 ... DONE!!" ;
############################################################

########## ++++++++++ BEGIN FOOTER: SCRIPT BLOCK  ++++++++++++ ############
		echo "</script>
		<!-- END: Scripts will load above -->

			<hr>
			<p style='color: #444444; '>// This html output page auto-created at: $(date) //</p>
		  <p style='color: #444444; '>// This page auto-refreshes every 60 seconds // </p>

			<!-- Optional Bootstrap 4 official JavaScript -->
	    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
	    <script src='https://code.jquery.com/jquery-3.3.1.slim.min.js' crossorigin='anonymous'></script>
	    <script src='https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js' crossorigin='anonymous'></script>
	    <script src='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js' crossorigin='anonymous'></script>

		</div> <!--  END : CONTAINER -->
		</body></html>" >> $OUTPUT_HTML_FILE ;
########## ++++++++++ END FOOTER: SCRIPT BLOCK  ++++++++++++ ############
