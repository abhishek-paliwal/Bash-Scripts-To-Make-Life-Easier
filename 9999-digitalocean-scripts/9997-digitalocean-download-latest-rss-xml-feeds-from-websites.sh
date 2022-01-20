#/bin/bash
## This program downloads xml rss feeds from listed urls

################################################################################
outDir="/var/www/vps.abhishekpaliwal.com/html/scripts-html-outputs/data-reactapps" ; 
################################################################################
## Download all feeds ...
wget https://www.cookwithmanali.com/feed/ -O $outDir/feed_cookwithmanali.xml ;
wget https://www.vegrecipesofindia.com/feed/ -O $outDir/feed_vegrecipesofindia.xml ;
wget https://hebbarskitchen.com/feed/ -O $outDir/feed_hebbarskitchen.xml ;
wget https://www.indianhealthyrecipes.com/feed/ -O $outDir/feed_indianhealthyrecipes.xml ;
wget https://www.whiskaffair.com/feed/ -O $outDir/feed_whiskaffair.xml ;
wget https://www.halfbakedharvest.com/feed/ -O $outDir/feed_halfbakedharvest.xml ;
wget https://www.leelasrecipes.com/index.xml -O $outDir/feed_leelasrecipes.xml ;
wget https://www.mygingergarlickitchen.com/index.xml  -O $outDir/feed_mygingergarlickitchen.xml ;
################################################################################
