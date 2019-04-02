# RSS to Email for MGGK using XMLstarlet

## Tutorial links:

https://stackoverflow.com/questions/12640152/xmlstarlet-select-value

http://xmlstar.sourceforge.net/doc/UG/xmlstarlet-ug.html#idm47077139652416


#### 1. General Bash commands

```

curl -s https://www.mygingergarlickitchen.com/index.xml | xmlstarlet sel -t -v "/rss/channel/item/title"

curl -s https://www.mygingergarlickitchen.com/index.xml | xmlstarlet sel -t -v "/rss/channel/item/link"

curl -s https://www.mygingergarlickitchen.com/index.xml | xmlstarlet sel -t -v "/rss/channel/item/pubDate"

curl -s https://www.mygingergarlickitchen.com/index.xml | xmlstarlet sel -t -v "/rss/channel/item/description"

```

#### 2. Getting elements by selecting node one by one

For selecting the value of the 1st item node, use item[1] in the syntax below. Similarly for item 2nd, 3rd, 4th..., do it like item[2], item[3], etc. 

Run it all looping over all node using a bash for loop.

```
## first download the xml file locally and save as feed.xml
curl -s https://www.mygingergarlickitchen.com/index.xml > feed.xml

## now run the loop over all item values (choose about 8 entries from top)
for x in {1..8}
do
	xmlstarlet sel -t -v "/rss/channel/item[$x]/title" feed.xml ; echo ;
	xmlstarlet sel -t -v "/rss/channel/item[$x]/pubDate" feed.xml ; echo ;	xmlstarlet sel -t -v "/rss/channel/item[$x]/link" ; feed.xml ; echo ;
	xmlstarlet sel -t -v "/rss/channel/item[$x]/description" feed.xml ; echo ;

done


```
