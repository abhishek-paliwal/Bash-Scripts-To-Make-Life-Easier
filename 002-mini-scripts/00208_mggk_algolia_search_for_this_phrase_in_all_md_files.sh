#/bin/bash

echo "ENTER THE PHRASE TO SEARCH [case does not matter]:"; 
read SEARCHTERM ; 

SEARCHDIR="$REPO_MGGK/content" ; 
################################################################################
echo; echo; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
echo ">> LISTING OF THE LINES WHERE THIS PHRASE IS FOUND (=> $SEARCHTERM) ..."; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
grep -ir --color=always "$SEARCHTERM" $SEARCHDIR/* ; 
################################################################################
echo; echo; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
echo ">> PHRASE FOUND IN FOLLOWING MD FILES (in $SEARCHDIR) =>"; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
grep -irl "$SEARCHTERM" $SEARCHDIR/* ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
################################################################################
echo; echo; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
echo ">> MGGK URLS FOUND FOR THE ABOVE MD FILES (in $SEARCHDIR) =>"; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
OUTFILE_TXT="$DIR_Y/_tmp_algolia_search_this_phrase.txt" ;
echo > $OUTFILE_TXT ; ## initializing this file
for mdfile in $(grep -irl "$SEARCHTERM" $SEARCHDIR/*) ; do 
    grep -irh 'url: ' $mdfile | sed 's|url: |https://www.mygingergarlickitchen.com|ig' >> $OUTFILE_TXT ;
done
##
cat $OUTFILE_TXT | nl ;
##
################################################################################
echo; echo; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
OUTFILE_TXT_SORTED="$DIR_Y/_tmp_algolia_search_this_phrase_SORTED.txt" ;
sort $OUTFILE_TXT > $OUTFILE_TXT_SORTED ;
OUTFILE_HTML="$DIR_Y/_tmp_algolia_search_this_phrase.html" ;
dateVar=$(date) ; 
NUM_URLS=$(cat $OUTFILE_TXT_SORTED | grep -iv '^$' |wc -l ) ;
echo ">> IMPORTANT NOTE: The HTML output containing all these URLs will open in browser now." ;
##
echo "<html><body>" > $OUTFILE_HTML ; 
echo "<p>Output created at: $dateVar</p>" >> $OUTFILE_HTML ; 
echo "<h1>$NUM_URLS MGGK URLs found for MD-Files containing this phrase anywhere = <strong>$SEARCHTERM</strong></h1><hr><ol>" >> $OUTFILE_HTML ; 
while read line; do 
    if [ "$line" != "" ] ; then
        echo "<li style='padding: 5px;'><a target='_blank' href='$line'>$line</a></li>" >> $OUTFILE_HTML ;
    fi 
done < $OUTFILE_TXT_SORTED ;
echo "</ol></body></html>" >> $OUTFILE_HTML ; 
##
open $OUTFILE_HTML ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
################################################################################
