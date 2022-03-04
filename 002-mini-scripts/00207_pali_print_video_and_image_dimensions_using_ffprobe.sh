#/bin/bash

echo ">> Printing dimensions of videos (mp4/mkv/webm) and photos (jpg/png/jpeg) in current directory ..." ; 
echo; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
for x in $(fd -I -t f -e jpg -e png -e jpeg -e mp4 -e mkv -e webm) ; do myvar=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 $x) ; echo "$myvar <== $x" ; done | sort -n 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
