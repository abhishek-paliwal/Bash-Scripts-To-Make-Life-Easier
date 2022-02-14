#/bin/bash

myfunc () { 
    output_dir="$(pwd)/_tmp_imagemagick_outputs" ; 
    dir_w="$output_dir/width_fixed/" ; 
    dir_h="$output_dir/height_fixed/" ; 
     mkdir -p  $dir_w $dir_h ; 
     echo "Enter desired image WIDTH or HEIGHT in px:" ; 
     read imageWidth ; 
     echo "(... Resizing images to $imageWidth px ... wait ...)" ; 
     mogrify -path $dir_w/ -resize ${imageWidth}x -quality 95 -format jpg *.*g ; 
     mogrify -path $dir_h/ -resize x${imageWidth} -quality 95 -format jpg *.*g ; 
} ; 
##     
myfunc ; 
##
for SUBDIR in $(fd . -t d); do; 
    echo; 
    echo "  THIS DIR >> $SUBDIR";
    identify -format "%wx%h\n" $SUBDIR/*.* ; 
done