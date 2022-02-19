#/bin/bash
##
echo ">>>> BEGIN: RSYNC ... <<<<" ; 
figlet -t -f cybermedium "Enter password" | lolcat ;
rsync -azq --delete $REPO_MGGK/static/wp-content/ $DREAMHOST_USER_MGGK@$DREAMHOST_SERVER:/home/$DREAMHOST_USER_MGGK/mygingergarlickitchen.com/wp-content/ ; 
echo ; 
figlet -t -f cybermedium "Enter password again" | lolcat ;
rsync -azq --delete $REPO_CDN/$CDN_MGGK_IMAGES/ $DREAMHOST_USER_MGGK@$DREAMHOST_SERVER:/home/$DREAMHOST_USER_MGGK/$CDN_MGGK_IMAGES/ ; 
echo ">>>> END: RSYNC ... <<<<" ; 
figlet -t "Image upload done." ; 
