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
figlet -f cybermedium "Enter password" | lolcat ;
rsync -azq $REPO_MGGK/static/wp-content/ $DREAMHOST_USER_MGGK@$DREAMHOST_SERVER:/home/$DREAMHOST_USER_MGGK/mygingergarlickitchen.com/wp-content/ ; 
echo ; 
####
figlet -f cybermedium "Enter password again (for cdn)" | lolcat ;
CDN_DIR_MGGK="cdn.mygingergarlickitchen.com" ; 
#rsync -azq --delete $REPO_CDN/$CDN_DIR/ $DREAMHOST_USER_MGGK@$DREAMHOST_SERVER:/home/$DREAMHOST_USER_MGGK/$CDN_DIR/ ; 
rsync -azq $REPO_CDN/$CDN_DIR_MGGK/ $DREAMHOST_USER_MGGK@$DREAMHOST_SERVER:/home/$DREAMHOST_USER_MGGK/$CDN_DIR_MGGK/ ; 
echo ">>>> END: RSYNC ... <<<<" ; 
figlet "Image upload done." ; 
