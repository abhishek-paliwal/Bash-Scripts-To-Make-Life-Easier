#/bin/bash

WORKDIR="$DIR_Y" ;

################################################################################ 
function func_fix_this_empty_image_link () {
    inFile="$1" ; 
    mdfile_to_fix="$2" :
    ##
    for myline in $(cat $inFile); do 
        echo "$myline" ; 
        ## extract the image part, then its basename
        image="$(echo $myline | sed 's|\!\[\](\(.*\))|\1|g' | sd ' ' '' )"  ;
        image_basename_words=$(basename "$image" | sd '(.jpg|.jpeg|.png)' '' | sd '-' ' ' ) ; 
        image_basename_words_final="Image - $image_basename_words" ;
        #echo "$image_basename_words_final" ; 
        #echo "$image//"
        myline_replace=$(echo $myline | sed -e 's|\!|\\!|g' -e 's|\[|\\[|g' -e 's|\]|\\]|g') ;
        #echo "$myline_replace" ;
        #sed -i '' "s|$myline_replace|\!\[$image_basename_words_final\]($image)|g" $mdfile_to_fix ;
    done 
}
################################################################################ 

inDir="$REPO_MGGK/content/" ;
tmpFile="$WORKDIR/_tmp0.txt" ;
count=0
## Fix all files where empty image markdown links found.
for mdfile_to_fix in $(grep -irl '\!\[\]' "$inDir" ) ; do
    ((count++)) ;
    echo; echo ">> Finding empty links and fixing // current file => $count" ; 
    ##
    find_all_empty_links="$(grep -irh '\!\[\]' $mdfile_to_fix)" ; 
    #echo "$find_all_empty_links" ; 
    echo "$find_all_empty_links" > "$tmpFile" ;
    ##
    func_fix_this_empty_image_link "$tmpFile" "$mdfile_to_fix" ;
done
