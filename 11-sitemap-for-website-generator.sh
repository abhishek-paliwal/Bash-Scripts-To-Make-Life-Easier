#!bin/bash
# This script creates sitemaps in directories specified as function arguments
# by passing arguments to a function
create_sitemap_in_this_directory () {
  cd $1 ;
  siteName=`basename $1`
  # sitemap creation begins
  echo '++++++++++++++++++++++++++++++++++++++++++++++++++'
  echo '===>>>>>>>> BEGINNING : Sitemap Creation at '$1
  echo "<h1>SITEMAP for $siteName</h1>" > sitemap.html

  for y in `ls -c $1` ;  #Only lists diretories and files in root folder
    do
        echo "<div style='display : block ; padding : 5px ; '>&bull; <a href='$y'>$y</a></div>" ;
    done >> sitemap.html

  echo "<hr><h3>This sitemap is automatically created on : "`date`"</h3>" >> sitemap.html

  echo '===>>>>>>>> DONE : Sitemap Creation at '$1

  ### Opening directory
  echo 'Opening directory...'
  open $1 # Works only on Mac
}

## Actual magic by calling the fuctions with required directories as arguments
create_sitemap_in_this_directory $HOME/Dropbox/Public/_TO_SYNC_cdn.mygingergarlickitchen.com
create_sitemap_in_this_directory $HOME/Dropbox/Public/_TO_SYNC_downloads.concepro.com
