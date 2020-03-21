#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
##################################################
## THIS PROGRAM MAKES AN INDEX HTML PAGE WITH ALL THE IMAGES
## IN THE PRESENT WORKIND DIRECTORY
## DATE: Friday August 01, 2019
## By: Pali
##################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


PWD=`pwd` ;
cd $PWD ;
echo "Present working directory: $PWD" ;
##################################################

DIRNAME=$(basename $PWD) ;

x="index-of-all-photos-$DIRNAME.html" ;
touch $x
rm $x

TOTAL_IMAGES=`ls *.*g | wc -l | sed 's/ //g'` ;

echo "<!DOCTYPE html>
<html>
<head>
<style>
html, body {
  height: 100%;
}

img.one {
  height: auto;
  width: auto;
}

img.two {
  height: 100%;
  width: 100%;
}
</style>

</head>" >> $x

## THE USE OF oncontextmenu=\"return false;\" BELOW WILL DISABLE RIGHT-CLICKS ON WEBPAGE

echo "<body bgcolor=white oncontextmenu=\"return false;\"><center>" >> $x
echo "<h2 style='color: rgb(240,240,240) '; >DIRECTORY: $PWD</h2>" >> $x
echo "<font color=blue><h2>TOTAL IMAGES IN THIS FOLDER: $TOTAL_IMAGES</h2></font>" >> $x

echo "<p>(Images are sized as 100% of window-width // Clicks disabled on webpage)</p>" >>  $x

echo "<hr>" >> $x
echo "<h1 style='font-size: 14vw ; line-height: 0.8 '; >$DIRNAME</h1>"  >> $x

###################################################

## Taking all jpg/png
for p in *.*g
do
  # WITH HYPERLINKS
  #echo "<a href=\"$p\"> <img class=\"two\" src=\"$p\" alt=\"$p\"> </a>" >> $x
  # WITHOUT HYPERLINKS
  echo "<img class=\"two\" src=\"$p\" alt=\"$p\">" >> $x
done

## Taking all JPG/PNG
for p in *.*G
do
  # WITH HYPERLINKS
  #echo "<a href=\"$p\"> <img class=\"two\" src=\"$p\" alt=\"$p\"> </a>" >> $x
  # WITHOUT HYPERLINKS
  echo "<img class=\"two\" src=\"$p\" alt=\"$p\">" >> $x
done

###################################################
## OPENING DIRECTORY
echo "Opening directory: $PWD" ;
open $PWD ;
echo "Opening HTML file: $PWD" ;
open $x ;

## IN CASE OF ERRORS
echo ">>>> In case of ERRORS:"
echo ">>>> NOTE: Make sure that the directory name does not have any spaces. If so, then convert spaces to hyphens."
