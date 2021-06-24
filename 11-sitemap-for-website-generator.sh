#!bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
# This script creates sitemaps in directories specified as function arguments
# by passing arguments to a function
# Creation Date: Sunday April 16, 2017
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


##------------------------------------------------------------------------------
## FUNCTION DEFITNITION
## Open directory if on MAC computer
function open_dir_on_mac() {
    if [ "$(uname)" = "Darwin" ] ; then
        echo "Opening $1" ;
        open $1 ;
    fi
}
##------------------------------------------------------------------------------

#####################################################################
################### NEW SITEMAP USING TREE COMMAND ##################
#####################################################################

####### DIR 1 ########
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
echo ;
sitemapDir="$HOME/Dropbox/Public/_TO_SYNC_downloads.mygingergarlickitchen.com"
cd $sitemapDir
echo "===>>>>>>>> BEGINNING : TREE Sitemap Creation at $sitemapDir"
tree -C -H 'https://downloads.mygingergarlickitchen.com' -T 'SITEMAP for downloads.mygingergarlickitchen.com' --sort=name  > sitemap.html
echo '===>>>>>>>> DONE : TREE Sitemap Creation at $sitemapDir'
echo "<hr>Sitemap created on: $(date)" >> sitemap.html
echo ">> PRINTING THE LAST LINES OF THE NEWLY CREATED SITEMAP (for checking the date) ..."
tail $sitemapDir/sitemap.html
#open_dir_on_mac $sitemapDir ## if mac (uncomment if needed)
######################

####### DIR 2 ########
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
echo ;
sitemapDir="$HOME/Dropbox/Public/_TO_SYNC_downloads.concepro.com"
cd $sitemapDir
echo "===>>>>>>>> BEGINNING : TREE Sitemap Creation at $sitemapDir"
tree -C -H 'https://downloads.concepro.com' -T 'SITEMAP for downloads.concepro.com' --sort=name  > sitemap.html
echo "<hr>Sitemap created on: $(date)" >> sitemap.html
echo '===>>>>>>>> DONE : TREE Sitemap Creation at $sitemapDir' ;
echo ">> PRINTING THE LAST LINES OF THE NEWLY CREATED SITEMAP (for checking the date) ..."
tail $sitemapDir/sitemap.html
#open_dir_on_mac $sitemapDir ## if mac (uncomment if needed)
######################

echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 

