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
    tmpFile="$WORKDIR/_tmp0.txt" ;
    inDir="$REPO_MGGK/content" ;
    ##
    echo ">> Creating temporary md files without any frontmatter and youMayAlsoLike blocks ..." ; 
    count=0;
    TOTAL_COUNT=$(fd -I --search-path="$inDir" -e md | wc -l | sd ' ' '') ; 
    ##
    for x in $(fd -I --search-path="$inDir" -e md) ; do 
    ####
        ((count++)) ;
        echo ">> CURRENT FILE => $count of $TOTAL_COUNT" ;
        x_basename=$(basename $x | cut -d'T' -f2) ; 
        ## step1 = delete all youMayAlsoLike section between two phrases and save the rest
        sed "/{{< mggk-YouMayAlsoLike-HTMLcode >}}/,/{{< \/mggk-YouMayAlsoLike-HTMLcode >}}/d" $x > $tmpFile ;
        ## step2 = delete full frontmatter section from step1 and save the rest
        outFile="$WORKDIR/$count-MYFILE-$x_basename" ;
        myvar="^---" ; 
        sed "/$myvar/,/$myvar/d" "$tmpFile" > "$outFile" ;
    ####
    done
}
###########################################
function func_step2_find_all_internal_inbound_links_for_each_mdfile_url () {
    ##
    inFile="$1" ;
    PREFIX="$2" ;
    outFile="$WORKDIR/_output_FOUND_MDFILES_WITH_GIVEN_MGGK_URL-$PREFIX.txt" ;
    outFile1="$WORKDIR/_output_FOUND_MDFILES_WITH_GIVEN_MGGK_URL_COUNTS_ONLY-$PREFIX.txt" ;
    inDir="$WORKDIR" ;
    ##
    tmpFile1="$WORKDIR/_tmp1.txt" ;
    ##
    echo "## LIST OF FOUND MD FILES CONTAINING GIVEN_URL" > $outFile ;
    echo > $tmpFile1 ;
    ##
    TOTAL_COUNT=$(cat $inFile | wc -l | sd ' ' '') ;
    count=0;
    for thisUrl in $(cat $inFile | sd 'https://www.mygingergarlickitchen.com' '' | sd '^/$' '') ; do 
    ####
        ((count++)) ;
        echo "CURRENT FILE COUNT => $count of $TOTAL_COUNT // PREFIX_VAR = $PREFIX" ;
        echo >> $outFile ;
        echo "##------------------------------------------------------------------------------" >> $outFile ;
        echo "$count = URL = $thisUrl" >> $outFile ;
        ag -l --markdown "$thisUrl" "$inDir" >> $outFile ;
        ####
        ## list the counts for files found for given url
        myFileCount=$(ag -l --markdown "$thisUrl" "$inDir" | wc -l ) ;
        echo "$myFileCount // URL = $thisUrl" >> $tmpFile1 ;
    ####
    done
    ## Sorting the counts output
    echo "## NUMBER OF FOUND MD FILES CONTAINING GIVEN_URL // GIVEN_URL" > $outFile1 ;
    sort "$tmpFile1" >> $outFile1 ;
}
###########################################
function func_step3_find_all_internal_outbound_links_in_each_mdfile () {
    ##
    inFile="$1" ;
    PREFIX="$2" ;
    outFile="$WORKDIR/_output_FOUND_OUTBOUND_LINKS-$PREFIX.txt" ;
    outFile1="$WORKDIR/_output_FOUND_OUTBOUND_LINKS_COUNTS_ONLY-$PREFIX.txt" ;
    inDir="$WORKDIR" ;
    ##
    tmpFile1="$WORKDIR/_tmp1.txt" ;
    ##
    echo "## LIST OF INTERNAL OUTBOUND LINKS FOUND IN MD FILES" > $outFile ;
    echo > $tmpFile1 ;
    ##
    TOTAL_COUNT=$(cat $inFile | wc -l | sd ' ' '') ;
    count=0;
    for thisUrl in $(cat $inFile | sd 'https://www.mygingergarlickitchen.com' '' | sd '^/$' '') ; do 
    ####
        ((count++)) ;
        echo "CURRENT FILE COUNT => $count of $TOTAL_COUNT // PREFIX_VAR = $PREFIX" ;
        echo >> $outFile ;
        ##
        ag -l --markdown "$thisUrl" "$inDir" > $tmpFile1 ;
        ##
        for foundMDfile in $(cat $tmpFile1) ; do 
            foundMDfile_base=$(basename $foundMDfile) ;
            echo "$foundMDfile_base=$thisUrl" >> $outFile ;
        done    
    ####
    done
    ## Sorting the counts output
    echo "## NUMBER OF INTERNAL OUTBOUND LINKS FOUND IN MD FILES" > $outFile1 ;
    cat $outFile | grep -iv '#' |cut -d'=' -f1 | sort | uniq -c | sort -n >> $outFile1
}
##############################################################################
################################################################################

#######
## CALLING FUNC_1
func_step1_delete_frontmatter_and_youmayalsolike_blocks_from_mdfiles ;
#######
## CALLING FUNC_2
FILEDIR="/Users/abhishek/Dropbox/Public/_TO_SYNC_downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs" ;
inFile1="$FILEDIR/mggk_summary_cloudflare_AllValidRecipesUrls.txt" ;
inFile2="$FILEDIR/mggk_summary_cloudflare_AllValidNONRecipesUrls.txt" ;
prefix1="VALID-RECIPES" ;
prefix2="VALID-NON-RECIPES" ;
##
func_step2_find_all_internal_inbound_links_for_each_mdfile_url "$inFile1" "$prefix1" ;
func_step2_find_all_internal_inbound_links_for_each_mdfile_url "$inFile2" "$prefix2" ;
#######
## CALLING FUNC_3
func_step3_find_all_internal_outbound_links_in_each_mdfile "$inFile1" "$prefix1" ;
func_step3_find_all_internal_outbound_links_in_each_mdfile "$inFile2" "$prefix2" ;
#######

##############################################################################
## SUMMARY OF OUTPUTS
################################################################################
echo ">> WORD-COUNTS FOR CREATED OUTPUTS:" ;
fd -I --search-path="$WORKDIR" '_output' -x wc -l {} ;