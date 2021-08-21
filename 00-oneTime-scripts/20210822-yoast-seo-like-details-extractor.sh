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
function func_step1_delete_frontmatter_and_youmayalsolike_blocks_from_mdfiles () {
    outFile="$WORKDIR/_tmp0.txt" ;
    ##
    count=0;
    for x in $(fd -I --search-path="$REPO_MGGK/content" -e md) ; do 
    ####
        ((count++)) ;
        x_basename=$(basename $x | cut -d'T' -f2) ; 
        ## step1 = delete all youMayAlsoLike section between two phrases and save the rest
        sed "/{{< mggk-YouMayAlsoLike-HTMLcode >}}/,/{{< \/mggk-YouMayAlsoLike-HTMLcode >}}/d" $x > $outFile ;
        ## step2 = delete full frontmatter section from step1 and save the rest
        myvar="^---" ; 
        sed "/$myvar/,/$myvar/d" "$outFile" > "$WORKDIR/$count-MYFILE-$x_basename" ;
    ####
    done
}
####
function func_step2_find_all_mdfiles_containing_given_mggk_url () {
    ## 
    inFile="/Users/abhishek/Dropbox/Public/_TO_SYNC_downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs/mggk_summary_cloudflare_AllValidSiteUrls.txt" ;
    outFile="$WORKDIR/_output_MDFILES_WITH_GIVEN_MGGK_URL.txt" ;
    outFile1="$WORKDIR/_output_MDFILES_WITH_GIVEN_MGGK_URL_COUNTS_ONLY.txt" ;
    #inDir="$REPO_MGGK/content" ;
    inDir="$WORKDIR" ;
    ##
    echo > $outFile ;
    echo > $outFile1 ;
    count=0;
    for thisUrl in $(cat $inFile | sd 'https://www.mygingergarlickitchen.com' '' | sd '^/$' '') ; do 
    ####
        ((count++)) ;
        echo >> $outFile ;
        echo "################################################################################" >> $outFile ;
        echo "$count = URL = $thisUrl" >> $outFile ;
        ag -l --markdown "$thisUrl" "$inDir" >> $outFile ;
        ## count the number of files found for given url
        myFileCount=$(ag -l --markdown "$thisUrl" "$inDir" | wc -l ) ;
        echo "$myFileCount // URL = $thisUrl" >> $outFile1 ;
    ####
    done
}
##############################################################################
################################################################################

func_step1_delete_frontmatter_and_youmayalsolike_blocks_from_mdfiles

func_step2_find_all_mdfiles_containing_given_mggk_url
