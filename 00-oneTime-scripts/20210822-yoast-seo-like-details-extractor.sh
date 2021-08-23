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
    ## CREATED ON: 2021-08-22
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
##
PREFIX_RECIPE="VALIDRECIPE" ;
PREFIX_NONRECIPE="NONRECIPE" ;
##############################################################################

time_taken="$WORKDIR/tmp-time-taken-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "$(date) = START-TIME" > $time_taken

##############################################################################
##############################################################################
function func_step1_delete_frontmatter_and_youmayalsolike_blocks_from_mdfiles () {
    echo ">> Creating temporary md files without any frontmatter and youMayAlsoLike blocks ..." ; 
    tmpFile="$WORKDIR/_tmp0.txt" ;
    inDir="$REPO_MGGK/content" ;
    TOTAL_COUNT=$(fd -I --search-path="$inDir" -e md | wc -l | sd ' ' '') ; 
    count=0;
    ####
    for x in $(fd -I --search-path="$inDir" -e md) ; do 
        ((count++)) ;
        ## STEP1 = delete all youMayAlsoLike section between two phrases and save the rest
        sed "/{{< mggk-YouMayAlsoLike-HTMLcode >}}/,/{{< \/mggk-YouMayAlsoLike-HTMLcode >}}/d" $x > $tmpFile ;
        ##
        ## STEP2 = delete full frontmatter section from STEP1 and save the rest
        countPadded=$(printf "%05d" "$count") ; ## pad with leading zeros
        x_basename=$(basename $x) ; 
        ## Assign different output filenames valid recipe and nonrecipe files
        ## If variable is empty = nonrecipe file, else validrecipe file
        isRecipeOrNot=$(ag -l --markdown 'mggk-INSERT-RECIPE-HTML-BLOCK' $x) ;
        if [ -z "$isRecipeOrNot" ] ; then
            echo ">> CURRENT FILE => $count of $TOTAL_COUNT // $PREFIX_NONRECIPE" ;
            outFile="$WORKDIR/$countPadded-$PREFIX_NONRECIPE-$x_basename" ;
        else
            echo ">> CURRENT FILE => $count of $TOTAL_COUNT // $PREFIX_RECIPE" ;
            outFile="$WORKDIR/$countPadded-$PREFIX_RECIPE-$x_basename" ;
        fi
        ## deleting the actual frontmatter
        myvar="^---" ; 
        sed "/$myvar/,/$myvar/d" "$tmpFile" > "$outFile" ;
    done
    ####
}
###########################################
function func_step2_find_all_internal_inbound_links_for_each_mdfile_url () {
    ##
    inFile="$1" ;
    PREFIX="$2" ;
    inDir="$WORKDIR" ;
    inbound_outFile="$WORKDIR/_output-$PREFIX-FOUND_INBOUND_LINKS.txt" ;
    inbound_outFile1="$WORKDIR/_output-$PREFIX-FOUND_INBOUND_LINKS_COUNTS.txt" ;
    ##
    tmpFile1="$WORKDIR/_tmp1.txt" ;
    echo > $tmpFile1 ;
    ##
    inbound_zeroFile="$WORKDIR/_tmp_ZEROFILE.txt"
    echo > $inbound_zeroFile ;
    ##
    echo "## LIST OF FOUND INTERNAL INBOUND LINKS FOR URLS IN MD FILES" > $inbound_outFile ;
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
            echo "0 // $thisUrl" >> $inbound_zeroFile ;
        else
        ##
            for foundMDfile in $(cat $tmpFile1) ; do 
                foundMDfile_base=$(basename $foundMDfile) ;
                echo "$thisUrl=$foundMDfile_base" >> $inbound_outFile ;
            done    
        ##
        fi
    ####
    done
    ##-------------------------------------------
    ## INBOUND => Sorting the counts output
    echo "## NUMBER OF FOUND INTERNAL INBOUND LINKS FOR URLS IN MD FILES // $PREFIX" > $inbound_outFile1 ;
    cat $inbound_zeroFile >> $inbound_outFile1 ;
    cat $inbound_outFile | grep -iv '#' | cut -d'=' -f1 | sort | uniq -c | sort -n | awk '{print $1 " // " $2}' >> $inbound_outFile1 ;
    ##--------------------------------------------
}
###########################################
function func_step3_find_all_internal_outbound_links_in_each_mdfile () {
    ##
    inFile="$1" ;
    PREFIX="$2" ;
    inDir="$WORKDIR" ;
    outbound_outFile="$WORKDIR/_output-$PREFIX-FOUND_OUTBOUND_LINKS.txt" ;
    outbound_outFile1="$WORKDIR/_output-$PREFIX-FOUND_OUTBOUND_LINKS_COUNTS.txt" ;
    ##
    tmpFile1="$WORKDIR/_tmp1.txt" ;
    ##
    echo "## LIST OF INTERNAL OUTBOUND LINKS FOUND IN MD FILES" > $outbound_outFile ;
    echo > $tmpFile1 ;
    ##
    TOTAL_COUNT=$(cat $inFile | wc -l | sd ' ' '') ;
    count=0;
    ####
    for thisUrl in $(cat $inFile | sd 'https://www.mygingergarlickitchen.com' '' | sd '^/$' '') ; do 
        ((count++)) ;
        echo "CURRENT FILE COUNT => $count of $TOTAL_COUNT // PREFIX_VAR = $PREFIX" ;
        echo >> $outFile ;
        ## Find all mdfiles with given url
        ag -l --markdown "$thisUrl" "$inDir" > $tmpFile1 ;
        ##
        for foundMDfile in $(cat $tmpFile1) ; do 
            foundMDfile_base=$(basename $foundMDfile) ;
            echo "$foundMDfile_base=$thisUrl" >> $outbound_outFile ;
        done
        ##    
    done
    ####
    ##--------------------------------------
    ## OUTBOUND => Sorting the counts output
    ## Adding all filenames to the list, else the final counts won't list the 
    ## files with zero outbound links.
    tmpFile2="$WORKDIR/_tmp2.txt" ;
    echo > $tmpFile2 ;
    for x in $(fd -I -e md --search-path="$WORKDIR") ; do 
        basename $x >> $tmpFile2 ;
    done
    ## Getting first field
    cat $outbound_outFile | grep -iv '#' | cut -d'=' -f1 >> $tmpFile2 ;
    tmpFile3="$WORKDIR/_tmp3.txt" ;
    echo > $tmpFile3 ;
    cat $tmpFile2 | sort | uniq -c | sort -n >> $tmpFile3 ;
    ## Subtract one from the count in each line and final saving
    echo "## NUMBER OF INTERNAL OUTBOUND LINKS FOUND IN MD FILES // $PREFIX" > $outbound_outFile1 ;
    cat $tmpFile3 | grep "$PREFIX" | awk '{print ($1-1) " // " $2}' >> $outbound_outFile1
    ##--------------------------------------
}
##############################################################################
################################################################################

