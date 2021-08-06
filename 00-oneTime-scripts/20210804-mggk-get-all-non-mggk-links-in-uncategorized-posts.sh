#!/bin/bash
# Run as: bash this_program
################################################################################

THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
WORKDIR="$DIR_Y/_tmp_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ;
##
tmpFile1="$WORKDIR/tmp1.txt" ;
tmpFile2="$WORKDIR/tmp2.txt" ;
tmpFile3="$WORKDIR/tmp3.txt" ;
tmpFile4="$WORKDIR/tmp4.txt" ;
tmpFile5="$WORKDIR/tmp5.txt" ;
tmpFile6="$WORKDIR/tmp6.csv" ;
## making sure the files are generated only through this program
for x in $tmpFile1 $tmpFile2 $tmpFile3 $tmpFile4 $tmpFile5 $tmpFile6 ; do
    touch $x ; rm $x ;
done

################################################################################

################################################################################
function 1_FUNC_get_uncategorized_posts_before_2020 () { 
    ## getting all uncategorized md files paths with first published during 2013-2019
    inDir="$REPO_MGGK/content/" ;
    outFile="$tmpFile1" ;
    ag 'first_published' "$inDir" | ag uncategorized | awk '{print $2 "=" $1}' | sort -n | grep -ivE "(2021-|2020-)" | cut -d'=' -f2 | cut -d':' -f1 > $outFile
}

function 2_FUNC_get_mggkurls_from_mdfiles () { 
    ## get mggk urls from urls in those md files
    inFile="$tmpFile1" ;
    outFile="$tmpFile2" ;
    for x in $(cat $inFile); do 
        grep -i 'url:' $x | sd ' ' '' | sd 'url:' 'https://www.mygingergarlickitchen.com' >> $outFile
    done 
}

function 3_FUNC_find_non-mggk-hyperlinks-from-given-urls () { 
## finding non-mggk hyperlinks from given urls
inFile="$tmpFile2" ;
outFile="$tmpFile3" ;
outFile0="$tmpFile3-0" ;
if [ -f "$outFile0" ] ; then rm "$outFile0" ; fi ## delete if already exists
for URL in $(cat $inFile); do 
    ## get links with double quotes in href
    wget -q "$URL" -O - | grep -o -E 'href="([^"#]+)"' >> $outFile0
    #### get links with single quotes in href
    wget -q "$URL" -O - | grep -o -E "href='([^'#]+)'" >> $outFile0
    ## finding uniques non-mggk urls
    cat $outFile0 | sd 'href=' '' | sd '"' '' | sd "'" "" | grep -iv 'mygingergarlic' >> $outFile
done 
}

function 4_FUNC_discard_authority_domains_from_url_list () { 
    ## Discarding some authority domain urls to get the wanted ones
    inFile="$tmpFile3" ;
    outFile="$tmpFile4" ;
    cat $inFile | grep -ivE '(pinterest|wikipedia|wikihow|anupama|myginger.us|wa.me)' | grep -i 'http' | sd ' ' '' | sort -u > $outFile
}

function 5_FUNC_find_http_server_headers_for_urls () { 
    ## Finding the headers of the urls to see their http error status
    inFile="$tmpFile4" ;
    outFile="$tmpFile5" ;
    for x in $(cat $tmpFile4); do 
    echo "MYURL=$x" >> $outFile ;
    curl -I "$x" | grep 'HTTP/' >> $outFile ;
    done 
}

function 6_convert_server_header_rows_to_columns_as_csv () { 
    ## Finding the headers of the urls to see their http error status
    inFile="$tmpFile5" ;
    outFile="$tmpFile6" ;
    cat $inFile | tr '\n\r' ' ' | sd 'MYURL' '\nMYURL' | sd ',' '' |sd 'HTTP' ',HTTP' > $outFile
}

function 7_FUNC_convert_nofollowed_mggk_links_to_normal_in_md_files () {
for x in $(cat final.txt); do 
    echo "##------------------------------------------------------------------------------";
    echo ">> FILENAME = $x" ;
    # create the backup file of the original
    file_bak="$x.bak" ;
    mv "$x" "$file_bak" ;
    ## create the original file back
    cat $file_bak | sd 'rel="nofollow" href="https://www.mygingergarlic' 'href="https://www.mygingergarlic' > $x ;
done
}

function 8_FUNC_convert_client_links_to_nofollow_in_md_files_in_markdown_syntax () {
for myurl in $(cat t1.txt) ; do 
    echo "##------------------------------------------------------------------------------";
    echo "====> $myurl" ;
    for myfile in $(ag -l "$myurl" $REPO_MGGK/content/ ) ; do 
        echo "$myfile" ;
        file_bak="$myfile.bak" ;
        cp "$myfile" "$file_bak" ;
        ## create the original file back
        #ag "\($myurl" $myfile ;
        cat $file_bak | sd "\($myurl" "($myurl#NOFOLLOW" > $myfile ;
    done
done
}

################################################################################
################################################################################
## Calling all functions sequentially

1_FUNC_get_uncategorized_posts_before_2020
2_FUNC_get_mggkurls_from_mdfiles
3_FUNC_find_non-mggk-hyperlinks-from-given-urls
4_FUNC_discard_authority_domains_from_url_list
#5_FUNC_find_http_server_headers_for_urls
#6_convert_server_header_rows_to_columns_as_csv
#7_FUNC_convert_nofollowed_mggk_links_to_normal_in_md_files ;
#8_FUNC_convert_client_links_to_nofollow_in_md_files_in_markdown_syntax ;

 