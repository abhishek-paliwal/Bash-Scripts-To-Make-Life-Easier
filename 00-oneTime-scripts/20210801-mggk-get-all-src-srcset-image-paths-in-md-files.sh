################################################################################
## script which prints all image paths present in img src and srcset html tags
################################################################################
#/bin/bash

prefix="123" ;
tmpfile0="$DIR_Y/$prefix-tmp0.txt" ;
tmpfile1="$DIR_Y/$prefix-tmp1.txt" ;

## find all recipe md files with img tags but no srcset attribute 
## This means that those img tags need to be replaced by hugo figure shortcodes

## finding all valid recipe files
ag -l 'preptime' $REPO_MGGK/content/  > $tmpfile0
##
for x in $( ag -l 'img' $(cat $tmpfile0) ) ; do ag -L 'srcset' $x ; done > $tmpfile1

cat $tmpfile1 | nl ;

##
r1="$DIR_Y/$prefix-result-grepimg.txt" ;
r2="$DIR_Y/$prefix-result-grepimgsrc.txt" ;
r3="$DIR_Y/$prefix-result-grepimgalt.txt" ;
##
for y in $(cat $tmpfile1) ; do 
    echo "###########################" ;
    grep 'img' $y >> $r1 ;
    grep 'img' $y | ack -o 'src.*.jpg"' >> $r2 ;
    grep 'img' $y | ack -o 'alt.*"' >> $r3 ;
done    
################################################################################
