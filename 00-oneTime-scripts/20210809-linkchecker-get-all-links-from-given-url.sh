#/bin/bash


##################################################################################

function FUNC_run_linkchecker_for_this_url () {
    inFile="$1"
    outFile="linkchecker-$inFile-links.txt" ;
    tmpFile="tmp.txt" ;
    echo; 
    echo "$inFile // $outFile"
    linkchecker --verbose -F text/"$tmpFile" "$inFile" ;
    ##
    ag --nonumber 'real url' $tmpFile | grep -ivE '(png|jpg|js|css|svg|xml|html|wa.me|facebook|instagram|pinterest)' | grep 'myginger' | sd -f i 'real url' '' | sd ' ' '' | sort -u > $outFile ;
    ## 
    wc -l $outFile ;
}
##################################################################################


echo "Enter full URL you want to extract all links for: " ; 
read myURL ; 


FUNC_run_linkchecker_for_this_url "$myURL"
