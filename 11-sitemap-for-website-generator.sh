#!bin/bash
# This script creates sitemaps in directories specified as function arguments
# by passing arguments to a function
# Creation Date: Sunday April 16, 2017
#####################################################################
################### NEW SITEMAP USING TREE COMMAND ##################
#####################################################################

####### DIR 1 ########
sitemapDir="$HOME/Dropbox/Public/_TO_SYNC_cdn.mygingergarlickitchen.com"
cd $sitemapDir
echo '===>>>>>>>> BEGINNING : TREE Sitemap Creation at '$sitemapDir
tree -C -H 'https://cdn.mygingergarlickitchen.com' -T 'SITEMAP for cdn.mygingergarlickitchen.com' --sort=name  > sitemap.html
echo '===>>>>>>>> DONE : TREE Sitemap Creation at '$sitemapDir
echo '<hr>Sitemap created on: ' `date` >> sitemap.html
echo 'Opening '$sitemapDir
open $sitemapDir ## MAC only COMMAND
######################

####### DIR 2 ########
sitemapDir="$HOME/Dropbox/Public/_TO_SYNC_downloads.concepro.com"
cd $sitemapDir
echo '===>>>>>>>> BEGINNING : TREE Sitemap Creation at '$sitemapDir
tree -C -H 'https://downloads.concepro.com' -T 'SITEMAP for downloads.concepro.com' --sort=name  > sitemap.html
echo '<hr>Sitemap created on: ' `date` >> sitemap.html
echo '===>>>>>>>> DONE : TREE Sitemap Creation at '$sitemapDir
echo 'Opening '$sitemapDir
open $sitemapDir ## MAC only COMMAND
######################