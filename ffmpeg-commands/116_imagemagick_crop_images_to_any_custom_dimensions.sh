#/bin/bash
#########################################
## THIS PROGRAM RESIZES THEN CROPS IMAGES ...
## FROM THE SUPPLIED COMMAND LINE ARGUMENTS AS $1 $2 $3, where $3 is optional
## USING IMAGES PRESENT IN A FOLDER
## NAME: 116_imagemagick_crop_images_to_any_custom_dimensions.sh
## CODED BY: Pali
## DATE: Friday August 24, 2018
##########################################
echo ; echo "USAGE (uses 3 arguments, 3rd is optional): sh program.sh \$1 \$2 \$3" ;
echo "\$1 is width in PX // \$2 is height in PX. // \$3 is Image-File-List.txt (optinal) ";
echo ;
###########################################

## CHECKING IF ARGUMENTS ARE PROVIDED OR NOT
if [ -z $1 ]
    then
    echo "No argument supplied. Check settings and Re-run with proper arguments." ;
    echo "THE SCRIPT WILL EXIT NOW. " ;
    exit ;
fi

## DEFINING VARIABLES AND VALUES
w="$1" ;
h="$2" ;
TMP_FILE="$3" ;
sep="x" ;
gravity="center" ;
##########################################

##########################################
PWD=`pwd`;
cd $PWD;
echo "Present working directory: $PWD " ;

TMP_DIR="_delete_this_crop_folder" ;
mkdir $TMP_DIR ;

## Moving text file from parent directory to this directory, so that it can be used here
echo "Moving $3 --> $TMP_DIR/ " ;
mv $3 ./$TMP_DIR/ ;

## Copying all valid image files to tmp directory (png/jpg)
cp `ls -1 *.*g` $TMP_DIR/ ;
echo "All image files have been copied from $PWD -> $TMP_DIR" ;

cd $TMP_DIR ;
echo ; echo "=========> Present workind directory: $TMP_DIR " ;


## PRINTING VARIABLE VALUES TO THE PROMPT
echo "INPUT WIDTH (px): $w // INPUT HEIGHT (px): $h // TMP_FILE: $TMP_FILE " ;
echo ;

## REMOVE ANY EXISTING RESIZED OR CROPPED IMAGES
rm z0_resized_* z1_cropped_*
echo "Removed existing resized and cropped files... " ;
echo "Now waiting for 2 seconds so that all the temporary files get deleted ...." ;
echo ;
sleep 2;

## THEN, MAKING A FILE LIST TO BE USED FOR RESIZING AND CROPPING
## First, checks if no filename is supplied on CLI
if [ -z $3 ]
    then
    echo "No IMAGE-FILE-LIST supplied. Thus, an automatic file-list will be created from all the images" ;
    TMP_FILE="file.txt" ;
    ls -1 *.*g > $TMP_FILE ;
    echo "TMP_FILE (autocreated by program): $TMP_FILE " ;
fi

pwd;
echo "List of images to consider: " ;
cat $TMP_FILE ;

## FIRST RESIZING, THEN CROPPING IMAGES
echo "CURRENTLY RESIZING IMAGES ... " ;
convert @$TMP_FILE -resize $w$sep$h^+0+0 z0_resized_%03d.png ;
echo "NOW CROPPING IMAGES ... " ;
convert z0_resized_* -gravity $gravity -crop $w$sep$h+0+0 +repage z1_cropped_%03d.png ;

## Now saving the filelist thus produced to a text file
ls -d -1 $PWD/z1_cropped_* > "0_$TMP_FILE" ;

echo "Saved the cropped file list thus produced to a text file : 0_$TMP_FILE " ;
mv 0_$TMP_FILE ../ ;

## OPENING directory
open $PWD ;
