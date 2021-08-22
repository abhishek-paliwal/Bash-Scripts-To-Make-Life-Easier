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
        countPadded=$(printf "%05d" "$count") ; ## pad with leading zeros
        ##
        echo ">> CURRENT FILE => $count of $TOTAL_COUNT" ;
        x_basename=$(basename $x | cut -d'T' -f2) ; 
        ## step1 = delete all youMayAlsoLike section between two phrases and save the rest
        sed "/{{< mggk-YouMayAlsoLike-HTMLcode >}}/,/{{< \/mggk-YouMayAlsoLike-HTMLcode >}}/d" $x > $tmpFile ;
        ## step2 = delete full frontmatter section from step1 and save the rest
        outFile="$WORKDIR/$countPadded-MYFILE-$x_basename" ;
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
    inbound_outFile="$WORKDIR/_output-$PREFIX-FOUND_INBOUND_LINKS.txt" ;
    inbound_outFile1="$WORKDIR/_output-$PREFIX-FOUND_INBOUND_LINKS_COUNTS.txt" ;
    inbound_zeroFile="$WORKDIR/_output-$PREFIX-FOUND_INBOUND_LINKS_ZEROFILE.txt"
    ##
    outbound_outFile="$WORKDIR/_output-$PREFIX-FOUND_OUTBOUND_LINKS.txt" ;
    outbound_outFile1="$WORKDIR/_output-$PREFIX-FOUND_OUTBOUND_LINKS_COUNTS.txt" ;
    inDir="$WORKDIR" ;
    ##
    tmpFile1="$WORKDIR/_tmp1.txt" ;
    ##
    echo "## LIST OF INTERNAL OUTBOUND LINKS FOUND IN MD FILES" > $outbound_outFile ;
    echo "## LIST OF INTERNAL INBOUND LINKS FOUND IN MD FILES" > $inbound_outFile ;
    echo > $tmpFile1 ;
    echo > $inbound_zeroFile ;
    ##
    TOTAL_COUNT=$(cat $inFile | wc -l | sd ' ' '') ;
    count=0;
    for thisUrl in $(cat $inFile | sd 'https://www.mygingergarlickitchen.com' '' | sd '^/$' '') ; do 
    ####
        ((count++)) ;
        echo "CURRENT FILE COUNT => $count of $TOTAL_COUNT // PREFIX_VAR = $PREFIX" ;
        echo >> $outFile ;
        ## Find all mdfiles with given url
        ag -l --markdown "$thisUrl" "$inDir" > $tmpFile1 ;
        NUM_LINES_FOUND=$(cat $tmpFile1 | wc -l | sd ' ' '') ;
        ## If zero mdfiles found
        if [ "$NUM_LINES_FOUND" == "0" ] ; then
            echo "0 $thisUrl" >> $inbound_zeroFile ;
        else
        ##
            for foundMDfile in $(cat $tmpFile1) ; do 
                foundMDfile_base=$(basename $foundMDfile) ;
                echo "$foundMDfile_base=$thisUrl" >> $outbound_outFile ;
                echo "$thisUrl=$foundMDfile_base" >> $inbound_outFile ;
            done    
        ##
        fi
    ####
    done
    ## OUTBOUND => Sorting the counts output
    echo "## NUMBER OF INTERNAL OUTBOUND LINKS FOUND IN MD FILES" > $outbound_outFile1 ;
    cat $outbound_outFile | grep -iv '#' |cut -d'=' -f1 | sort | uniq -c | sort -n >> $outbound_outFile1
    ## INBOUND => Sorting the counts output
    echo "## NUMBER OF INTERNAL INBOUND LINKS FOUND IN MD FILES" > $inbound_outFile1 ;
    cat $inbound_zeroFile >> $inbound_outFile1 ;
    cat $inbound_outFile | grep -iv '#' |cut -d'=' -f1 | sort | uniq -c | sort -n >> $inbound_outFile1 ;
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
prefix2="NON-RECIPES" ;
##
#func_step2_find_all_internal_inbound_links_for_each_mdfile_url "$inFile1" "$prefix1" ;
#func_step2_find_all_internal_inbound_links_for_each_mdfile_url "$inFile2" "$prefix2" ;
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