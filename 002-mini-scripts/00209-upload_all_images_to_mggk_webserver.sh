#/bin/bash
##
## NOTE: Some VARS are taken from env variables
####
WORKDIR="$DIR_Y";
cd $WORKDIR;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo ">> Present working directory: $WORKDIR" ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
##
echo ">>>> BEGIN: RSYNC ... <<<<" ; 
figlet -t -f cybermedium "Enter password" | lolcat ;
#rsync -azq --delete $REPO_MGGK/static/wp-content/ $DREAMHOST_USER_MGGK@$DREAMHOST_SERVER:/home/$DREAMHOST_USER_MGGK/mygingergarlickitchen.com/wp-content/ ; 
rsync -azq $REPO_MGGK/static/wp-content/ $DREAMHOST_USER_MGGK@$DREAMHOST_SERVER:/home/$DREAMHOST_USER_MGGK/mygingergarlickitchen.com/wp-content/ ; 
echo ; 
####
figlet -t -f cybermedium "Enter password again" | lolcat ;
#rsync -azq --delete $REPO_CDN/$CDN_MGGK_IMAGES/ $DREAMHOST_USER_MGGK@$DREAMHOST_SERVER:/home/$DREAMHOST_USER_MGGK/$CDN_MGGK_IMAGES/ ; 
rsync -azq $REPO_CDN/$CDN_MGGK_IMAGES/ $DREAMHOST_USER_MGGK@$DREAMHOST_SERVER:/home/$DREAMHOST_USER_MGGK/$CDN_MGGK_IMAGES/ ; 
echo ">>>> END: RSYNC ... <<<<" ; 
figlet -t "Image upload done." ; 
