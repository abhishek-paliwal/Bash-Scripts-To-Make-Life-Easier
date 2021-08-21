#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## USAGE:
    #### > bash $THIS_SCRIPT_NAME
    ################################################################################
    ## This Program Is Inspired By The Tools Present In The Yoast SEO Wordpress 
    ## Plugin. This Program Produces Various Outputs Good For The Seo Practices. 
    ## Try To Fix The Existing Mggk Posts Using Those Outputs.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2021-08-21
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 
##############################################################################

##############################################################################
##############################################################################
function func_remove_frontmatter_and_extract_youmayalsolike_blocks_from_mdfiles () {
    outFile="$WORKDIR/tmp1.txt"
    echo > $outFile
    #fd -I --search-path="$REPO_MGGK/content" -e md -x sed -n '/{{< mggk-YouMayAlsoLike-HTMLcode >}}/,/{{< \/mggk-YouMayAlsoLike-HTMLcode >}}/p' >> $outFile
    ##
    count=0;
    for x in $(fd -I --search-path="$REPO_MGGK/content" -e md) ; do 
    ((count++)) ;
    x_base=$(basename $x | cut -d'T' -f2) ; 
    ##
    sed "/{{< mggk-YouMayAlsoLike-HTMLcode >}}/,/{{< \/mggk-YouMayAlsoLike-HTMLcode >}}/d" $x > $WORKDIR/_t.txt ;
    ##
    myvar="^---" ; 
    sed "/$myvar/,/$myvar/d" $WORKDIR/_t.txt > "$WORKDIR/$count-XYZ-$x_base" ;
    ####
    done
}
####
function func_find_all_orphaned_files_from_mdfiles () {
    inFile="/Users/abhishek/Dropbox/Public/_TO_SYNC_downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs/mggk_summary_cloudflare_AllValidSiteUrls.txt" ;
    outFile="$WORKDIR/tmp3.txt" ;
    #inDir="$REPO_MGGK/content" ;
    inDir="$WORKDIR" ;
    ##
    count=0;
    for x in $(cat $inFile | sd 'https://www.mygingergarlickitchen.com' '' | sd '^/$' '') ; do 
        ((count++)) ;
        echo >> $outFile ;
        echo "################################################################################" >> $outFile ;
        echo "$count = URL = $x" >> $outFile ;
        grep -irl "$x" "$inDir" >> $outFile ;
    ##
    done
}
##############################################################################
################################################################################

func_remove_frontmatter_and_extract_youmayalsolike_blocks_from_mdfiles

func_find_all_orphaned_files_from_mdfiles
