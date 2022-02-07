#/bin/bash
## This program downloads xml rss feeds from listed urls

################################################################################
outDir="/var/www/vps.abhishekpaliwal.com/html/scripts-html-outputs/data-reactapps/rssfeeds" ; 
mkdir -p "$outDir" ; ## make dir (if not exists)
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
################################################################################
## Download all news feeds ...
wget https://feeds.yle.fi/uutiset/v1/recent.rss?publisherIds=YLE_NEWS -O $outDir/YLE-English.xml
wget http://rss.slashdot.org/Slashdot/slashdotMainatom -O $outDir/Slashdot-Top-News.xml
wget http://feeds.bbci.co.uk/news/rss.xml -O $outDir/BBC-Top.xml
wget http://feeds.bbci.co.uk/news/world/rss.xml -O $outDir/BBC-World.xml
wget http://feeds.bbci.co.uk/news/health/rss.xml -O $outDir/BBC-Health.xml
wget http://feeds.bbci.co.uk/news/science_and_environment/rss.xml -O $outDir/BBC-Science.xml
wget http://feeds.bbci.co.uk/news/technology/rss.xml -O $outDir/BBC-Technology.xml
wget https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml -O $outDir/NYT-Top.xml
wget https://rss.nytimes.com/services/xml/rss/nyt/Technology.xml -O $outDir/NYT-Technology.xml
wget https://rss.nytimes.com/services/xml/rss/nyt/PersonalTech.xml -O $outDir/NYT-Personal-Tech.xml
wget https://rss.nytimes.com/services/xml/rss/nyt/World.xml -O $outDir/NYT-World.xml
wget https://rss.nytimes.com/services/xml/rss/nyt/AsiaPacific.xml -O $outDir/NYT-Asia-Pacific.xml
wget https://rss.nytimes.com/services/xml/rss/nyt/Science.xml -O $outDir/NYT-Science.xml
wget https://rss.nytimes.com/services/xml/rss/nyt/Health.xml -O $outDir/NYT-Health.xml
wget https://timesofindia.indiatimes.com/rssfeedstopstories.cms -O $outDir/TOI-Top.xml
wget https://timesofindia.indiatimes.com/rssfeeds/66949542.cms -O $outDir/TOI-Technology.xml
wget https://timesofindia.indiatimes.com/rssfeeds/296589292.cms -O $outDir/TOI-World.xml
wget https://www.hindustantimes.com/feeds/rss/latest/rssfeed.xml -O $outDir/HT-Latest.xml
wget https://www.hindustantimes.com/feeds/rss/world-news/rssfeed.xml -O $outDir/HT-World.xml
wget https://www.thehindu.com/feeder/default.rss -O $outDir/The-Hindu-Top-News.xml
wget https://www.thehindu.com/news/international/feeder/default.rss -O $outDir/The-Hindu-World.xml
################################################################################
