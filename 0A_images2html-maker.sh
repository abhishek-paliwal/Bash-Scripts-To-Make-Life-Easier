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

echo -n "Enter WIDTH in %, without % sign : (e.g., 33 = one-third of screen) [ENTER]: "
read imageWidth

echo -n "Enter HEIGHT in PIXELS, without 'px' suffix : (e.g., 400) [ENTER]: "
read imageHeight

echo -n "Enter MARGIN in PIXELS, without 'px' suffix: (0 [zero] means No Margin) [ENTER]: "
read imageMargin

echo -n "Enter DROP-SHADOW in PIXELS, without 'px' suffix: (0 [zero] means No Shadow) [ENTER]: "
read dropShadow
## Some calculation through bash shell.
eachSideShadow=`echo "scale=2 ; $dropShadow/3" | bc` ;

echo -n "Enter BACKGROUND COLOR in hex / rgb / rgba : {e.g., #3498db OR rgba(255,0,120,1) } [ENTER]: "
read backgroundColor



echo "<html><head><title>$filenamex</title>" > $filenamex

echo "<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js'></script>
<script src='https://abhishek-paliwal.github.io/wallpaper_creators/js/PACKERY.pkgd.js'></script>
<script src='https://abhishek-paliwal.github.io/wallpaper_creators/js/IMAGESLOADED.pkgd.min.js'></script>

<script>
  \$(document).ready(function(){

        // init Packery
        var \$grid = \$('.grid').packery({
            itemSelector: '.grid-item',
            gutter: 0
        });

        // layout Packery after each image loads
        \$grid.imagesLoaded().progress( function() {
          \$grid.packery();
        });

  });
</script>

<!-- STYLE ENDS -->
<style>

/* PACKERY MASONRY GRID STYLES BEGIN */

.grid-item {
    width: $imageWidth% ;
    margin: `echo $imageMargin`px;
    box-shadow: -`echo $eachSideShadow`px `echo $eachSideShadow`px `echo $dropShadow`px rgba(0,0,0,0.7) ;
}

.grid-item-equal-height {
    height: `echo $imageHeight`px ;
		width: auto ;
    margin: `echo $imageMargin`px;
    box-shadow: -`echo $eachSideShadow`px `echo $eachSideShadow`px `echo $dropShadow`px rgba(0,0,0,0.7) ;
}

.grid-item-drop-shadow {
		width: $imageWidth% ;
		margin: `echo $imageMargin`px;
		border : 10px solid white ;
		box-shadow: 0px 0px 5px #aaa ;
		border-radius : 2px ;
}

/* PACKERY MASONRY GRID STYLES END */

<!-- STYLE ENDS -->
</style>" >> $filenamex

echo "</head><body style='background : $backgroundColor ;' >" >> $filenamex

######### GRID ELEMENTS WITH EQUAL WIDTH ######
echo "<h2>1. Grid Elements With Equal Width</h2>"  >> $filenamex
echo "<div class='grid'> <!-- PACKERY MASONRY - equal width GRID BEGINS -->"  >> $filenamex
for x in `ls *.{jpg,png,PNG,JPG} | sort -n -k1.$sortnumber`
	do
		echo "<img class='grid-item' src='$x' align='top'></img>" >> $filenamex
	done;
echo "</div> <!-- PACKERY MASONRY GRID ENDS --><hr>" >> $filenamex
###############################################

######### GRID ELEMENTS WITH EQUAL HEIGHT ######
echo "<h2>2. Grid Elements With Equal Height</h2>"  >> $filenamex
echo "<div class='grid'> <!-- PACKERY MASONRY - equal height GRID BEGINS -->"  >> $filenamex
for x in `ls *.{jpg,png,PNG,JPG} | sort -n -k1.$sortnumber`
	do
		echo "<img class='grid-item grid-item-equal-height' src='$x' align='top'></img>" >> $filenamex
	done;
echo "</div> <!-- PACKERY MASONRY GRID ENDS --><hr>" >> $filenamex
###############################################

######### GRID ELEMENTS WITH EQUAL WIDTH AND DROP SHADOW ######
echo "<h2>3. Grid Elements With Equal Width And Drop Shadow</h2>"  >> $filenamex
echo "<div class='grid'> <!-- PACKERY MASONRY - equal width drop shadow GRID BEGINS -->"  >> $filenamex
for x in `ls *.{jpg,png,PNG,JPG} | sort -n -k1.$sortnumber`
	do
		echo "<img class='grid-item grid-item-drop-shadow' src='$x' align='top'></img>" >> $filenamex
	done;
echo "</div> <!-- PACKERY MASONRY GRID ENDS --><hr>" >> $filenamex
###############################################

echo "</body></html>" >> $filenamex

#Open the newly created file in browser
echo "DONE! File will now be opened in SAFARI."
open -a Safari $filenamex
