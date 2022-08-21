#/bin/bash

myfunc () { 
    echo "[VIDEO DOWNLOAD] Enter youtube/facebook video URL or ID:" ; 
    read videoURL ; 
    yt-dlp --merge-output-format mp4 $videoURL 
} ; 
    
myfunc