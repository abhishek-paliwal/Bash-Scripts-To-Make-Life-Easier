
#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;


##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 
##
PREFIX_ALLMGGKURLS="ALLMGGKURLS" ;
PREFIX_RECIPE="VALIDRECIPE" ;
PREFIX_NONRECIPE="NONRECIPE" ;

## THIS PROGRAM FINDS THOSE MDFILES WHERE THE MAIN CONTENT IS IN HTML FORMAT
## IT THEN CONVERTS IT INTO MARKDOWN WITH PROPER FORMATTING FOR IMAGES TOO.

#myDir="$REPO_MGGK/content/" ;
myDir="$REPO_MGGK/content/_FIXED/top-301-400" ;

## all recipe files with where img tag appears
#for x in $(ag -l 'preptime:'); do ag -l '<img' $x ; done | nl
## all non-recipe files where img tag appears
echo ">> Gathering all files of interest ..." ; 
files_of_interest="$WORKDIR/_tmp_files_of_interest.txt" ;
excludePaths="(/99_collections/|/pages/)" ;
#taking recipe files
for x in $(ag -l 'preptime:' "$myDir" | grep -iv "$excludePaths" ); do ag -l '<img' $x ; done > "$files_of_interest"
#taking non-recipe files
#for x in $(ag -L 'preptime:' "$myDir" | grep -ivE "$excludePaths" ); do ag -l '<img' $x ; done > "$files_of_interest"

################################################################################
function func_extract_and_concatenate_frontmatter_and_bottom_content_after_modification () {
    echo ">> Creating temporary md files without any frontmatter ..." ; 
    tmpFile="$WORKDIR/_tmp0.txt" ;
    inDir="$myDir" ;
    TOTAL_COUNT=$(cat $files_of_interest | wc -l | sd ' ' '') ; 
    count=0;
    ####
    for x in $(cat $files_of_interest) ; do 
        ((count++)) ;
        #cat $x > $tmpFile ;
        ## STEP1 = first extract, then delete all youMayAlsoLike section between two phrases and save the rest
        saveYouMayLinksFile="$WORKDIR/_tmp_YouMayLinks.txt" ;
        #extraction
        sed -n "/{{< mggk-YouMayAlsoLike-HTMLcode >}}/,/{{< \/mggk-YouMayAlsoLike-HTMLcode >}}/p" $x > $saveYouMayLinksFile ;
        #deletion
        sed "/{{< mggk-YouMayAlsoLike-HTMLcode >}}/,/{{< \/mggk-YouMayAlsoLike-HTMLcode >}}/d" $x > $tmpFile ;
        ##
        ## STEP2 = delete full frontmatter section from STEP1 and save the rest
        countPadded=$(printf "%05d" "$count") ; ## pad with leading zeros
        x_basename=$(basename $x) ; 
        ## Assign different output filenames valid recipe and nonrecipe files
        ## If variable is empty = nonrecipe file, else validrecipe file
        isRecipeOrNot=$(ag -l --markdown 'mggk-INSERT-RECIPE-HTML-BLOCK' $x) ;
        if [ -z "$isRecipeOrNot" ] ; then
            PREFIX="$PREFIX_NONRECIPE"
        else
            PREFIX="$PREFIX_RECIPE"
        fi
        echo ">> CURRENT FILE => $count of $TOTAL_COUNT // $PREFIX // $x" ;
        outFile="$WORKDIR/$countPadded-$PREFIX-$x_basename" ;
        ##
        ## deleting the actual frontmatter
        outFile_front="$outFile-FRONTMATTER.txt" ;
        outFile_bottom="$outFile-BOTTOMCONTENT.txt" ;
        ##
        ## STEP 1 = extract frontmatter to one file and save the main content to another file
        myvar="^---" ; 
        sed -n "/$myvar/,/$myvar/p" "$tmpFile" > "$outFile_front" ;
        sed "/$myvar/,/$myvar/d" "$tmpFile" > "$outFile_bottom" ;
        #######
        ## STEP 2 = convert step1 output to proper html content using pandoc
        outFileHtml="$outFile_bottom.html" ;
        pandoc --wrap=none --from=markdown --to=html "$outFile_bottom" -o "$outFileHtml" ; 
        #######
        ## step 3 = convert step2 output to proper markdown content using pandoc
        outFileTemporary="$outFileHtml.TEMPORARY.txt" ;
        pandoc_filter_filepath="$REPO_SCRIPTS_MGGK_PROJECTS/_convert_old_html_formatted_mdfiles_to_new_markdown_format/pandoc-filter-remove-html-attributes.lua" ;
        pandoc --wrap=none --lua-filter=$pandoc_filter_filepath --from=html --to=markdown_strict "$outFileHtml" -o "$outFileTemporary" ;
        ####### 
        ## step 4 = concatenate frontmatter and bottom content in a single file
        outputBaseDir="$(basename $(dirname $x))" ; 
        outputDirFinal="$WORKDIR/_FINAL_OUTPUTS/$outputBaseDir" ;
        mkdir -p $outputDirFinal ; 
        outFileFinal="$outputDirFinal/$(basename $x)" ;
        ########
        cat "$outFile_front" > $outFileFinal
        echo "" >> $outFileFinal
        echo "<!--more-->" >> $outFileFinal
        echo "" >> $outFileFinal
        ##====
        ReplaceThis1="\[<img size-full\" src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/2016/06/go-to-recipe-button.png\" alt=\"Go Directly to Recipe\" width=\"267\" height=\"40\">\](#recipe-here)" ; 
        ##
        ReplaceThis2="\[\!\[Go Directly to Recipe\](https://www.mygingergarlickitchen.com/wp-content/uploads/2016/06/go-to-recipe-button.png)\](#recipe-here)" ;
        ##
        ReplaceThis3="{{< figure src=\"https://www.mygingergarlickitchen.com/wp-content/uploads/2016/06/go-to-recipe-button.png\" alt=\"Go Directly to Recipe\" width=\"267\" height=\"40\" link=\"#recipe-here\" >}}" ; 
        ##
        ReplaceTo="{{< mggk-button-block-for-recipe-here-link-NO-VIDEO >}}" ;
        ##====
        cat "$outFileTemporary" | sd '&lt;' '<' | sd '&gt;' '>' | sd '(“|”)' '"' | sed -e "s|$ReplaceThis1|$ReplaceTo|g" -e "s|$ReplaceThis2|$ReplaceTo|g" -e "s|$ReplaceThis3|$ReplaceTo|g"  >> $outFileFinal ;
        ########
        ## Adding all youmayalsolike links back
        echo "" >> $outFileFinal ;
        cat $saveYouMayLinksFile >> $outFileFinal ;
    done
    ####
}
################################################################################

## CALLING FUNC_1
func_extract_and_concatenate_frontmatter_and_bottom_content_after_modification ;
