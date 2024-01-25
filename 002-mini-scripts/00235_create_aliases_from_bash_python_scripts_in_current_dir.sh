#!/bin/bash
## THIS PROGRAM CREATES ALIASES FOR BASH OR PYTHON PROGRAMS IN CURRENT DIRECTORY.

WORKDIR="$DIR_Y" ; 
CURRENT_DIR="$(pwd)" ; 
TMPFILE_BASH="$WORKDIR/_tmpfile_bash.txt" ; 
TMPFILE_PYTHON="$WORKDIR/_tmpfile_python.txt" ; 

##------------------------------------------------------------------------------
FUNC_create_alias_for_bash_programs () {
    echo ">> CREATING ALIASES FOR BASH PROGRAMS ..." ;  echo ;
    fd -t f -e sh -e bash --search-path="$CURRENT_DIR" -x echo "alias {/.}='cdy; bash {}' ; " | sort | nl > "$TMPFILE_BASH" ;
}
##------------------------------------------------------------------------------
FUNC_create_alias_for_python_programs () {
    echo ">> CREATING ALIASES FOR PYTHON PROGRAMS ..." ; echo;  
    fd -t f -e py --search-path="$CURRENT_DIR" -x echo "alias {/.}='cdy; activate_python_venv3 ; python3 {}' ; " | sort | nl > "$TMPFILE_PYTHON" ;
    echo ; 
} 
##------------------------------------------------------------------------------

echo ;
FUNC_create_alias_for_bash_programs ; 
echo ; 
FUNC_create_alias_for_python_programs  ; 
echo ">> REPO PATHS REPLACEMENTS BELOW (IF ANY) ... "; 

####
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
echo ">> LONGEST REPO PATH FOUND FOR CURRENT DIRECTORY ... (longer is better)" ;
echo ; 
path0=$(basename $(pwd)) ; 
path1=$(dirname $(pwd) | awk -F '/' '{print $NF}') ; 
path2=$(dirname $(pwd) | awk -F '/' '{print $(NF-1)}') ; 
path3=$(dirname $(pwd) | awk -F '/' '{print $(NF-2)}') ; 

echo "path0 = $path0" ; 
echo "path1 = $path1" ; 
echo "path2 = $path2" ; 
echo "path3 = $path3" ; 

for mypath in "$path0" "$path1" "$path2" "$path3" ; do 
    echo ; 
    myrepo_found=$(env | sd ' ' '' | grep -i 'repo' | grep -i "${mypath}$" | head -1) ;
    ## IF REPO IS FOUND AND NOT EMPTY
    if [ -n "$myrepo_found" ]; then 
        ## PRINT THE OUTPUTS WITH MODIFICATION
        echo "REPO FOUND FOR THIS => ($mypath) => $myrepo_found" ; 
        myrepo_replaceThis=$(echo "$myrepo_found" | awk -F '=' '{print $2}') ;
        myrepo_replaceTo=$(echo "$myrepo_found" | awk -F '=' '{print $1}') ;
        myrepo_replaceToNew="\"\$ ${myrepo_replaceTo}\"" ; 
        ##
        echo "##++++++++++++++++++++++++++++++++++++++++++" ; 
        echo ">> PRINTING POSSIBLE ALIASES MODIFICATION BASED ON THIS ...($mypath)" ; 
        echo "##++++++++++++++++++++++++++++++++++++++++++" ; 
        cat "$TMPFILE_BASH" | sd "$myrepo_replaceThis" "${myrepo_replaceToNew}" ; 
        cat "$TMPFILE_PYTHON" | sd "$myrepo_replaceThis" "${myrepo_replaceToNew}" ; 
    else
        ## SIMPLY PRINT THE OUTPUTS WITHOUT MODIFICATION
        echo "##++++++++++++++++++++++++++++++++++++++++++" ; 
        echo ">> PRINTING RAW ALIASES WITHOUT MODIFICATION ..." ; 
        echo "##++++++++++++++++++++++++++++++++++++++++++" ; 
        cat "$TMPFILE_BASH"  ;
        cat "$TMPFILE_PYTHON" ; 
    fi    
done 

