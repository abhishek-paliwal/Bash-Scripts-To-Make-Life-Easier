#!bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ##############################################################################
    ONLY RUN THIS SCRIPT TO MAKE ALL BACKUPS ON LINUX OR MAC.
    ##############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


##############################################################################
############ EXPANDING ALIASES ON NON-INTERATIVE SHELL SCRIPTS ###############
## For Running system commands (as Aliases from .bash_profile)
shopt -s expand_aliases ## for BASH: This has to be done, else, aliases are not expanded in scripts.

## IF THE HOME USER IS UBUNTU, CHANGE SOME DEFAULT VARIABLES (BCOZ WE ARE USING WSL)
if [ "$USER"=="ubuntu" ] ; then 
    source $HOME/.profile ## Then, this also has to be done to use aliases in this script.
else 
    source $HOME/.bash_profile ## Then, this also has to be done to use aliases in this script.
fi 

source $HOME/.bash_aliases ## Then, this also has to be done to use aliases in this script.

##############################################################################
##############################################################################

####### only run this bash script to make ALL the indexes and backups on PALI's Macbook #########
BASEPATH="$HOME/GitHub/Bash-Scripts-To-Make-Life-Easier";

#### BACKUPS of our MACs ####
echo "creating backup of MACFILES + Important DOTFILES in Onedrive......"
bash $BASEPATH/5-abhishek_create_MACFILES_backup.sh


########## KEEP THIS BLOCK AT THE END TO BACKUP ALL FILES TO SERVERS ############
########## ONLY RUN THE SSH SCP BACKUP BLOCK WHEN $USER = "abhishek"

echo ;
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" ;
echo ">> Checking if the user is 'abhishek'. If not, then nothing would run after this line." ;
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;
echo;

if [[ "$USER" == "abhishek" ]] ;
then

    echo "creating markdown books index in dropbox......"
    sh $BASEPATH/1_create_markdown_books_index.sh

    echo "creating wallpapers index in github......"
    sh $BASEPATH/2_create_wallpapers_index.sh

    echo "creating logos index in dropbox......"
    sh $BASEPATH/10D_create_OUR_LOGOS_indexes.sh

    echo "creating LOW POLY backgrounds index in dropbox......"
    sh $BASEPATH/10C_create_LOWPOLY_indexes.sh

    echo "creating JSON Wallpaper Templates index file in dropbox......"
    sh $BASEPATH/10A_create_JSON_plus_image_indexes.sh

    echo "creating SOCIAL MEDIA images index file in dropbox......"
    sh $BASEPATH/10B_create_SOCIAL_MEDIA_image_indexes.sh

    echo "creating ADORIA.XYZ portfolio index file in dropbox......"
    sh $BASEPATH/10E_create_adoria_xyz_portfolio_index_page.sh


    #######################################################
    #### CREATING SITEMAPS ####
    echo "CREATING SITEMAPS..."
    sh $BASEPATH/11-sitemap-for-website-generator.sh
    echo ;
    #######################################################


    #### BACKUP TO-AND-FROM DREAMCOMPUTE SERVER ####
    #### Actual backup command aliases below ##
    echo ;
    echo "     ++++++++ Getting backups to-and-from DREAMCOMPUTE and KVM ARCH Server......" ;

    echo ;
    echo "     >>>>>>>> BEGINNING: Backup [FROM] DIGITAL OCEAN Server DONE. <<<<<<<" ;
    say "Enter password on command prompt:" ;
    1_backup_from_digitalocean_server ;
    echo "     >>>>>>>> DONE: Backup [FROM] DIGITAL OCEAN Server DONE. <<<<<<<" ;
    echo ;

    echo " = = = = > Now opening the DreamCompute + KVM ARCH VPS Backup directory..." ;
    open $HOME/OneDrive/Apps2Sync/DreamCompute-VPS-Backup ; ## Don't forget to add semicolon at the end.

    ######################## BACKUPS TO CDN ###################################
    echo ;
    echo "     >>>>>>>> BEGINNING: Backup [TO] downloads.concepro.com <<<<<<<" ;
    1_backup_to_concepro_cdn ;
    echo "     >>>>>>>> DONE: Backup [TO] downloads.concepro.com <<<<<<<" ;
    echo ;

    ####
    echo ;
    echo "     >>>>>>>> BEGINNING: Backup [TO] downloads.mygingergarlickitchen.com <<<<<<<" ;
    1_backup_to_mggk_cdn ;
    echo "     >>>>>>>> DONE: Backup [TO] downloads.mygingergarlickitchen.com <<<<<<<" ;
    echo ;

    ####
    echo ;
    echo "     >>>>>>>> BEGINNING: Backup [TO] https://adoria.xyz <<<<<<<" ;
    1_backup_to_adoria_xyz ;
    echo "     >>>>>>>> DONE: Backup [TO] https://adoria.xyz <<<<<<<" ;
    echo ;

else
    echo ">>>> 1. The USER is >>> $USER <<< , which is not 'abhishek'. Hence, no SSH/SCP backups are performed." ;
    echo ">>>> 2. NOTE: IF you want to execute the SSH/SCP backup block, then run this script as USER 'abhishek' on MBP15. " ;
fi

########################## SCRIPT ENDS ########################