FILEDIR="/Users/abhishek/Dropbox/Public/_TO_SYNC_downloads.concepro.com/dropbox-public-files/LCE/_pali_github_scripts_outputs" ;
inFile1="$FILEDIR/mggk_summary_cloudflare_AllValidRecipesUrls.txt" ;
inFile2="$FILEDIR/mggk_summary_cloudflare_AllValidNONRecipesUrls.txt" ;

#######
## CALLING FUNC_1
func_step1_delete_frontmatter_and_youmayalsolike_blocks_from_mdfiles ;
#######
## CALLING FUNC_2
#func_step2_find_all_internal_inbound_links_for_each_mdfile_url "$inFile2" "$PREFIX_NONRECIPE" ;
#func_step2_find_all_internal_inbound_links_for_each_mdfile_url "$inFile1" "$PREFIX_RECIPE" ;
#######
## CALLING FUNC_3
func_step3_find_all_internal_outbound_links_in_each_mdfile "$inFile2" "$PREFIX_NONRECIPE" ;
#func_step3_find_all_internal_outbound_links_in_each_mdfile "$inFile1" "$PREFIX_RECIPE" ;
#######

##############################################################################
## SUMMARY OF OUTPUTS
################################################################################
echo ">> WORD-COUNTS FOR CREATED OUTPUTS:" ;
fd -I --search-path="$WORKDIR" '_output' -x wc -l {} ;

################################################################################
############################### PROGRAM ENDS ###################################
################################################################################
echo "$(date) = END-TIME" >> $time_taken
cat $time_taken
