#!/bin/bash

MAIN_DIR="$REPO_MGGK/static/wp-content/recipe-steps-images" ;
BASE_URL="https://www.mygingergarlickitchen.com/wp-content/recipe-steps-images" ;
MGGK_URL="https://www.mygingergarlickitchen.com" ;
MAIN_INDEX_HTMLFILE_URL="$BASE_URL/index-recipe-steps-images.html" ;
##
main_index_htmlfile="$REPO_MGGK/static/wp-content/recipe-steps-images/index-recipe-steps-images.html" ;
## Initializing main_index_htmlfile
echo "<h1>INDEX OF ALL HTML INDEX FILES IN DIR => recipe-steps-images</h1>" > $main_index_htmlfile ;
echo "Page Updated: $(date +%Y-%m-%d-T-%H:%M:%S)<hr>" >> $main_index_htmlfile ;

num_files=$(fd . $MAIN_DIR -t d | wc -l)
echo "<strong>Number of sub-directories found => $num_files</strong>" >> $main_index_htmlfile ;
echo "<hr>" >> $main_index_htmlfile ;

echo "<table border='0' width='100%'>" >> $main_index_htmlfile ;
echo "<tr> <td>#</td> <td>SUB-DIRECTORY (HTML INDEX FILE LINKED)</td> <td>NUMBER OF JPG IMAGES FOUND IN SUB-DIR</td> <td>GOTO MGGK PAGE</td> </tr>" >> $main_index_htmlfile ;

COUNT=1;
## Looping through all directories present in MAIN_DIR
for x in $(fd . $MAIN_DIR -t d); do 
##
    this_dirname="$(basename $x)" ;
    thisdir_index_htmlfile="index-$this_dirname.html" ; 
    htmlfile="$x/$thisdir_index_htmlfile" ; 

    #echo "$this_dirname // $htmlfile" ; 
    echo "  >> Creating HTML index file (recipe steps images directory) = $COUNT of $num_files " ;

    ## Initializing htmlfile
    num_files_in_this_dir=$(fd . $x -e jpg | wc -l) ;
    echo "<h1>JPG images in this sub-directory = $num_files_in_this_dir <pre>$this_dirname</pre></h1>" > $htmlfile ;
    echo "Page updated: The same time when the main index page is updated. (<a href='$MAIN_INDEX_HTMLFILE_URL'>See here</a>)<hr>" >> $htmlfile ;

    ## Making links for all jpg files in current directory
    for fname in $(fd . $x -e jpg); do 
        this_fname="$(basename $fname)" ;
        echo "<img src='$BASE_URL/$this_dirname/$this_fname' width='300px'>" >> $htmlfile ;
    done
    ##
    ## FINALLY APPENDING THIS DIRECTORY'S INDEX FILE LOCATION IN THE MAIN HTML FILE INDEX
    echo "<tr><td>$COUNT</td> <td><a target= '_blank' href='$BASE_URL/$this_dirname/$thisdir_index_htmlfile'>$this_dirname</a></td> <td>$num_files_in_this_dir</td> <td><a target='_blank' href='$MGGK_URL/$this_dirname/'>MGGK-PAGE-URL</a></td> </tr>" >> $main_index_htmlfile ;
    ##
    ((COUNT++)) ;
 ##
done

echo "</table>" >> $main_index_htmlfile ;
