#/bin/bash

cd $DIR_Y ; 

echo ">> Following mp4/mkv/mov files will be used: " ; 
fd -e mp4 -e mkv -e mov --full-path $DIR_Y ; 

for myvideo in $(fd -e mp4 -e mkv -e mov --full-path $DIR_Y) ; do 
    videoExtn=${myvideo##*.} ; 
    myvideoNew=$(basename "$myvideo" | sed "s+\.+_+g" ) ; 
    echo ">> CURRENT VIDEO: $myvideoNew" ; 
    ffmpeg -i $myvideo -c copy -map 0 -segment_time 00:00:55 -f segment -reset_timestamps 1 $myvideoNew-output%03d.$videoExtn ; 
done