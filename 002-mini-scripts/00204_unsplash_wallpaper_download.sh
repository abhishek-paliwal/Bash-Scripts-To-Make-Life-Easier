#/bin/bash

cd $HOME_WINDOWS/Dropbox/WALLPAPERS-DROPBOX/unsplash_wallpapers/ ; 

myfunc () { 
    myurl="https://source.unsplash.com/featured/1920x1080/?" ; wget -O "$(date +%Y%m%d_%H%M%S)-$1.jpg" "$myurl$1" ; 
} ; 

myfunc $1 ;