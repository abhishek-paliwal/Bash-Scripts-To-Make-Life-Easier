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

  echo "<html>"  > sitemap.html
  echo "  <head>"  >> sitemap.html
  echo "<title>SITEMAP for $WebsiteName</title>" >> sitemap.html

  echo "    <script type='text/javascript' src='https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.0/moment.js'></script>"  >> sitemap.html
  echo "<link href='https://fonts.googleapis.com/css?family=Roboto+Slab:100,300,400,700,900|Roboto:100,300,400,500,700,900' rel='stylesheet'>"

  echo "<style type='text/css'>" >> sitemap.html
  echo "h1 { line-height: 0.8 ; font-weight: 900; font-size: 3em; font-family: 'Roboto' ; color : $headingColor ; }" >> sitemap.html
  echo "body , div {font-size: 1.2em; font-weight: 300; font-family: 'Roboto Slab' ; color : $headingColor ; }" >> sitemap.html
  echo "</style>" >> sitemap.html

  echo "  </head>"  >> sitemap.html
  echo "  <body>"  >> sitemap.html

  echo "<h1>SITEMAP FOR<br>$WebsiteName</h1>" >> sitemap.html

  for y in `ls -c $1` ;  #Only lists diretories and files in root folder
    do
        echo "<div style='display : block ; padding : 5px ; '>&bull; <a href='$y'>$y</a></div>" ;
    done >> sitemap.html

  echo "<hr><h3>This sitemap is automatically created on : <span id='modifiedOn'></span> { "`date`" }</h3>" >> sitemap.html

          echo "<script>" >> sitemap.html

          updateDate=`date +%s` ; >> sitemap.html  ##Getting Unix timeStamp

    ## Now using moment.js javascript program
          echo "DateModifiedOn = moment.unix('$updateDate').calendar(); " >> sitemap.html
    ## moment.js block ends.

          echo "document.getElementById('modifiedOn').innerHTML = DateModifiedOn ; " >> sitemap.html

          echo "</script>" >> sitemap.html

  echo "  </body>"  >> sitemap.html
  echo "</html>"  >> sitemap.html


  echo '===>>>>>>>> DONE : Sitemap Creation at '$1

  ### Opening directory
  echo 'Opening directory...'
  open $1 # Works only on Mac
}

## Actual magic by calling the fuctions with required directories as arguments
#### Running Format >> create_sitemap_in_this_directory FOLDERDIR HEADING_NAME COlOR_NAME
create_sitemap_in_this_directory $HOME/Dropbox/Public/_TO_SYNC_cdn.mygingergarlickitchen.com 'CDN. MY GINGER GARLIC KITCHEN. COM' \#cd1d62
create_sitemap_in_this_directory $HOME/Dropbox/Public/_TO_SYNC_downloads.concepro.com 'DOWNLOADS. CONCEPRO. COM' \#3498db
