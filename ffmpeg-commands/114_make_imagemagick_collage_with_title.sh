#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
      ########################################################################################
      # THIS PROGRAM USES IMAGEMAGICK TO CREATE A TITLE AFTER READING INPUTS FROM COMMAND LINE
      # THEN, CREATES A COLALGE USING ALL THE IMAGES IN THE FOLDER
      # CREATED BY: PALI
      # CREATED ON: Thursday August 2, 2018
      ########################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


PWD=`pwd`;
echo "Current parent directory: $PWD" ;

## CREATING TMP DIRECTORY TO DO ALL MAGIC, AND TO SAVE ORIGINAL FILES AS SUCH
mkdir _TMP_COLLAGE_DIR;
cp *.* _TMP_COLLAGE_DIR/ ;
cd _TMP_COLLAGE_DIR ;

NEW_PWD=`pwd` ;
echo "CURRENT COLLAGE WORKING DIRECTORY: $NEW_PWD" ;

echo ; echo "CURRENT FILES IN DIRECTORY: "
ls -1 *.*g | nl ## chooses all the png/jpg images

## PRINTING ALL IMAGES DIMENSIONS OF FINAL FILE
echo; echo "Printing all image sizes (sorted from small to big):";
identify -format "%wx%h : %f\n" *.* | sort -r | nl ;

## NOW PRINTING THE DIMENSIONS OF ALL IMAGES WITH HOW MANY IMAGES THEY CORRESPOND
echo; echo "Now printing the dimensions of all images with how many images they correspond to: ";
identify -format "%wx%h\n" *.* | sort -nr > _TMP_LIST.TXT ;
cat _TMP_LIST.TXT | sort -n | uniq -c | sort -k2nr ;

## NOW PRINTING IMAGE WIDTH TO HEIGHT RATIOS FOR ALL IMAGES
echo; echo "Now Printing Image Width:Height Ratios For All Images (jpg, png, JPG, PNG): [... wait a couple of seconds, it takes a while to calculate ratios ...]";
find . -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.JPG -o -iname \*.PNG \) -exec magick "{}" -format "%[fx:w/h]\n" info: \; | sort -n | awk '{printf "%.2f\n",$1}' | uniq -c | sort -nr

########################################################

NEW_LINE_VAR="\\\\\\\\n" ; ## THIS WILL PRINT OUT \\n
echo; echo "USE THIS FOR NEW LINES: $NEW_LINE_VAR" ;

echo "ENTER THE TITLE OF THE COLLAGE [ use $NEW_LINE_VAR for new-lines ] [NOTE: KEEP IT EMPTY IF YOU DON'T WANT ANY TITLE SLIDE] : " ;
echo ;
read collage_title ;

echo "ENTER THE DIMENSIONS OF THE TITLE AND EACH IMAGE IN COLLAGE AS WxH [eg., 1920x1080] [OR leave empty for automatic calculations]: " ;
echo ;
read collage_dimensions ;

echo "ENTER THE TILE VALUE AS ROWSxCOLUMNS [eg., 4x5] [OR leave empty for automatic choice]: " ;
echo ;
read tile_value ;

echo "ENTER THE PADDING VALUE IN PIXELS [eg., 5] [OR leave empty for automatic choice]: " ;
echo ;
read padding_pixels ;

echo "ENTER THE BACKGROUND COLOR NAME OR HEX-CODE [eg., pink, #3498db] [OR leave empty for automatic choice]: " ;
echo ;
read background_color ;


########################################################
total_num_images=`cat _TMP_LIST.TXT | wc -l | sed 's/ //g' ` ;
echo "======> TOTAL NUMBER OF IMAGES: $total_num_images " ;

## FOLLOWING ARE THE CALCUATIONS DONE FOR 15 MEGAPIXEL COLLAGE = 5000x3125 (change if you want to)
height_auto=`echo "scale=0; sqrt(5000*3125/$total_num_images/1.5)" | bc -l ` ;
width_auto=`echo "scale=0; $height_auto*3/2" | bc -l ` ;
sep="x" ;

echo "Automatic dimensions have been calculated for TOTAL IMAGES: $total_num_images" ;
echo "Automatic dimensions : $width_auto$sep$height_auto" ;

