#/bin/bash

for x in $(find . -type f) ; do myvar=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 $x) ; echo "$myvar <== $x" ; done | sort -n