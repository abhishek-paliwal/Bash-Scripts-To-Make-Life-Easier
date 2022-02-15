#/bin/bash

echo "ENTER THE PHRASE TO SEARCH?"; 
read SEARCHTERM ; 

SEARCHDIR="$REPO_MGGK/content" ; 
echo; echo; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
echo ">> LISTING OF THE LINES WHERE THIS PHRASE IS FOUND (=> $SEARCHTERM) ..."; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
grep -ir --color=always "$SEARCHTERM" $SEARCHDIR/* ; 
echo; echo; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
echo ">> PHRASE FOUND IN FOLLOWING MD FILES (in $SEARCHDIR) =>"; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
grep -irl "$SEARCHTERM" $SEARCHDIR/* ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
