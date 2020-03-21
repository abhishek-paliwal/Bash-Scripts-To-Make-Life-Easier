#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
## THIS SCRIPT CREATES AN HTML FILE WITH...
## ...ALL THE IMAGES IN WORKING DIRECTORY
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


echo #Blank line
pwd ##check the present working directory
echo #Blank line

echo '======== Current filename order ========'
ls -1 *.{jpg,png,PNG,JPG} | nl ##sort output as 1 column

echo '==================='
echo `ls -1 *.{jpg,png,PNG,JPG} | head -1 | wc -m`
echo "= Character length including file extension (jpg/JPG or png/PNG)"
echo "So sort number to be used below could be this number minus 5 (or 6)."
echo '==================='

echo -n "Sort filenames at which character number (Enter '1' if you're not sure) [ENTER]:"
read sortnumber

echo '========== So this is the filename order that you want: ========='
ls *.{jpg,png,PNG,JPG} | sort -n -k1.$sortnumber | nl

echo -n "[REQUIRED FIELD] Enter the title for the HTML page; Spaces will be converted to hyphens; [ENTER]: "
read titlename

#ASSIGN FILENAME. AND NO SPACES BETWEEN VARNAME and '=' SIGN; else Bash throws error.
totalfiles="`ls -l *.{jpg,png,PNG,JPG} | wc -l | tr -d '[[:space:]]'`"
totalfiles+=" Images"
echo "$totalfiles"
echo "$titlename-$totalfiles.html" ##this output shows leading spaces, donno why. So SED is used below.

filenamex=`echo "$titlename-$totalfiles.html" | sed -e 's/ /-/g'`

echo -n "Enter the size of the DIV to use (300 works best) [ENTER]: "
read imagesize
imagesize+="px"; #Concatenating px at the end of the number

echo "<html><head><title>$filenamex</title>" > $filenamex

echo "<link href='https://fonts.googleapis.com/css?family=Raleway:400,700' rel='stylesheet'>
<style>

body {
  background: rgba(245,245,245,1) ;
}
div {
    float:left;
    width: $imagesize;
    /* height: $imagesize; */
    padding: 5px;
    margin: 5px;
    color: black;
    font-family: 'Raleway', sans-serif;
    text-align: center;
    font-size: 15px;
    line-height:1;
    /* text-transform: lowercase; */
}

.colored {
  background-color:#00FF00;
  color:white;
  padding: 20px;
  font-weight:700;
}

h1 {
  font-family: 'Raleway', sans-serif;
	text-align: center;
	font-size: 20px;
  font-weight:700;
	line-height:1;
	text-transform: capitalize;
}

img {
  border : 10px solid white ;
}

hr {clear:both;}
</style>" >> $filenamex

echo "</head><body>" >> $filenamex

echo "<h1>$titlename<br>(Total Image Files In This Folder (NON-RECURSIVE) = $totalfiles)</h1>" >> $filenamex

for x in `ls *.{jpg,png,PNG,JPG} | sort -n -k1.$sortnumber`
	do
		echo "<div><a href='$x'><img src='$x' width='100%' align='top'></img><br><br>$x</a></div>" >> $filenamex
	done;


#### OPTIONAL SECTION: Finding and listing all Image files Recursively. ####
totalimagefiles="`find . -type f | egrep -i '\.(jpg|png|PNG|JPG)$' | wc -l | tr -d '[[:space:]]'`"

echo "<hr><br><h1>Total Image Files In This Folder (RECURSIVE) = $totalimagefiles)</h1>" >> $filenamex

for x in `find . -type f | egrep -i '\.(jpg|png|PNG|JPG)$' | sort -n -k1.$sortnumber`
  do
  	echo "<div><a href='$x'><img src='$x' width='100%' align='top'></img><br><br>$x</a></div>" >> $filenamex
  done;
##### OPTIONAL SECTION ENDS #####


#### OPTIONAL SECTION: Findind and listing Photoshop files ####
totalcustomfiles="`find . -type f | egrep -i '\.(psd|ai|svg|eps|key|pages|numbers)$' | wc -l | tr -d '[[:space:]]'`"

echo "<hr><br><h1>Downloadable Psd, Ai, Svg, Eps, Pages, Numbers, Keynote Files (RECURSIVE) = $totalcustomfiles</h1>" >> $filenamex

for y in `find . -type f | egrep -i '\.(psd|ai|svg|eps|key|pages|numbers)$'`
  do
  	echo "<div class='colored'><a href='$y'>DOWNLOAD<br>$y</a></div>" >> $filenamex

  done;

##### OPTIONAL SECTION ENDS #####
echo "<hr>" >> $filenamex

echo "</body></html>" >> $filenamex

#Open the newly created file in browser
echo "DONE! File will now be opened in SAFARI."
open -a Safari $filenamex
