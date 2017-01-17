#!bin/bash
##########################################################
## This script convert all the PNG images in the current directory to JPGs,
## and puts them in a separate folder.
## This tool uses ImageMagick (Mogrify / Convert) installed onto the system.
## Mogrify is used for batch operations, while convert is used for one image.
##########################################################

#### Asking for user inputs
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>> ===== <<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo "$USER, a quick question for RESAMPLING and DENSITY CHANGE:"
echo "What is the new resolution you want for this resampling, in PPI/DPI? [ = 72 - 600, default = 300, press ENTER to use defaut ... ]"
read outputPPI
## setting defaults
if [ "$outputPPI" = "" ] ; then
  outputPPI="300" ;
fi
echo "Chosen Output Image DPI/PPI : $outputPPI "

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>> ===== <<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo "What is the new Image Quality you want? [ = 0 - 100, default = 100, press ENTER to use default ...]"
read outputImageQuality
## setting defaults
if [ "$outputImageQuality" = "" ] ; then
  outputImageQuality="100" ;
fi
echo "Chosen Output Image Quality is : $outputImageQuality "

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>> ===== <<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo "What is the new Image WIDTH you want? [ default = 800, press ENTER to use default ...]"
read imageWidth
## setting defaults
if [ "$imageWidth" = "" ] ; then
  imageWidth="800" ;
fi
echo "Chosen WIDTH is : $imageWidth";

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>> ===== <<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo "What is the new Image HEIGHT you want? [ default = 1200, press ENTER to use default ...]"
read imageHeight
## setting defaults
if [ "$imageHeight" = "" ] ; then
  imageHeight="1200" ;
fi
echo "Chosen HEIGHT is : $imageHeight";

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>> ===== <<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo "What is the BORDER COLOR you want [as HEX code]? [ default = #007fff, press ENTER to use default ...]"
read borderColor
## setting defaults
if [ "$borderColor" = "" ] ; then
  borderColor="#007fff" ;
fi
echo "Chosen BORDER COLOR is : $borderColor";

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>> ===== <<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo "What is the BORDER COLOR WIDTH you want [in pixels]? [ default = 10, press ENTER to use default ...]"
read borderColorWidth
## setting defaults
if [ "$borderColorWidth" = "" ] ; then
  borderColorWidth="10" ;
fi
echo "Chosen BORDER COLOR WIDTH is : $borderColorWidth";


#######################################
echo "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-"
## Making all the desired files and folders:
BaseConvertDir="imagemagick_Output-At-Quality-$outputImageQuality";
BaseConvertDirFormat="$BaseConvertDir/1-changed-from-PNGs-to-JPGs";
ResizeDir="$BaseConvertDir/2-just-resized-to-$imageWidth-x-$imageHeight"
ResizeDirForced="$ResizeDir/forced-resized"
BaseConvertDirDensity="$BaseConvertDir/3-notResized-but-DENSITY-changed-to-$outputPPI-dpi-at-Quality-$outputImageQuality"
BaseConvertDirResample="$BaseConvertDir/4-reSized-and-RESAMPLED-to-$outputPPI-ppi-at-Quality-$outputImageQuality"
BorderDir="$BaseConvertDir/5-border-colored-$borderColor"
BorderDirTriple="$BaseConvertDir/6-border-with-fancy-triple-colors"

## Creating logFile
logfile="$BaseConvertDir/_imageMagick-Logfile.txt"
rm $logfile ## if already exists, then remove.
touch $logfile ;

mkdir $BaseConvertDir $BaseConvertDirFormat $ResizeDir $ResizeDirForced $BaseConvertDirDensity $BaseConvertDirResample $BorderDir $BorderDirTriple
echo "+++++++++++++++ Directories and File creation done. Disregard any 'File Exists' errors. ++++++++++++++++++ "

echo "" ## Blank line
echo "ImageMagick Working......................"

##########################################
#### Actual magic begins:
#########################################

## FORMAT CHANGE: This quickly converts all PNGs to JPGs
mogrify -path $BaseConvertDirFormat -quality $outputImageQuality -format jpg *.png
echo "1. DONE. All PNGs converted to JPGs, with quality = $outputImageQuality " >> $logfile

