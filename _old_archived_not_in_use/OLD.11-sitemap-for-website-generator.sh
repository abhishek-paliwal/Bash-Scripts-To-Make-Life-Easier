#!bin/bash
# This script creates sitemaps in directories specified as function arguments
# by passing arguments to a function
create_sitemap_in_this_directory () {
  cd $1 ;
  siteName=`basename $1`
  WebsiteName=`echo $2`
  headingColor=`echo $3`

  # sitemap creation begins
  echo '++++++++++++++++++++++++++++++++++++++++++++++++++'
  echo '===>>>>>>>> BEGINNING : Sitemap Creation at '$1

  echo "<html>"  > sitemap_old.html
  echo "  <head>"  >> sitemap_old.html
  echo "<title>SITEMAP for $WebsiteName</title>" >> sitemap_old.html

  echo "<script type='text/javascript' src='https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.0/moment.js'></script>"  >> sitemap_old.html
  echo "<link href='https://fonts.googleapis.com/css?family=Roboto+Slab:100,300,400,700,900|Roboto:100,300,400,500,700,900' rel='stylesheet'>" >> sitemap_old.html

  echo "<style type='text/css'>" >> sitemap_old.html
  echo "h1 { line-height: 0.8 ; font-weight: 900; font-size: 3em; font-family: 'Roboto' ; color : $headingColor ; }" >> sitemap_old.html
  echo "body , div {font-size: 1.2em; font-weight: 300; font-family: 'Roboto Slab' ; color : $headingColor ; }" >> sitemap_old.html
  echo "</style>" >> sitemap_old.html

  echo "  </head>"  >> sitemap_old.html
  echo "  <body>"  >> sitemap_old.html

  echo "<h1>SITEMAP FOR<br>$WebsiteName</h1>" >> sitemap_old.html

  for y in `ls -c $1` ;  #Only lists diretories and files in root folder
    do
        echo "<div style='display : block ; padding : 5px ; '>&bull; <a href='$y'>$y</a></div>" ;
    done >> sitemap_old.html

  echo "<hr><h3>This sitemap is automatically created on : <span id='modifiedOn'></span> { "`date`" }</h3>" >> sitemap_old.html

          echo "<script>" >> sitemap_old.html

          updateDate=`date +%s` ; >> sitemap_old.html  ##Getting Unix timeStamp

    ## Now using moment.js javascript program
          echo "DateModifiedOn = moment.unix('$updateDate').calendar(); " >> sitemap_old.html
    ## moment.js block ends.

          echo "document.getElementById('modifiedOn').innerHTML = DateModifiedOn ; " >> sitemap_old.html

          echo "</script>" >> sitemap_old.html

  echo "  </body>"  >> sitemap_old.html
  echo "</html>"  >> sitemap_old.html


  echo '===>>>>>>>> DONE : Sitemap Creation at '$1

  ### Opening directory
  echo 'Opening directory...'
  open $1 # Works only on Mac
}

## Actual magic by calling the fuctions with required directories as arguments
#### Running Format >> create_sitemap_in_this_directory FOLDERDIR HEADING_NAME COlOR_NAME
create_sitemap_in_this_directory $HOME/Dropbox/Public/_TO_SYNC_cdn.mygingergarlickitchen.com 'CDN. MY GINGER GARLIC KITCHEN. COM' \#cd1d62
create_sitemap_in_this_directory $HOME/Dropbox/Public/_TO_SYNC_downloads.concepro.com 'DOWNLOADS. CONCEPRO. COM' \#3498db

#####################################################################
################### NEW SITEMAP USING TREE COMMAND ##################
#####################################################################
create_modern_tree_sitemap () {
  cd $1 ;
  siteBaseURL=`echo $2`
  sitemapTitle=`echo 'SITEMAP FOR: '$siteBaseURL`
  ## REAL MAGIC BEGINS
  tree -H $siteBaseURL -C -T $sitemapTitle --sort=name  > sitemap.html

  echo '===>>>>>>>> DONE : TREE Sitemap Creation at '$1
  ### Opening directory
  echo 'Opening directory...'
  open $1 # Works only on Mac
}

## Actual magic by calling the fuctions with required directories as arguments
#### Running Format >> create_modern_tree_sitemap FOLDERDIR SITE_URL
create_modern_tree_sitemap $HOME/Dropbox/Public/_TO_SYNC_cdn.mygingergarlickitchen.com 'https://cdn.mygingergarlickitchen.com'
create_modern_tree_sitemap $HOME/Dropbox/Public/_TO_SYNC_downloads.concepro.com 'https://downloads.concepro.com'
