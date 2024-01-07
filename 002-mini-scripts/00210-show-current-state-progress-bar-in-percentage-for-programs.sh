#/bin/bash
## THIS PROGRAM DISPLAYS CURRENT PROGRESS IN PERCENTAGE
## NOTE: This program takes two CLI arguments
current_count="$1" ; 
total_count="$2"; 
################################################################################
## SHOWING CURRENT PROGRESS IN PERCENTAGE
done_percent=$(( ($current_count*100)/$total_count )) ;
if [ $(($done_percent % 10)) -eq 0 ] ; then
    echo ; 
    printf "%s%s" "${done_percent}% " "..." ; 
else
    printf "%s" "." ; 
fi 
##
## Show progress using pipeviewer command
echo "$1/$2" | pv -p  ;  
################################################################################
