#/bin/bash
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## THIS CODE REPLACES OLD MARKDOWN IMAGE TAGS OF THIS FORMAT = ![image_caption](image_url) 
## TO NEW HUGO FIGURE SHORTCODE FORMAT IN ROOTDIR
## DATE: 2024-01-30
## BY: PALI
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ROOTDIR="$REPO_MGGK/content" ; 

##------------------------------------------------------------------------------
## STEP 1 =FIND ALL MDFILE PATHS CONTAINING OLD TAGS
for x in $(ag '!\[' -l "$ROOTDIR" ); do 
    ag '!\[' --no-numbers "$x" >  "$DIR_Y/$(basename $x).txt" ; 
done
##------------------------------------------------------------------------------

##------------------------------------------------------------------------------
## STEP =2 PROCESS EACH FILE AND REPLACE OLD TAGS TO NEW ONES IN MARKDOWN FILES
for y in *.txt ; do 
        echo > "$y.csv" ; 
########
    while read line ; do 
        newline_f1=$(echo "$line" | grep -io '\[.*\]' | sd '\[|\]' '' | awk -F '/' '{print $NF}' | sd '\-|.jpg' ' ' ) ; 

        newline_f2=$(echo "$line" | grep -io '(.*)'   | sd '\(|\)' '' ) ; 
        newline_f2_caption=$(echo "$newline_f2" | awk -F '/' '{print $NF}' | sd '\-|.jpg' ' ' | sd -fi 'anupama|paliwal|my|ginger|garlic|kitchen' '' | sd '[[:digit:]]' '' | sd ' +' ' ' | sd ' $' '' | sd '^ ' '' ) ; 
        ##
        echo "$newline_f2,$newline_f2_caption" >> "$y.csv" ; 
        ##
        ##
        for mdfile in $(grep -irl "$newline_f2" "$ROOTDIR") ; do 
            echo "== $mdfile" ;
            image_var="{{< figure src=\"$newline_f2\" alt=\"$newline_f2_caption\" >}}" ; 
            echo ">> $image_var" ; 
            sed -i '' "s|.*$newline_f2.*|$image_var|ig" $mdfile ; 
        done 
    done < $y 
########
done 
##------------------------------------------------------------------------------
