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
    git fetch ; 
    echo ">> PULLING ..."; 
    git pull ; 
    cd $DIR_GITHUB ; 
done
##


## Printing text in big letters
##
cat << "EOF" 
 ____  _____ ____   ___  ____                  _       _           _
|  _ \| ____|  _ \ / _ \/ ___| _   _ _ __   __| | __ _| |_ ___  __| |
| |_) |  _| | |_) | | | \___ \| | | | '_ \ / _` |/ _` | __/ _ \/ _` |
|  _ <| |___|  __/| |_| |___) | |_| | |_) | (_| | (_| | ||  __| (_| |
|_| \_|_____|_|    \___/|____/ \__,_| .__/ \__,_|\__,_|\__\___|\__,_|
                                    |_|
EOF
