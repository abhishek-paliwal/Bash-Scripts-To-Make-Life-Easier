#!/bin/bash;
## THIS SCRIPT CREATES AN HTML FILE WITH...
## ...ALL THE IMAGES IN WORKING DIRECTORY
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

echo -n "Enter the % size of images to use (99 works best) [ENTER]: "
read imagesize

echo "<html><head><title>$filenamex</title></head><body>" > $filenamex

for x in `ls *.{jpg,png,PNG,JPG} | sort -n -k1.$sortnumber`
	do
		echo "<img src='$x' width='$imagesize%' align='top'></img>" >> $filenamex
	done;

echo "</body></html>" >> $filenamex

#Open the newly created file in browser
echo "DONE! File will now be opened in SAFARI."
open -a Safari $filenamex
