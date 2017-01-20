#!/bin/bash
## BEFORE AND AFTER IMAGE DIFFERENCES - CHECKER SCRIPT
## THIS SCRIPT CREATES A 2-COLUMN BEFORE-AND-AFTER HTML FILE WITH...
## ...ALL THE IMAGES TAKEN FROM THE ORIGINAL AND EDITED FOLDERS IN WORKING DIRECTORY

BASE_FOLDER=`pwd`
EDITED_IMAGE_FOLDER="$BASE_FOLDER/edited";
ORIGINAL_IMAGE_FOLDER="$BASE_FOLDER/original";

echo '==================='
echo "CURRENT WORKING DIRECTORY: " $BASE_FOLDER ##check the present working directory
cd $EDITED_IMAGE_FOLDER ## All the following commands run from the 'edited' folder
echo '==================='

echo '======== Current filename order in $EDITED_IMAGE_FOLDER ========'
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

#ASSIGN FILENAME. AND NO SPACES BETWEEN VARNAME and '=' SIGN; else Bash throws error.
totalfiles="`ls -l *.{jpg,png,PNG,JPG} | wc -l | tr -d '[[:space:]]'`"
totalfiles+=" Edited Images"
echo "TOTAL : $totalfiles" ##This output might show leading spaces, donno why. So SED is used below.

filenamex=`echo "before-and-after-differences-$totalfiles.html" | sed -e 's/ /-/g'`

#### HTML making begins ###

usage_text="<div style='width:90%; padding: 10px; border: 10px double #000; background-color:#dddddd; color:red; font-size:1.5em;'>
BEFORE RUNNING THE SCRIPT, FOLLOW THESE STEPS CAREFULLY:
<br>==> STEP 1. In an empty BASE folder, create 2 folders named as: 'edited' and 'original'
<br>==> STEP 2. Place edited images in 'edited' folder. Name them as file1.jpg, file2.jpg, etc.
<br>==> STEP 3. Place original images in 'original' folder
<br>==> STEP 4. Prefix all the original images with the word 'original-', so that they become original-file1.jpg, original-file2.jpg, etc.
<br>==> STEP 5. Final Step: cd to BASE folder, and run the script command from there.
</div>"

echo "<html><head><title>$filenamex</title></head><body>" > $filenamex
echo "<body>" >> $filenamex
echo $usage_text >> $filenamex
echo "<h1>Check Out the Before (Original on LEFT) and After (Edited on RIGHT) Image Differences Below</h1>" >> $filenamex
echo "<h2 style='color: blue;'> >>> TOTAL : $totalfiles <<< </h2>" >> $filenamex
echo "<h3>Page Generated : " `date` "</h3>">> $filenamex
echo "<hr>">> $filenamex

for x in `ls *.{jpg,png,PNG,JPG} | sort -n -k1.$sortnumber`
	do
		echo "<img src='$ORIGINAL_IMAGE_FOLDER/original-$x' width='49%' align='top'></img>
    <img src='$EDITED_IMAGE_FOLDER/$x' width='49%' align='top'></img>
    <br><br>" >> $filenamex
	done;

echo "</body></html>" >> $filenamex

#Open the newly created file in browser
echo "DONE! File will now be opened in Safari."
open -a Safari $filenamex
