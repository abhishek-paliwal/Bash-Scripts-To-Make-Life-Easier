#/bin/bash 

## This program finds and replaces images of pattern => AAAxAAA (where A = digit) 

inDir="$REPO_MGGK/content/" ;

tmpFile0="$DIR_Y/tmp0.txt" ; 
echo > $tmpFile0 ;

tmpFile1="$DIR_Y/tmp1.txt" ; 
######
for mdfile in $(fd -e md --search-path="$inDir") ; do 
    ##
    echo; 
    echo "##------------------------------------------------------------------------------" ;
    ag '.jpg' $mdfile | grep -io 'wp-content.*.jpg' | grep -iv 'responsive' | sd "('|\")" "" | awk '{print $1}' | sort -u | sd '^' "$REPO_MGGK/static/" > $tmpFile1 ;
    ####
    for x in $(cat $tmpFile1 | grep -i '.jpg') ; do 
        x_orig=$(echo $x | sd "$REPO_MGGK/static/" '' ) ;
        x_new=$(echo $x | sd '\-\d{4}x\d{4}' '' | sd '\-\d{4}x\d{3}' '' | sd '\-\d{3}x\d{5}' '' | sd '\-\d{3}x\d{4}' '' | sd '\-\d{3}x\d{3}' ''  ) ;
        x_new_orig=$(echo $x_new | sd "$REPO_MGGK/static/" '' ) ;
        echo "/+/ $x_orig /+/ $x_new_orig" ;
        if [ -f "$x_new" ] ; then 
            echo ">> FILE FOUND => $x_new" ; 
            sed -i '' "s%$x_orig%$x_new_orig%g" $mdfile ; 
        else
            echo ">> FILE NOT FOUND => $x_new" ;
            sed -i '' "s%$x_orig%$x_new_orig%g" $mdfile ;  
        fi 
    done 
    ####
    wordcount=$(cat $tmpFile1 | wc -l | sd ' ' ''   ) ;
    echo "$wordcount // $mdfile" >> $tmpFile0 ;
done 
######
echo "################################################################################" ;
sort -n $tmpFile0 ;
echo "################################################################################" ;
