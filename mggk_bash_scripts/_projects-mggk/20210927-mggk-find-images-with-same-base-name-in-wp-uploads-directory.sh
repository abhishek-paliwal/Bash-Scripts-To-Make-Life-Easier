#/bin/bash

################################################################################
## step1 = Find images with same base name in different folders in MGGK wp uploads directory.
## step2 = Copy those images based upon the md files they are present in.
## step3 = Replace the old image names with newly copied ones in original md files.
################################################################################

inDir="$REPO_MGGK/static/wp-content/uploads/" ; 
outFile1="$DIR_Y/1.txt"
outFile2="$DIR_Y/2.txt"

## step1
fd -I -t f --search-path="$inDir" -x echo {/} > $outFile1
sort $outFile1 | uniq -c | sort -n | grep -iv '1 ' | awk '{print $2}' > $outFile2

count=0 ;
for x in $(cat $outFile2); do 
    outFile3="$DIR_Y/3.txt" ;
    fd -I "$x" --search-path="$inDir" > $outFile3 ;
    (( count++ )) ; 
    echo "COUNT: $count" ; 
    ####
    while read line; do
        newline=$(echo $line | sd "$REPO_MGGK/static/wp-content/uploads" "" ) ;
        echo "LINE: $line" ;
        echo "NEWLINE: $newline" ;
        bname=$(basename $line)
        dname=$(dirname $line)
        echo "BASENAME: $bname" ;
        echo "DIRNAME: $dname" ;
        ##
        outFile4="$DIR_Y/4.txt" ;
        grep -irl "$newline" "$REPO_MGGK/content" | grep -iv '99_collections' > $outFile4 ;
        for y in $(cat $outFile4); do 
            myfile="$y" ;
            myurl=$(grep -irh '^url:' $myfile | sd '(url:|/| )' '' ) ;
            myImageName="$myurl-image-$count.jpg" ;
            if [ -f "$myfile" ] ; then 
                echo "FILE: $myfile" ;
                echo "MYIMAGE: $myImageName" ;
                ## step2
                cp "$line" "$dname/$myImageName" ;
                ## step3
                sed -i '' "s|$bname|$myImageName|g" $myfile ;
            fi
        done
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
    done < $outFile3 ;
    ####
done


