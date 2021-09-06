#/bin/bash

################################################################################
function work_is_done (){
    echo ">> This purpose of this program is done. It's only for archiving purposes. It does not need to run ever again." ;
    exit 1 ; 
}
## 
work_is_done ;

################################################################################
function func_count_occurences (){
    while read line; do
        #echo "################################################################################" ;
        #echo "LINE => $line" ;
        char=".jpg" ;
        echo "$line" | awk -F"${char}" '{print NF-1 "  " $0}' ;
    done < "$DIR_Y/1.txt" ;
}
################################################################################
function func_replace_images_in_files () {
echo > $DIR_Y/4.md ; 
count=0;
while read x ; do 
    ((count++)) ;
    echo "##--------------------------- $count --------------------------------" ;
    echo "$x" ; 
    echo "$x" | grep -iE '\[\!\[.*\]\(.*\)\]\(.*\)' | sed 's%\[\!\[\(.*\)\](\(.*\))\](\(.*\))%![\1](\3)%g' >> $DIR_Y/4.md
    echo "################################################################################" ;
done < "$DIR_Y/1.txt" ;
}
################################################################################
function func_replace_in_mdfiles () {
    for x in $(fd -e md --search-path="$REPO_MGGK/content/"); do 
    sed -i '' 's%.png%.jpg%g' $x ; 
    done 
}
################################################################################

#grep -irh '\[\!\[\]' "$REPO_MGGK/content/" > $DIR_Y/1.txt ;
#grep -irh '\[\!\[' "$REPO_MGGK/content/" >> $DIR_Y/1.txt ;
grep -irh '\!\[' "$REPO_MGGK/content/" >> $DIR_Y/1.txt ;

#func_count_occurences ;
#func_replace_images_in_files ;
#func_replace_in_mdfiles ;
