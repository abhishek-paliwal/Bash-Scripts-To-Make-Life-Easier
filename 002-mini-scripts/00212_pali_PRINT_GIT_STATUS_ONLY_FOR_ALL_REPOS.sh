#/bin/bash
##
count=0 ; 
total_tmp=$(fd -t d -d1 --search-path="$DIR_GITHUB" | wc -l | tr -d " " ) ; 
total=$(( $total_tmp ));
##
for myDir in $DIR_GITHUB/*/ ; do 
    ((count++)) ; 
    echo ; 
    echo "******** $count of $total ********" ;
    echo ; 
    echo ">> CURRENT DIR => ${myDir}" ; 
    cd ${myDir} ; 
    echo ">> STATUS and FETCHING ..."; 
    git status ; 
    #git fetch ; 
    #echo ">> PULLING ..."; 
    #git pull ; 
    cd $DIR_GITHUB ; 
done
##
