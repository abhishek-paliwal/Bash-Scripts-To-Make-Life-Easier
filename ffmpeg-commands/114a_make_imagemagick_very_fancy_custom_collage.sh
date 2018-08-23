#!/bin/bash
######################################
## THIS PROGRAM MAKES A COLLAGE BY MAKING ROWS OF SUBCOLLAGES ...
## USING IMAGES PRESENT IN A FOLDER
######################################
width="1920" ;
height="1080";
padding="0" ;
collagebackground="white" ;
subcollagebackground="black" ;
collage_title="THIS IS THE TITLE THAT I WANT ( $width x $height )" ;

## COLLAGE FORMAT STRING
string="20:6x1+100
40:1x1+50:2x2+50
20:2x1+33:1x1+33:1x1+34
20:1x1+50:2x2+50";

#string="100:8x5+100" ;

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


            ls -1 *.*g | head -$num_images > $TMP_FILELIST ;
            ls -1 *.*g | head -$num_images ; ## Printing to Command prompt

            echo "=======> Creating subcollage..." ;
            sep="x";
                  montage @$TMP_FILELIST -mode concatenate -tile $subitem1 -geometry $subitem_width_in_px$sep$subitem_height_in_px+$padding+$padding -background $subcollagebackground -gravity center subcollage-$lineNumber-$index-$subitem1.jpg ;

            echo ; echo "Collage command used:" ;
            echo "montage @$TMP_FILELIST -mode concatenate -tile $subitem1 -geometry $subitem_width_in_px$sep$subitem_height_in_px+$padding+$padding -background $subcollagebackground -gravity center subcollage-$lineNumber-$index-$subitem1.jpg ;" ;
            echo ;

            ## FINALLY MOVING ALL FILES WHICH HAVE BEEN USED SO FAR
            mv `ls *.*g | head -$num_images` ./_done_processing/ ;
        fi

    done

    ## Creating Sub-collage for each row
    montage subcollage-$lineNumber-* -geometry +$padding+0 -background $collagebackground -gravity center collage-$lineNumber.jpg
    sleep 3 ; ## Pause for 1 seconds

    ## Printing index with values
    for index in "${!array[@]}" ;
    do echo "Index : Value = $index : ${array[index]}" ; echo "${!array[@]}" ; done

    echo "=========================================" ; echo ;

done < "$filename"

## Creating Final Collage using all the subcollages
montage collage-* -title "$collage_title" -tile 1x$lineNumber -geometry +$padding+$padding -background $collagebackground -gravity center _FINAL_COLLAGE.jpg

## IN CASE OF ERRORS
echo "IN CASE OF ERRORS, CHECK THESE: " ;
echo "1. All original filenames should be in lowercase, including extensions." ;
echo "2. Make sure that the collage format has been entered in the right notation, with no spaces anywhere." ;
echo "3. Also, see to it that the number of images are more than or equal to the total images used in the collage." ;


## OPENING FINAL DIRECTORY
open $PWD ;
