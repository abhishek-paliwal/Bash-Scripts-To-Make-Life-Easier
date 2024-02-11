######################################################################
## THIS PROGRAM FINDS FOR SEO, THE COUNTS OF EACH OF PARTICULAR KEYWORDS IN
## A COMPETITOR RECIPE URL.
## DATE: 2024-02-11
## BY: PALI
######################################################################


WORKDIR="$DIR_Y" ; 
tmpfile1="$WORKDIR/_tmpfile1_00238.txt" ; 
curledFile="$WORKDIR/_tmpcurlfile_00238.html" ; 
echo > "$tmpfile1" ; 

echo "##------------------------------------------------------------------------------" ; 
read -p "Please enter your competitor URL for keywords count: " competitorURL ; 
echo "##------------------------------------------------------------------------------" ; 
echo ">> Select which keywords file to use (txt, csv):" ; 
whichKeywordsFile=$(fd --search-path="$WORKDIR" -e txt -e csv | fzf) ; 
dos2unix "$whichKeywordsFile" ; 
echo "##------------------------------------------------------------------------------" ; 

curl -sk "$competitorURL" > "$curledFile"  ;

while IFS="\n" read line; do 
    numTimes=$(grep -io "$line" "$curledFile" | wc -l | tr -d ' ') ; 
    echo "$numTimes = $line" >> $tmpfile1 ; 
done < $whichKeywordsFile

echo ">> DISPLAYING KEYWORD COUNTS SORTED ..." ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;  
sort -n "$tmpfile1" ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;  
