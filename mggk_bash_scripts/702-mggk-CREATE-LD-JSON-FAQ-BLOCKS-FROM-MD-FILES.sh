#/bin/bash


HUGO_CONTENT_DIR="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/blog/100-new-HTML-JSON-format-recipes"
#HUGO_CONTENT_DIR="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content"

WORKDIR="$HOME_WINDOWS/Desktop/Y/_tmp_faqs" ;
mkdir $WORKDIR ;

## create tmp faqs file for cur
tmp_faqs_file="$WORKDIR/_tmp_faqs_file.txt"

##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
function extract_content_between_two_successive_faqs () {
################
    recipe_mdfile=$1 ;
    faqs_json_file=$2 ;
    recipe_file_basename=$(basename $recipe_mdfile) ;

    num_lines=$(cat $tmp_faqs_file | wc -l | bc -l) ; 
    number_of_faqs_found=$(($num_lines + 0)) ;
    
    echo "$number_of_faqs_found <= TOTAL FAQs FOUND" ; 

## Only progress if there are faqs found in recipe md file
if [ $number_of_faqs_found -ne 0 ] ; then
##+++++++++++++++++++++++++++++
    echo '<script type="application/ld+json">{"@context": "https://schema.org", "@type": "FAQPage", "mainEntity": [' > $faqs_json_file
    ####
    for x in $(seq 1 $num_lines) ; 
    do 
        this_faq=$(sed -n "${x}p" $tmp_faqs_file) ;
        next_faq=$(sed -n "$(($x + 1))p" $tmp_faqs_file) ;

        echo; 
        echo "THIS FAQ =$this_faq " ;
        echo "NEXT FAQ =$next_faq " ;

        faq_file_final="$WORKDIR/$recipe_file_basename-faq-${x}.FINAL" ;
        faq_file="$WORKDIR/$recipe_file_basename-faq-${x}.tmp1" ;
        sed -n "/$this_faq/,/$next_faq/p" $recipe_mdfile > $faq_file

        ## CHECK IF NEXT_FAQ VARIABLE HAS NON-ZERO STRING LENGTH
        ## THEN, DELETE THE LINES WITH HASHES AND SOME HUGO SPECIFIC CHARACTERS IN THEM.
        if [ -z "$next_faq" ] ; then
            cat $faq_file | sed "s/$this_faq//g" | grep -v '{{<' > $faq_file.tmp2 ;
        else 
            cat $faq_file | sed "s/$this_faq//g" | sed "s/$next_faq//g" | grep -v '{{<' > $faq_file.tmp2 ;
        fi

        ## DELETING EMPTY LINES
        awk 'NF' $faq_file.tmp2 > $faq_file.tmp3 ;
        ## PREFIXING EACH LINE WITH HTML LINE BREAK
        sed -e 's+^+<br><br>+' $faq_file.tmp3 > $faq_file_final

        echo " >> FAQ FILE CREATED =>  $faq_file_final" ;

        data_to_insert=$(cat $faq_file_final | sed 's+"+\\\"+ig' | sed 's/\*//ig' ) ;
        
        faq_name_modified=$(echo $this_faq | sed 's/## //ig')

cat << EOF >> $faqs_json_file
{"@type": "Question",
"name": "$faq_name_modified",
"acceptedAnswer": {
    "@type": "Answer",
    "text": "$data_to_insert"
}}
EOF

## APPENDING THE COMMA ON A SEPARATE LINE, BECAUSE
## WE WILL NEED TO REPLACE IT IN THE LAST JSON LINE OF THIS FILE
printf "," >> $faqs_json_file ;
##+++++++++++++++++++++++++++++
    done   
################    
    echo "]} </script>" >> $faqs_json_file

    ## FINALLY CHANGING THE LAST LINE TO MAKE IT VALID JSON FILE
    cat $faqs_json_file  | sed s+,]}+]}+ig > $faqs_json_file 
fi
}
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------

for recipe_mdfile in $(find $HUGO_CONTENT_DIR/ -type f -name '*.md' ) ;
do
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    faqs_json_file="$(basename $recipe_mdfile)-faq.json" ;

    echo; 
    echo "##------------------------------------------------------------------------------" ;
    echo ">>>> CURRENT RECIPE MD FILE = > $(basename $recipe_mdfile)" ; echo; 
    grep -ir '^##.*?' $recipe_mdfile > $tmp_faqs_file
        
    ## CALLING THE FUNCTION TO EXTRACT FAQS FOR THIS RECIPE MD FILE
    extract_content_between_two_successive_faqs $recipe_mdfile $faqs_json_file
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
done

##################################################################################
##################################################################################
echo; echo ">>>> DELETING ALL TMP UNNECESSARY FILES" ;
rm $WORKDIR/*.tmp*


