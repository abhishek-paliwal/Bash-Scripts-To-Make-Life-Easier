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

echo -n "Enter WIDTH (= HEIGHT) in PIXELS, without 'px' sign : (e.g., 300 ) [ENTER]: "
read imageWidth

echo -n "Enter MARGIN in PIXELS, without 'px' suffix: (0 [zero] means No Margin) [ENTER]: "
read imageMargin

echo -n "Enter DROP-SHADOW in PIXELS, without 'px' suffix: (0 [zero] means No Shadow) [ENTER]: "
read dropShadow
## Some calculation through bash shell.
eachSideShadow=`echo "scale=2 ; $dropShadow/3" | bc` ;

echo -n "Enter BACKGROUND COLOR in hex / rgb / rgba : {e.g., #3498db OR rgba(255,0,120,1) } [ENTER]: "
read backgroundColor



echo "<html><head><title>$filenamex</title>" > $filenamex

echo "<link href='https://fonts.googleapis.com/css?family=Oswald' rel='stylesheet'>

<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js'></script>

<!-- LAZY-LOADER OF IMAGES -  JQUERY Plugin -->
<script type='text/javascript' src='https://abhishek-paliwal.github.io/wallpaper_creators/js/JQUERY.LAZY.MIN.js'></script>

<script>

  \$(document).ready(function(){
        // ENABLING LAZY LOADING
        \$('.lazy').lazy();  // More info at : http://jquery.eisbehr.de/lazy/
  });

</script>

<!-- STYLE BEGINS -->
<style>

.lazy {
    width: `echo $imageWidth`px ;
    margin: `echo $imageMargin`px;
    box-shadow: -`echo $eachSideShadow`px `echo $eachSideShadow`px `echo $dropShadow`px rgba(0,0,0,0.7) ;
}

.lazy-equal-height {
    height: `echo $imageWidth`px ;
		width: auto ;
    margin: `echo $imageMargin`px;
    box-shadow: -`echo $eachSideShadow`px `echo $eachSideShadow`px `echo $dropShadow`px rgba(0,0,0,0.7) ;
}

.lazy-drop-shadow {
		width: `echo $imageWidth`px ;
		margin: `echo $imageMargin`px;
		border : 10px solid white ;
		box-shadow: 0px 0px 5px #aaa ;
		border-radius : 2px ;
}

<!-- STYLE ENDS -->

</style>" >> $filenamex

echo "</head><body style='background-color : $backgroundColor ;' >" >> $filenamex

echo "<h1>Images with Lazy Loading...</h1>" >> $filenamex

######### GRID ELEMENTS WITH EQUAL WIDTH ######
echo "<h2>1. Grid Elements With Equal Width</h2>"  >> $filenamex
echo "<div class='grid'> <!-- LAZY LOADING - equal width GRID BEGINS -->"  >> $filenamex
for x in `ls *.{jpg,png,PNG,JPG} | sort -n -k1.$sortnumber`
	do
		echo "<a href='$x'><img loading='lazy' src='$x' align='top'></img></a>" >> $filenamex
	done;
echo "</div> <!-- LAZY LOADING - equal width GRID ENDS --<hr>" >> $filenamex
###############################################

######### GRID ELEMENTS WITH EQUAL HEIGHT ######
echo "<h2>2. Grid Elements With Equal Height</h2>"  >> $filenamex
echo "<div class='grid'> <!-- LAZY LOADING - equal height GRID BEGINS -->"  >> $filenamex
for x in `ls *.{jpg,png,PNG,JPG} | sort -n -k1.$sortnumber`
	do
		echo "<a href='$x'><img class='lazy lazy-equal-height' src='$x' align='top'></img></a>" >> $filenamex
	done;
echo "</div> <!-- LAZY LOADING - equal height GRID ENDS --><hr>" >> $filenamex
###############################################

######### GRID ELEMENTS WITH EQUAL WIDTH AND DROP SHADOW ######
echo "<h2>3. Grid Elements With Equal Width And Drop Shadow</h2>"  >> $filenamex
echo "<div class='grid'> <!-- LAZY LOADING - equal width drop shadow GRID BEGINS -->"  >> $filenamex
for x in `ls *.{jpg,png,PNG,JPG} | sort -n -k1.$sortnumber`
	do
		echo "<a href='$x'><img class='lazy lazy-drop-shadow' src='$x' align='top'></img></a>" >> $filenamex
	done;
echo "</div> <!-- LAZY LOADING - equal width drop shadow GRID ENDS --><hr>" >> $filenamex
###############################################

echo "</body></html>" >> $filenamex

#Open the newly created file in browser
echo "DONE! File will now be opened in SAFARI."
open -a Safari $filenamex
