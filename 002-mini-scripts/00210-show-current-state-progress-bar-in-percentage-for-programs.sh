#/bin/bash
## THIS PROGRAM DISPLAYS CURRENT PROGRESS IN PERCENTAGE
## NOTE: This program takes two CLI arguments
current_count="$1" ; 
total_count="$2"; 
################################################################################
function FUNC_SHOW_PROGRESS_PERCENTAGE (){
    ## SHOWING CURRENT PROGRESS IN PERCENTAGE
    done_percent=$(( ($current_count*100)/$total_count )) ;
    if [ $(($done_percent % 10)) -eq 0 ] ; then
        echo ; 
        printf "%s%s" "${done_percent}% " "..." ; 
    else
        printf "%s" "." ; 
    fi 
}
################################################################################

FUNC_SHOW_PROGRESS_PERCENTAGE "$current_count" "$total_count" ; 