########################################################
## CHECKING IF $collage_dimensions WAS ENTERED OR NOT
if [ -z "$collage_dimensions" ]
then
      echo "\$collage_dimensions is empty. Thus, COLLAGE_DIMENSIONS will be calculated automatically." ;
      collage_dimensions="$width_auto$sep$height_auto" ;
      echo "collage_dimensions: $collage_dimensions" ;
else
      echo "\$collage_dimensions is NOT empty. COLLAGE_DIMENSIONS will be made using tile value = $tile_value " ;
      montage *.*g -tile $tile_value -geometry $collage_dimensions+5+5 0_my_collage.jpg ;
fi
########################################################

echo ;
echo "collage_title: $collage_title" ;
echo "collage_dimensions: $collage_dimensions" ;
echo "tile_value: $tile_value" ;
echo "padding_pixels: $padding_pixels" ;
echo ;

################################################################

## Now generating random HEX colors for title
random_color_background=`echo "#$(openssl rand -hex 3)"` ;
random_color_text=`echo "#$(openssl rand -hex 3)"`  ;

echo "Chosen random_color_background=$random_color_background" ;
echo "Chosen random_color_text=$random_color_text" ;


## Checking if files exists, and removing if exists:
touch 0_my_collage*
rm 0_my_collage*

## STEP 1A: MAKING TITLE IF TITLE VARIABLE TEXT IS NOT EMPTY.
if [ -z "$collage_title" ]
then
      echo "\$collage_title is empty." ;
else
      echo "\$collage_title is NOT empty.";
      convert -background "$random_color_background" -fill "$random_color_text" -font /Users/abhishek/Library/Fonts/BebasNeue\ Book.ttf -size "$collage_dimensions" -gravity east label:"$collage_title" 0_my_collage_title.jpg ;
fi


## STEP 1B: CHECKING IF PADDING_PIXELS VARIABLE TEXT IS NOT EMPTY.
if [ -z "$padding_pixels" ]
then
      echo "\$padding_pixels is empty." ;
      padding_pixels="5" ;
else
      echo "\$padding_pixels is NOT empty. Provided value will be used.";
fi


## STEP 2: Using IMAGEMAGICK to resize ALL images to Full-HD with padding to keep FULL-HD aspect ratio
echo "=======> ImageMagick currently resizing all images to $collage_dimensions ...."
mogrify -resize $collage_dimensions -background black -gravity center -extent $collage_dimensions *
echo "=======> ImageMagick resizing done ...."

## STEP 3A: CHECKING IF BACKGROUND_COLOR VARIABLE IS NOT EMPTY.
if [ -z "$background_color" ]
then
      echo "\$background_color is empty." ;
      background_color="white" ;
else
      echo "\$background_color is NOT empty. Provided value will be used.";
fi

## STEP 3B: MAKING COLLAGE USING ALL IMAGES IN PWD (ALSO CHECKS IF TILE VAR IS EMPTY)
echo ; echo "Now creating collage ....." ;

if [ -z "$tile_value" ]
then
      echo "\$tile_value is empty. Collage will be made automatically." ;
      montage *.*g -background $background_color -geometry $collage_dimensions+$padding_pixels+$padding_pixels 0_my_collage.jpg ;
else
      echo "\$tile_value is NOT empty. Collage will be made using tile value = $tile_value " ;
      montage *.*g -background $background_color -tile $tile_value -geometry $collage_dimensions+$padding_pixels+$padding_pixels 0_my_collage.jpg ;
fi

#######################################################################################
## RENAMING COLLAGE FILE BASED UPON title
FINAL_FILENAME=`echo "$collage_title-collage" | sed 's/\\\\n/-/g' | sed 's/ /-/g'` ;
cp 0_my_collage.jpg $FINAL_FILENAME.jpg ;

## PRINTING ALL IMAGES DIMENSIONS OF FINAL FILE
echo; echo "==========> DIMENSIONS OF THE PRODUCED COLLAGE: ";
identify -format "%wx%h : %f\n" $FINAL_FILENAME.jpg ;

echo; echo "Collage has been made. Now opening working directory"; echo ;
open .

########################################################################################
