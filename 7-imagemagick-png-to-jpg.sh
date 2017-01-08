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


#######################################
echo "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-"
## Making all the desired files and folders:
BaseConvertDir="imagemagick_Output-At-Quality-$outputImageQuality";
BaseConvertDirFormat="$BaseConvertDir/1-changed-from-PNGs-to-JPGs";
ResizeDir="$BaseConvertDir/2-just-resized-to-$imageWidth-x-$imageHeight"
BaseConvertDirDensity="$BaseConvertDir/3-notResized-but-DENSITY-changed-to-$outputPPI-dpi-at-Quality-$outputImageQuality"
BaseConvertDirResample="$BaseConvertDir/4-reSized-and-RESAMPLED-to-$outputPPI-ppi-at-Quality-$outputImageQuality"
BorderDir="$BaseConvertDir/5-border-colored-$borderColor"

## Creating logFile
logfile="$BaseConvertDir/_imageMagick-Logfile.txt"
rm $logfile ## if already exists, then remove.
touch $logfile ;

mkdir $BaseConvertDir $BaseConvertDirFormat $ResizeDir $BaseConvertDirDensity $BaseConvertDirResample $BorderDir
echo "+++++++++++++++ Directories and File creation done. Disregard any 'File Exists' errors. ++++++++++++++++++ "

echo "" ## Blank line
echo "ImageMagick Working......................"

##########################################
#### Actual magic begins:
#########################################

## FORMAT CHANGE: This quickly converts all PNGs to JPGs
mogrify -path $BaseConvertDirFormat -quality $outputImageQuality -format jpg *.png
echo "1. All PNGs converted to JPGs, with quality = $outputImageQuality " >> $logfile

## Resizing to the desired width x height
mogrify -path $ResizeDir -resize $imageWidthx$imageHeight *.jpg
mogrify -path $ResizeDir -resize $imageWidthx$imageHeight *.png
echo "2. All Images resized to = $imageWidth-x-$imageHeight " >> $logfile

## DENSITY CHANGE ONLY: This changes the density only (dpi), keeping the same size.
mogrify -units PixelsPerInch -density $outputPPI -path $BaseConvertDirDensity -quality $outputImageQuality -format jpg *.jpg ## all jpgs to jpgs
mogrify -units PixelsPerInch -density $outputPPI -path $BaseConvertDirDensity -quality $outputImageQuality -format png *.png ## all pngs to pngs
echo "3. All Images converted with quality = $outputImageQuality and Density = $outputPPI DPI " >> $logfile

## RESAMPLING: This changes the size of the image by desired resampling.
## Eg, doubling the size from 150dpi to 300dpi
mogrify -units PixelsPerInch -resample $outputPPI -path $BaseConvertDirResample -quality $outputImageQuality -format jpg *.jpg ## all jpgs to jpgs
mogrify -units PixelsPerInch -resample $outputPPI -path $BaseConvertDirResample -quality $outputImageQuality -format png *.png ## all pngs to pngs
echo "4. All Images Resampled with quality = $outputImageQuality and Resampled at = $outputPPI PPI " >> $logfile

## BORDER-COLOR APPLYING
mogrify -path $BorderDir -border 10x10 -bordercolor "$borderColor " *jpg ## all jpgs
mogrify -path $BorderDir -border 10x10 -bordercolor "$borderColor " *png ## all pngs
echo "5. All Images have been applied 10x10 BORDER with COLOR = $borderColor " >> $logfile

#############################################
echo "...........................All Done!"
open $BaseConvertDir ## Opening output directory.