## Resizing to the desired width x height (only to larger dimension of both)
mogrify -path $ResizeDir -resize $imageWidthx$imageHeight *.jpg
mogrify -path $ResizeDir -resize $imageWidthx$imageHeight *.png
echo "2A. DONE. ASPECT RATIO PRESERVED: All Images resized to larger of the two dimensions = $imageWidth-x-$imageHeight " >> $logfile

## Resizing to the desired width x height (forced resize to both given height and width)
mogrify -path $ResizeDirForced -resize $imageWidth\!x$imageHeight\! *.jpg
mogrify -path $ResizeDirForced -resize $imageWidth\!x$imageHeight\! *.png
echo "2B. DONE. NO ASPECT RATIO PRESERVED: All Images FORCE RESIZED to = $imageWidth-x-$imageHeight " >> $logfile

## DENSITY CHANGE ONLY: This changes the density only (dpi), keeping the same size.
mogrify -units PixelsPerInch -density $outputPPI -path $BaseConvertDirDensity -quality $outputImageQuality -format jpg *.jpg ## all jpgs to jpgs
mogrify -units PixelsPerInch -density $outputPPI -path $BaseConvertDirDensity -quality $outputImageQuality -format png *.png ## all pngs to pngs
echo "3. DONE. All Images converted with quality = $outputImageQuality and Density = $outputPPI DPI " >> $logfile

## RESAMPLING: This changes the size of the image by desired resampling.
## Eg, doubling the size from 150dpi to 300dpi. UNCOMMENT THE FOLLOWING 2 LINES TO MAKE IT WORK.
# mogrify -units PixelsPerInch -resample $outputPPI -path $BaseConvertDirResample -quality $outputImageQuality -format jpg *.jpg ## all jpgs to jpgs
# mogrify -units PixelsPerInch -resample $outputPPI -path $BaseConvertDirResample -quality $outputImageQuality -format png *.png ## all pngs to pngs
echo "4. -----> NOT DONE. BCOZ CODE COMMENTED // All Images Resampled with quality = $outputImageQuality and Resampled at = $outputPPI PPI " >> $logfile

## BORDER-COLOR APPLYING
mogrify -path $BorderDir -border "$borderColorWidth"x"$borderColorWidth" -bordercolor "$borderColor " *jpg ## all jpgs
mogrify -path $BorderDir -border "$borderColorWidth"x"$borderColorWidth" -bordercolor "$borderColor " *png ## all pngs
echo "5. DONE. All Images have been applied $borderColorWidth x $borderColorWidth BORDER with COLOR = $borderColor " >> $logfile

## TRIPLE FANCY BORDER-COLOR APPLYING - ONLY JPGs ARE TAKEN FOR THIS FOR EASE.
## JPGs
mogrify -path $BorderDirTriple -border 5x5 -bordercolor "#444444 " *jpg ## all jpgs
mogrify -path $BorderDirTriple -border 70x70 -bordercolor "#FFFFFF " $BorderDirTriple/*jpg ## all jpgs
mogrify -path $BorderDirTriple -border 25x25 -bordercolor "#000000 " $BorderDirTriple/*jpg ## all jpgs
mogrify -path $BorderDirTriple -border 5x5 -bordercolor "#444444 " $BorderDirTriple/*jpg ## all jpgs
echo "6A. DONE. All JPGs have been applied TRIPLE FANCY BORDERS with shades of BLACKS AND WHITE. " >> $logfile
## PNGs
mogrify -path $BorderDirTriple -border 5x5 -bordercolor "#444444 " *png ## all jpgs
mogrify -path $BorderDirTriple -border 70x70 -bordercolor "#FFFFFF " $BorderDirTriple/*png ## all PNGs
mogrify -path $BorderDirTriple -border 25x25 -bordercolor "#000000 " $BorderDirTriple/*png ## all PNGs
mogrify -path $BorderDirTriple -border 5x5 -bordercolor "#444444 " $BorderDirTriple/*png ## all PNGs
echo "6B. DONE. All PNGs have been applied TRIPLE FANCY BORDERS with shades of BLACKS AND WHITE. " >> $logfile


#############################################
echo "...........................All Done!"
open $BaseConvertDir ## Opening output directory.
