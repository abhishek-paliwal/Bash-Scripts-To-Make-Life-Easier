#/bin/bash

myfunc () { 
    echo "[AUDIO DOWNLOAD] Enter youtube/facebook video URL or ID:" ; 
    read videoURL ; 
    yt-dlp -x --audio-format mp3 $videoURL
} ; 

myfunc