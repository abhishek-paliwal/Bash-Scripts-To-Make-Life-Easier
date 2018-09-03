#!/bin/bash
######################################
## THIS PROGRAM MAKES A COLLAGE BY MAKING ROWS OF SUBCOLLAGES ...
## USING IMAGES PRESENT IN A FOLDER
######################################
padding="5" ;
collagebackground="white" ;
subcollagebackground="white" ;

## COLLAGE FORMAT STRING (edit as needed)
string="50:3x3+50:3x3+50
50:3x3+50:3x3+50" ;

## ASSIGNS AND CHECKS FOR COLLAGE FORMAT TEXT FILE
collageformat_file="_collageformat.txt" ;

if [ -e "$collageformat_file" ]; then
    echo "===> File exists : $collageformat_file " ;
    string=`cat $collageformat_file | sed '/^$/d' ` ;
else
    echo "===> File does not exist : $collageformat_file" ;
    echo "NO COLLAGE FORMAT FILE FOUND. THUS, DEFAULT COLLAGE FORMAT WILL BE USED. THIS ==> $string " ;
fi


#######################################

echo "Enter the WIDTH in pixels for the collage: " ;
read width ;

echo "Enter the HEIGHT in pixels for the collage: " ;
read height ;

echo "Enter the TITLE for the collage: " ;
read title ;

## CHECKING IF VALUSES ARE ENTERED OR NOT
if [ -z "$width" ] && [ -z "$height" ] && [ -z "$title" ]
    then
    echo "No values supplied. So default values will be used." ;
    width="4000" ;
    height="3000" ;
    title="MY COLLAGE" ;
    echo "THE DEFAULT VALUES CHOSEN ARE: $width // $height // $title " ;
fi

## CREATING FINAL COLLAGE TITLE
collage_title="$title ($width x $height px)" ;

########################################
########################################

PWD=`pwd`;
cd $PWD ;
echo "Present working directory: $PWD" ;

TMP_FOLDER="_delete_this_folder_" ;

echo "Removing $TMP_FOLDER ... if exists ..." ;
rm -rf $TMP_FOLDER ;  ## remove if already exists
mkdir $TMP_FOLDER ;


## COPYTING ALL IMAGE FILES (jpg/png) TO TMP DIRECTORY
cp *.*g $TMP_FOLDER/ ;
cd $TMP_FOLDER ;
mkdir _done_processing ;

########################################

echo "Collage_Width_in_px=$width" ;
echo "Collage_Height_in_px=$height" ;
echo "Collage Format String:$string" ;

filename="_TMP.TXT" ;
echo "$string" > $filename ;

## READING FROM COLLAGE FORMAT FILE
let total_images=0;
let lineNumber=0 ;

while read -r line
do

    ((lineNumber++)) ;
    echo ; echo "Line read from file - $line" ;
    echo "Line Number: $lineNumber" ;

    IFS=':' read -r -a array <<< "$line" ;
    echo "First element: ${array[0]}" ;
    echo "Array Length: ${#array[@]}" ;

    row_height_in_px=`echo "${array[0]}*$height/100" | bc` ;
    echo "Row_height_in_px: $row_height_in_px" ;

    ########################################

    for index in "${!array[@]}" ;
    do
        item=${array[index]} ;
        echo "Array_Item: $item at Index: $index" ;
        subitem1=`echo $item | cut -f1 -d'+' ` ;
        subitem2=`echo $item | cut -f2 -d'+' ` ;

        ## Only work if it finds the 'x' character in the tile dimension
        if [[ $subitem1 = *"x"* ]]; then

            tile_columns=`echo $subitem1 | cut -f1 -d'x' ` ;
            tile_rows=`echo $subitem1 | cut -f2 -d'x' ` ;

            num_images=`echo "$tile_columns*$tile_rows" | bc` ;
            echo ;
            echo "  num_images = $num_images" ;
            echo "  tile_columns x tile_rows = $tile_columns x $tile_rows" ;

            subitem_width_in_px=`echo "($subitem2*$width/(100*$tile_columns))-$padding*2" | bc` ;
            subitem_height_in_px=`echo "($row_height_in_px/($tile_rows))-$padding*2" | bc` ;

            echo "  subitem1=$subitem1" ;
            echo "  subitem2=$subitem2" ;
            echo "  subitem_width_in_px=$subitem_width_in_px" ;
            echo "  subitem_height_in_px=$subitem_height_in_px" ;

            echo "It's a valid TILE dimension. Hence, a collage will be made."
            ## CREATING SUB_COLLAGE
            TMP_FILELIST="_TMP_IMAGE_LIST.TXT" ;
            touch $TMP_FILELIST ; rm $TMP_FILELIST ;

            #padding_left=`echo "$padding/$tile_rows" | bc` ;
            #padding_right=`echo "$padding/$tile_columns" | bc` ;


            ls -1 *.*g | head -$num_images ; ## Printing to Command prompt
            ls -1 *.*g | head -$num_images > $TMP_FILELIST ;

        ## Executing the Resize and Crop script
        sh $HOME/GitHub/Bash-Scripts-To-Make-Life-Easier/ffmpeg-commands/116_imagemagick_crop_images_to_any_custom_dimensions.sh $subitem_width_in_px $subitem_height_in_px $TMP_FILELIST

            echo "=======> Creating subcollage..." ;
            sep="x";
                  pwd ;
                  montage @0_$TMP_FILELIST -mode concatenate -tile $subitem1 -geometry $subitem_width_in_px$sep$subitem_height_in_px+$padding+$padding -background $subcollagebackground -gravity center zz_subcollage-$lineNumber-$index-$subitem1.jpg ;

            echo ; echo "Collage command used:" ;
            echo "montage @$TMP_FILELIST -mode concatenate -tile $subitem1 -geometry $subitem_width_in_px$sep$subitem_height_in_px+$padding+$padding -background $subcollagebackground -gravity center zz_subcollage-$lineNumber-$index-$subitem1.jpg ;" ;
            echo ;

            ## FINALLY MOVING ALL FILES WHICH HAVE BEEN USED SO FAR
            mv `ls *.*g | head -$num_images` ./_done_processing/ ;

            total_images=`echo "$total_images+$num_images" | bc`  ;
            echo "PRESENT NUMBER OF TOTAL IMAGES: $total_images" ;
        fi

    done

    ## Creating Sub-collage for each row
    montage zz_subcollage-$lineNumber-* -geometry +$padding+0 -background $collagebackground -gravity center zz_collage-$lineNumber.jpg
    sleep 3 ; ## Pause for 1 seconds

    ## Printing index with values
    for index in "${!array[@]}" ;
    do echo "Index : Value = $index : ${array[index]}" ; echo "${!array[@]}" ; done

    echo "=========================================" ; echo ;

done < "$filename"

## Creating Final Collage using all the subcollages
ECHO "========> Creating Final Collage using all the subcollages <======== " ;
montage zz_collage-* -title "$collage_title [ $total_images images ]" -tile 1x$lineNumber -geometry +$padding+$padding -background $collagebackground -gravity center _FINAL_COLLAGE.jpg

## IN CASE OF ERRORS
echo ;
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;
echo "IN CASE OF ERRORS, CHECK THESE: " ;
echo "1. All original filenames should be in lowercase, including extensions." ;
echo "2. Make sure that the collage format has been entered in the right notation, with no spaces anywhere." ;
echo "3. Also, see to it that the number of images are more than or equal to the total images used in the collage." ;
echo "4. Make sure that the images names do not start with 'z' character, such as zoo-1.jpg, etc. " ;

## OPENING FINAL DIRECTORY
open $PWD ;
