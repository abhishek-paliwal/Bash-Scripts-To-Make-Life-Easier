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
TMPFILE_MDFILEPATHS="$WORKDIR/_step1_mdfilepaths.txt" ; 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_SOURCE_SCRIPTS () {
    ####
    source "$REPO_SCRIPTS_MINI/00200a_source_script_to_print_fancy_divider.sh" ;
}
FUNC_SOURCE_SCRIPTS ; 
palidivider ; 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_step1_get_md_filepaths (){
    INDIR="$REPO_MGGK/content/" ; 
    OUTFILE="$TMPFILE_MDFILEPATHS" ; 
    ag '.jpg' "$INDIR" | grep -i '.md' | grep -ivE 'featured_image|{{|img src|recipe_code_image|blog/99_|pages/' | awk -F ':' '{print $1}' | sort | uniq > "$OUTFILE" ; 
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_step2_read_md_filepaths_and_get_imagepaths (){
    INFILE="$TMPFILE_MDFILEPATHS" ;
    OUTFILE="$WORKDIR/" ; 
    count=0; 
    for filepath in $(cat $INFILE) ; do 
        ((count++)) ;
        OUTDIR="$WORKDIR/$(basename $filepath)" ; 
        mkdir -p "$OUTDIR" ; ## create directory to store images
        OUTFILE="$OUTDIR/_tmp_images-$(basename $filepath).txt" ; 
        echo "##++++++++++++++++++++++++++++++++++" ; 
        echo ">> CURRENT FILE ($count) = $filepath" ; 
        replaceThis="https://www.mygingergarlickitchen.com/wp-content/uploads/" ; 
        replaceTo="/Users/abhishek/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/wp-content/uploads/" ; 
        grep -irh '!\[.*jpg' "$filepath" | grep -io 'http.*\.jpg' | sed "s|$replaceThis|$replaceTo|ig" > "$OUTFILE" ;
        ###### 
        ## get images
        echo "      >> Copying $(wc $OUTFILE) images to $OUTDIR " ; 
        for image_path in $(cat $OUTFILE) ; do cp "$image_path" "$OUTDIR/" ; done
        ######
    done 
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

FUNC_step1_get_md_filepaths
FUNC_step2_read_md_filepaths_and_get_imagepaths