#/bin/bash

#########################################################################
## THIS PROGRAM SPLITS THE MGGK DATA CSV FILE INTO PIECES CORRESPONDING TO ONE FILE PER CSV ROW.
## THIS MEANS THAT YOU GET ONE FILE PER RECIPE.
## DATE: 2024-03-08
## BY: PALI
#########################################################################

alias split_data_mggk_csv_frontmatter_data_into_individual_recipe_txtfiles

tmpfile99="$DIR_Y/_tmpfile99.txt" ; 
tmpdir99="$DIR_Y/_tmpdir99_with_split_files" ;  
mkdir -p "$tmpdir99" ; 
cd $tmpdir99 ; 

# use miller to display csv to xtab, then save it
miller_mlr_print_csv_to_xtab_for_vertical_data > $tmpfile99 ;

# finally split the saved file into pieces whenever 'toc  ' is found.  
csplit $tmpfile99 '/toc  /' '{*}' ;

## rename to txt
for x in $(fd -u -tf --search-path="$tmpdir99") ; do mv "$x" "$x.txt" ; done 

