#/bin/bash
## THIS PROGRAM FINDS IMAGES IN INDEX XML CAUSING ERROR ON PINTEREST WEBSITE

WORKDIR="$DIR_Y";
TMPFILE1="$WORKDIR/_tmpfile1_pinterest.xml" ;
TMPFILE2="$WORKDIR/_tmpfile2_pinterest.txt" ;
TMPFILE3="$WORKDIR/_tmpfile3_pinterest.html" ;

## Downloading index.xml locally
echo ">> Downloading index.xml locally into $WORKDIR" ; 
curl -k https://www.mygingergarlickitchen.com/index.xml > $TMPFILE1 ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 

## Getting all jpg image urls
echo ">> Getting all jpg URLs ..." ; 
cat $TMPFILE1 | grep -irhEo 'src="https:.*jpg' | sd 'src="' '' > $TMPFILE2 ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 

################################################################################
## Finding cache status of all images whether they are on cloudflare or not
## And saving all found images to an HTML file
dateVar="$(date)" ; 
echo "<p>Page created: $dateVar</p>" > $TMPFILE3 ; 
echo "<h1>All images found in current MGGK index.xml file</h1>" >> $TMPFILE3 ; 
echo "<h3 style='color : red;'>CHECKING PINTEREST XML IMAGE ERROR: <br>Find images which are not displaying below. Those might be potential error-producing images in pinterest.</h3><hr>" >> $TMPFILE3 ; 
####
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
echo ">> Finding cache status of all images whether they are on cloudflare or not" ; 
echo ">> IMPORTANT NOTE: IF cache-status equals HIT, then the image is present on cloudflare servers. Else, it's not." ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
## Reading list of images, line by line
for x in $(cat $TMPFILE2) ; do
    echo "##------------------------------------------------------------------------------" ; 
    echo ">> CURRENT IMAGE URL: $x" ; 
    curl -skI $x | grep -i 'CF-Cache-Status' ; 
    echo "<div style='display: inline-block; width: 300px; border: 2px solid grey; padding: 5px; '><img width='100%' src='$x'>$x</img></div>" >> $TMPFILE3 ; 
    echo "##------------------------------------------------------------------------------" ; 
done
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
################################################################################

## Display final steps
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo ">> FINAL STEP : Open this file to check which images are causing PINTEREST error. => $TMPFILE3" ;  
open $TMPFILE3 ;  # only works in MAC OS 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 

