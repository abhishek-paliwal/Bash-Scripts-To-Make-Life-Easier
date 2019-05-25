#!/bin/bash
cat << EOF

  ##############################################################################
  ## FILENAME: 508-mggk-convert-yaml-recipes-to-json-and-html-blocks.sh
  ## USAGE: sh THIS_FILE_NAME
  ## SAMPLE YAML RECIPE FILE = recipe-sample-template-in-yaml-1.yaml
  ##############################################################################
  #### IMPORTANT NOTE: Make sure that the recipe yaml files have the
  #### prefix 'recipe-', and naming convention as recipe-ANY-NAME-YOU-LIKE.yaml
  ##
  ##############################################################################
  ## THIS PROGRAM PARSES A MGGK RECIPE YAML FILE USING A UTILITY KNOWN AS YQ
  ## AND OUTPUTS JSON. IT ALSO CONVERTS YAML TO JSON.
  #### IT PARSES A YAML FILE THROUGH BASH COMMAND LINE, AND OUTPUTS JSON OUTPUT
  #### BY GETTING THE KEYS AND VALUES (NON-NESTED AND NESTED).
  #### It Parses a YAML file using a utility'yq' (which needs jq)
  ##
  ################## YQ /JQ INSTALLATION INSTRUCTIONS: #########################
  #### JQ = https://stedolan.github.io/jq/download/
  #### YQ = https://pypi.org/project/yq/
  #### brew install jq
  #### brew install python-yq OR pip3 install yq
  ##
  ######################### TUTORIAL ON HOW TO USE: ############################
  #### https://medium.com/@frontman/how-to-parse-yaml-string-via-command-line-374567512303
  #### JQ USAGE tutorial: https://stedolan.github.io/jq/tutorial/
  ##############################################################################
  ## CODED BY: PALI
  ## ON: April 13, 2019
  ##############################################################################
  ##############################################################################

EOF

###############################################################################

#### YAML_DIR = DIRECTORY WHERE RECIPE FILES ARE PRESENT
#YAML_DIR="$HOME/Desktop/_TMP_Automator_results_" ;
YAML_DIR=$(pwd);

## Working directory
PWD=$YAML_DIR;
cd $PWD
echo; echo ">>>> CURRENT WORKING DIRECTORY: $PWD" ; echo;
## USER CONFIRMATION TO CONTINUE
read -p "Please check the Current directory. If OKAY, press ENTER key to continue ..." ;

###############################################################################
## SOME VARIABLES
TMP_DIR="$PWD/_TMP_JSON_HTML_DIR" ;
mkdir $TMP_DIR ;

HTML_INDEX_FILE="_MGGK_HTML_JSON_YAML_INDEX.html" ;
## Initializing the HTML file
echo "Last updated: $(date)" > $HTML_INDEX_FILE ;
echo "<!-- HTML FILE --> <H1 style='color: #cd1c62 ; '>MGGK RECIPES - HTML FILE INDEX (YAML+ JSON)</H1>" >> $HTML_INDEX_FILE ;

##############################################################################
## BEGIN: MAIN FOR LOOP FOR EACH RECIPE YAML FILE ############################
##############################################################################
COUNT=0 ;

for recipe_file in recipe*.yaml ;
do
  (( COUNT++ ))

  ## CREATING A NEW YAML FILE WITHOUT recipeNotes KEY:VALUE
  #### IT'S BECAUSE OTHERWISE IT CREATES AN INVALID RECIPE JSON WHICH GIVES
  #### ERROR DURING GOOGLE RECIPE MARKUP CHECKING
  #### [ IMP. NOTE: YOU CAN EXCLUDE ANY MORE KEY:VALUES THIS WAY ]
  NEW_FILE="$TMP_DIR/_COPY-$recipe_file" ;
  cat $recipe_file | grep -iv 'recipeNotes' > $NEW_FILE ;

  echo ">>>>>>>>> NEW YAML FILE CREATED without any recipeNotes KEY VALUE. <<<<<<<<<<" ;
  echo ">>>>>>>>> $recipe_file ==>> $NEW_FILE <<<<<<<<<< ";
  echo ;

  ############################################################################
  ## VARIABLE DEFINITIONS
  YAML_FILE="$NEW_FILE" ;

  ## Getting filename without extension
  ## First, getting basename for filename
  BASENAME_YAML_FILE=$(basename $YAML_FILE);
  ## Second, getting filename without extension
  YAML_FILENAME_WITHOUT_EXTENSION="${BASENAME_YAML_FILE%%.*}" ;

  JSON_OUTPUT1="$TMP_DIR/$YAML_FILENAME_WITHOUT_EXTENSION.json" ;
  JSON_OUTPUT2="$TMP_DIR/$YAML_FILENAME_WITHOUT_EXTENSION-QUOTES-ESCAPED.json" ;

  RECIPE_HTML_FILE="$TMP_DIR/$YAML_FILENAME_WITHOUT_EXTENSION-RECIPE-BLOCK.html" ;

  echo;
  echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;
  echo ">>>>>>>>>>>>>>>>>>>> FILENAME READ = $YAML_FILE <<<<<<<<<<<<<<<<<<<<<" ;
  echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ;

  ## FIRST, DO A CHECK IF THE YAML FILE TO BE PARSED FOR ANY SYNTAX ERRORS
  echo;
  echo ">>>>>> BEGIN: CHECKING YAML FILE FOR ANY ERRORS : YAMLLINT >>>>>>>>>>>>"
  echo ">>>>>> (NOTE: Ignore any line too long ERRORS) >>>>>>>>>>>>"
  YAMLINT_CONFIG_FILE="$HOME/Github/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/_ALL-YAML-RECIPES/yamllint-mggk-config-file-for-checking-recipes.yaml" ;
  yamllint -c $YAMLINT_CONFIG_FILE $YAML_FILE
  echo ">>>>>> END: CHECKING YAML FILE FOR ANY ERRORS : YAMLLINT >>>>>>>>>>>>"
  echo ;

  ## EXAMPLE, PARSING SOME KEY VALUES (NON-NESTED AND NESTED)
  #### NESTED
  echo "########" ; cat $YAML_FILE | yq .video
  echo "########" ; cat $YAML_FILE | yq .video.contentUrl
  #### NON-NESTED
  echo "########" ; cat $YAML_FILE | yq .name
  echo "########" ; cat $YAML_FILE | yq .description
  #### PRINTING OUT FULL YAML TO JSON OUTPUT (NOTICE THE DOT AT THE END)
  echo "########" ; cat $YAML_FILE | yq .

  #### OUTPUTTING THE WHOLE YAML FILE TO JSON (KINDA LIKE YAML2JSON :-) )
  cat $YAML_FILE | yq . > $JSON_OUTPUT1
  echo ">>>> STEP 1 DONE: CONVERTING YAML TO JSON, AND SAVING AS JSON FILE --> $JSON_OUTPUT1 <<<< " ;

  ## CREATING ANOTHER FILE FROM JSON WHICH IS SUITABLE FOR MGGK COPY-PASTING
  ## IN CREATING THE HUGO MARKDOWN POSTS IN THE
  ## FRONTMATTER VARIABLE = mggk_recipe_json
  ##
  echo ">>>> STEP 2 DONE: CONVERTING $JSON_OUTPUT1 --> $JSON_OUTPUT2 <<<< " ;
  ## But first, adding the required script ld+json start and end tags
  echo "<!-- JSON+LD RECIPE SCHEMA BLOCK BELOW THIS --> <script type='application/ld+json'>" > $JSON_OUTPUT2
  #### Removing the null keyword which appears at the end of JSON file
  cat $JSON_OUTPUT1 | sed 's/"/\\"/g' | sed 's/null//g' >> $JSON_OUTPUT2
  echo "</script> <!-- JSON+LD RECIPE SCHEMA BLOCK ABOVE THIS -->" >> $JSON_OUTPUT2


  ############################################################################
  ## CREATING PROPERLY FORMATTED MGGK RECIPE HTML FILE
  #### jq -r ==> Here '-r' means value as raw_value, without double_quotes
  ############################################################################
  echo;
  echo "=====================================================================" ;
  echo "  >>>>>>>>>>>> RECIPE VARIABLE VALUES PRINTING <<<<<<<<<<<<< ";
  echo "=====================================================================" ;
  echo;

  #################################################################
  ################### BEGIN: SPECIAL VARIABLES: ###################
  ## THE VALUE OF SPECIAL VARIABLES IS ONLY TO BE FOUND BY PARSING THE ORIGINAL UNTOUCHED
  ## RECIPE YAML FILE, BECAUSE IN $YAML_FILE, THESE HAVE BEEN AUTOSTRIPPED AT THE
  ## BEGINNING OF THIS SCRIPT, BECUASE IT DOES NOT RENDER PROPER GOOGLE RECIPE JSON.
  ##
  #### GETTING VARIABLE VALUES
  recipeNotes=$(cat $recipe_file | yq '.recipeNotes' | jq -r '.' | sed 's/null//g') ;
  echo "recipeNotes: $recipeNotes" ;
  ################### END: SPECIAL VARIABLES: #####################
  #################################################################

  ## ALL OTHER VARIABLES
  recipeName=$(cat $YAML_FILE | yq '.name' | jq -r '.' | sed 's/null//g') ;
  echo "recipeName: $recipeName" ;

  recipeDescription=$(cat $YAML_FILE | yq '.description' | jq -r '.' | sed 's/null//g') ;
  echo "recipeDescription: $recipeDescription" ;

  imageUrl=$(cat $YAML_FILE | yq '.image' | jq -r '.[0]' | sed 's/null//g') ;
  echo "imageUrl: $imageUrl" ;

  ratingValue=$(cat $YAML_FILE | yq '.aggregateRating.ratingValue' | jq -r '.' | sed 's/null//g') ;
  echo "ratingValue: $ratingValue" ;

  ratingCount=$(cat $YAML_FILE | yq '.aggregateRating.ratingCount' | jq -r '.' | sed 's/null//g') ;
  echo "ratingCount: $ratingCount" ;

  ###################### BEGIN: TIME VARIABLES ###############################
  prepTime=$(cat $YAML_FILE | yq '.prepTime' | jq -r '.' | sed 's/null//g') ;
  echo "prepTime: $prepTime" ;

    prepTimeHuman=$(echo $prepTime | sed 's/PT//g' | sed 's/H/ hour(s) /g' | sed 's/M/ minutes/g' );
    echo "  prepTimeHuman: $prepTimeHuman" ;

  cookTime=$(cat $YAML_FILE | yq '.cookTime' | jq -r '.' | sed 's/null//g') ;
  echo "cookTime: $cookTime" ;

    cookTimeHuman=$(echo $cookTime | sed 's/PT//g' | sed 's/H/ hour(s) /g' | sed 's/M/ minutes/g' );
    echo "  cookTimeHuman: $cookTimeHuman" ;

  totalTime=$(cat $YAML_FILE | yq '.totalTime' | jq -r '.' | sed 's/null//g') ;
  echo "totalTime: $totalTime" ;

    totalTimeHuman=$(echo $totalTime | sed 's/PT//g' | sed 's/H/ hour(s) /g' | sed 's/M/ minutes/g' );
    echo "  totalTimeHuman: $totalTimeHuman" ;

  ###################### END: TIME VARIABLES #################################

  recipeCategory=$(cat $YAML_FILE | yq '.recipeCategory' | jq -r '.' | sed 's/null//g') ;
  echo "recipeCategory: $recipeCategory" ;

  recipeCuisine=$(cat $YAML_FILE | yq '.recipeCuisine' | jq -r '.' | sed 's/null//g') ;
  echo "recipeCuisine: $recipeCuisine" ;

  recipeYield=$(cat $YAML_FILE | yq '.recipeYield' | jq -r '.' | sed 's/null//g') ;
  echo "recipeYield: $recipeYield" ;

  nutritionCalories=$(cat $YAML_FILE | yq '.nutrition.calories' | jq -r '.' | sed 's/null//g') ;
  echo "nutritionCalories: $nutritionCalories" ;

  nutritionServingSize=$(cat $YAML_FILE | yq '.nutrition.servingSize' | jq -r '.' | sed 's/null//g') ;
  echo "nutritionServingSize: $nutritionServingSize" ;

  recipeAuthor=$(cat $YAML_FILE | yq '.author.name' | jq -r '.' | sed 's/null//g') ;
  echo "recipeAuthor: $recipeAuthor" ;

  recipeUrl=$(cat $YAML_FILE | yq '.url' | jq -r '.' | sed 's/null//g') ;
  echo "recipeUrl: $recipeUrl" ;

  datePublished=$(cat $YAML_FILE | yq '.datePublished' | jq -r '.' | sed 's/null//g') ;
  echo "datePublished: $datePublished" ;


    ################### ++++++++++++++++++++++++++++++++++++ ##################
    ######## BEGIN: CREATING RECIPE-INGREDIENTS ARRAY IN BASH ###############
      full_recipeIngredients="" ; ## empty string initialized
      recipeIngredients=() ; ## an empty array initialized

      echo; echo "=== COUNTING NUMBER OF LINES IN INGREDIENTS: === " ;

      ## Let's find out the approx number of ingredients in the yaml file by parsing
      #### and counting the lines in the output. But first, printing ...
      cat $YAML_FILE | yq '.recipeIngredient' | jq -r '.' | nl ;
      ####
      approx_ingr=$( cat $YAML_FILE | yq '.recipeIngredient' | wc -l |bc -l ) ;

      #### Seems like there are 2 extra lines every time the approx_ingr is calculated.
      #### Hence, we will now subtract 2 from it.
      echo ; echo ">>>> approx_ingr (before, check above) = $approx_ingr" ;
      ## Actual subtraction
      approx_ingr_after=$(echo $approx_ingr -2 |bc -l) ;
      echo ">>>> approx_ingr (after subtracting 2) = $approx_ingr_after" ; 
      echo "      >>>> [ IGNORE THIS: command not found error in the above line ]" ;
      echo ;

      #### FOR LOOP THRU INGREDIENTS
      total_ingr_length=$(echo $approx_ingr_after -1 |bc -l);
      for x in $(seq 0 $total_ingr_length) ;
      do
        ingredient=$(cat $YAML_FILE | yq '.recipeIngredient' | jq -r .[$x] | sed 's/null//g') ;
        ingredient=$( echo '"'$ingredient'"' ) ;
        echo "RECIPE INGREDIENT [$x]: $ingredient" ;
        ## adding this element to array
        recipeIngredients[$x]=$(echo $ingredient) ;
      done

      ## printing full recipe-ingredients array
      echo;
      echo "RECIPE INGREDIENTS [HOW-MANY INGREDIENTS TOTAL]: ${#recipeIngredients[*]}  " ;
      echo ;
      echo "RECIPE INGREDIENTS [PRINTING FULL ARRAY]: ${recipeIngredients[*]}  " ;
      echo;

      #################
      #### FOR loop will be done from 0 to array_size minus one
      arr_size_minus_1=$(echo ${#recipeIngredients[*]}-1 | bc -l) ;

      for index in $(seq 0 $arr_size_minus_1) ;
      do
        echo ">> INDEX = $index // VALUE = ${recipeIngredients[$index]} " ;

        myString="${recipeIngredients[$index]}"
            ## Checks if line starts with !!, then treat it as a ingredient section heading
            ## If it does not start with !!, then treat it as an ingredient line
            if [[ $myString == *"!!"* ]]; then
              myString=$(echo $myString | sed 's/!!//g') ; ##Removing !! from the line
              full_recipeIngredients+="<h4>$myString</h4>" ;
            else
              full_recipeIngredients+="&bull; $myString<br>" ;
            fi

      done
      ################
      echo;
      echo "full_recipeIngredients (with double-quotes): $full_recipeIngredients" ;

      ## Removing double quotes everywhere from the output to
      ## create final recipeIngredients output variable
      final_recipeIngredients=$( echo "$full_recipeIngredients" | sed 's/\"//g' ) ;

      echo;
      echo "FINAL_RECIPE_INGREDIENTS (double-quotes removed): $final_recipeIngredients" ;
    ################# ++++++++++++++++++++++++++++++++++++ ##################
    ######## END: CREATING RECIPE-INGREDIENTS ARRAY IN BASH #################

    ################# ++++++++++++++++++++++++++++++++++++ ###################
    ######## BEGIN: CREATING RECIPE-INSTRUCTIONS #############################
      full_recipe_instructions="";

      ## CREATING A SUB-JSON WITH ONLY COOKINGSECTION + COOKINGSTEPS
      full_instructions_set=$( cat $YAML_FILE | yq '.recipeInstructions' | jq '[.[] | {cookingSection: .name , cookingSteps: [.itemListElement[].text] }]' ) ;
      echo;
      echo "full_instructions_set: " ;
      echo "$full_instructions_set" ;

      ## TACKLING COOKING-SECTIONS
      num_cookingSections=$( echo "$full_instructions_set" | grep -i 'cookingSection' | wc -l | bc -l ) ;
      echo; echo "num_cookingSections: $num_cookingSections" ;

      for s in $( seq 1 $num_cookingSections) ;
      do
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
        myVar=$(expr $s - 1) ;
        echo "myVar: $myVar " ;
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";

        ## Don't quote the .[$myVar].cookingSection thing below. It won't work.
        cooking_section=$( echo "$full_instructions_set" | jq .[$myVar].cookingSection );
        echo ">>>> cooking_section: " ;
        echo "<h4>$cooking_section</h4>" ;

        ## TACKLING COOKING-STEPS WITHIN THIS COOKING SECTION
        all_cooking_steps=$( echo "$full_instructions_set" | jq .[$myVar].cookingSteps )
        echo ">>>> all_cooking_steps: " ;
        echo "$all_cooking_steps" ;

        ## Finding the total number of cooking steps by only counting lines
        ## which contain double quotes. It's bcoz JQ outputs double-quotes with
        ## every SUB-JSON operation
        num_cookingSteps=$( echo "$all_cooking_steps" | grep -i '\"' | wc -l | bc -l ) ;
        echo; echo "num_cookingSteps: $num_cookingSteps" ;

          ## LOOPING THRU ALL COOKING-STEPS WITHIN THIS COOKING SECTION
          full_recipe_instructions+="<h4>$cooking_section</h4>" ;
          full_recipe_instructions+="<ol>" ; ## opening ordered list

          echo "===============";
          for t in $( seq 1 $num_cookingSteps) ;
          do
            myVar1=$(expr $t - 1) ;
            echo "myVar1: $myVar1 " ;
            single_cook_step=$( echo "$all_cooking_steps" | jq .[$myVar1] ) ;
            echo ">>>> single_cook_step:" ;
            echo "$single_cook_step<br>" ;

            ## joining and putting elements in a html list view ...
            full_recipe_instructions+="<li>$single_cook_step</li>" ;
          done

          full_recipe_instructions+="</ol>" ; ## closing ordered list

      done

      echo ;
      echo "full_recipe_instructions (with double-quotes): $full_recipe_instructions" ;

      ## Removing double quotes everywhere from the output to
      ## create final recipeInstructions output variable
      final_recipeInstructions=$( echo "$full_recipe_instructions" | sed 's/\"//g' ) ;

      echo;
      echo "FINAL_RECIPE_INSTRUCTIONS (double-quotes removed): $final_recipeInstructions" ;
    ################# ++++++++++++++++++++++++++++++++++++ ###################
    ########## END: CREATING RECIPE-INSTRUCTIONS #############################


  ##############################################################################
  ##############################################################################
  ## BEGIN: CREATING THE INDIVIDUAL RECIPE HTML FILE ###########################
  ####
  ## COLLECTING ALL RECIPE VARIABLES AND ARRANGING THEM IN AN
  ## OUTPUT AND CREATING AN HTML FILE BASED ON THAT OUTPUT, JUST WITH THE
  ## RECIPE DISPLAY CODE TO BE PUT ON MGGK HUGO MARKDOWN POSTS
  ##############################################################################
  ##############################################################################

## OUTPUTTING TO AN HTML FILE

cat > $RECIPE_HTML_FILE <<EOF
    <!-- HTML RECIPE CODE BLOCK BELOW THIS -->
    <div id='recipe-here'></div>
    <!-- /------------/ -->
    <div id='recipe-print-block' style='line-height: 1.1; border: 1px dashed black; padding: 10px; font-size: 14px; font-family: sans-serif; '>
        <div>
    <!-- /------------/ -->
            <h3><span itemprop='name'>$recipeName</span> [RECIPE]</h3>
            <span itemprop='description'>$recipeDescription</span>
    <!-- /------------/ -->
            <div class='flexbox_recipe_container'>
    <!-- /------------/ -->
                <div class='flexbox_recipe_left'><!-- recipe left flexbox starts -->
    <!-- /------------/ -->
                            <img itemprop='image' src='$imageUrl' width='150px'>
    <!-- /------------/ -->
                            <div itemprop='$aggregateRating'>
                                <span style='color: #cd1d63;'>&hearts; &hearts; &hearts; &hearts; &hearts;</span>
                                (Rating: <span itemprop='$ratingValue'>$ratingValue</span> from <span itemprop='$ratingCount'>$ratingCount</span> reviews)
                            </div>
    <!-- /------------/ -->
                            <h4>INGREDIENTS</h4>$final_recipeIngredients<hr>
    <!-- /------------/ -->
                </div><!-- recipe left flexbox ends -->
    <!-- /------------/ -->
                <div class='flexbox_recipe_right'><!-- recipe right flexbox starts -->
                            <table border='0' cellpadding='1' cellspacing='5' width='100%'>
                                <tr>
                                    <th style='text-align:center; width:33%; color:#cd1d63;'>&#128336; Prep time</th>
                                    <th style='text-align:center; width:33%; color:#cd1d63;'>&#128336; Cook time</th>
                                    <th style='text-align:center; width:33%; color:#cd1d63;'>&#128336; Total time</th>
                                </tr>
    <!-- /------------/ -->
                                <tr>
                                    <td style='text-align:center'><time datetime='$prepTime' itemprop='prepTime'>$prepTimeHuman</time></td>
                                    <td style='text-align:center'><time datetime='$cookTime' itemprop='cookTime'>$cookTimeHuman</time></td>
                                    <td style='text-align:center'><time datetime='$totalTime' itemprop='totalTime'>$totalTimeHuman</time></td>
                                </tr>
    <!-- /------------/ -->
                                <tr>
                                    <th style='text-align:center; width:33%; color:#cd1d63;'>&#9782; Category</th>
                                    <th style='text-align:center; width:33%; color:#cd1d63;'>&#9832; Cuisine</th>
                                    <th style='text-align:center; width:33%; color:#cd1d63;'>&#9786; Serves</th>
                                </tr>
    <!-- /------------/ -->
                                <tr>
                                    <td itemprop='recipeCategory' style='text-align:center; width:33%;'>$recipeCategory</td>
                                    <td itemprop='recipeCuisine' style='text-align:center; width:33%;'>$recipeCuisine</td>
                                    <td itemprop='recipeYield' style='text-align:center; width:33%;'>$recipeYield</td>
                                </tr>
                            </table>
    <!-- /------------/ -->
                            <hr>
    <!-- /------------/ -->
                            <div itemprop='nutrition'>
                                <strong>Nutrition Info:</strong> <span itemprop='calories'>$nutritionCalories</span> // <strong>Servings:</strong> <span itemprop='servingSize'>$nutritionServingSize</span>  </div>
    <!-- /------------/ -->
                            <h4>INSTRUCTIONS:</h4>
                            <div itemprop='recipeInstructions'>$final_recipeInstructions</div>
    <!-- /------------/ -->
                            <hr>
    <!-- /------------/ -->
                            <h3>NOTES:</h3>$recipeNotes
    <!-- /------------/ -->
            </div><!-- recipe right flexbox ends -->
    <!-- /------------/ -->
         </div><!-- recipe main flexbox container ends -->
    <!-- /------------/ -->
            <hr>
    <!-- /------------/ -->
            <table border='0' cellpadding='1' cellspacing='5' width='100%'>
                <tr>
                    <td style='text-align:left; width:15%;'><img alt='Logo' height='70px' src='https://www.mygingergarlickitchen.com/wp-content/uploads/2015/02/mggk-new-logo-transparent-150px.png'>
                    </td>
    <!-- /------------/ -->
                    <td style='text-align:left;'>
                        <strong>Author:</strong> <span itemprop='author'>$recipeAuthor</span><br>
                        <strong>Recipe Source Link:</strong> <a href='$recipeUrl'><span itemprop='url'>$recipeUrl</span></a><br>
                        <strong>Date Published: </strong> <span itemprop='datePublished'>$datePublished</span>
                    </td>
                </tr>
            </table>
    <!-- /------------/ -->
        </div>
    <!-- /------------/ -->
    </div>
    <!-- HTML RECIPE CODE BLOCK ABOVE THIS -->

EOF

## MAKING A PLAIN TEXT FILE FROM THE HTML FILE, BECAUSE WE WANT TO DISPLAY
## THE HTML SOURCE CODE IN PLAIN TEXT FOR COPY-PASTING
cat $RECIPE_HTML_FILE > $RECIPE_HTML_FILE.TXT ;

############ APPENDING RECIPE IN HTML INDEX FILE ############
## GETTING THE RECIPE NAME FROM YAML FILE
RECIPE_NAME=$(cat $YAML_FILE | yq .name ) ;

echo "<h3>$COUNT: $RECIPE_NAME</h3>
<p><a target='_blank' href='$recipe_file'>YAML (Original)</a>
<br><a target='_blank' href='$YAML_FILE'>YAML (Copied, without recipeNotes)</a>
<br><a target='_blank' href='$JSON_OUTPUT1'>JSON-ORIGINAL</a>
<br><a target='_blank' href='$RECIPE_HTML_FILE'>RECIPE-HTML-OUTPUT</a>
<br> ==> <a target='_blank' href='$JSON_OUTPUT2'>JSON-MODIFIED-FOR-COPY-PASTING</a>
<br> ==> <a target='_blank' href='$RECIPE_HTML_FILE.TXT'>RECIPE-HTML-CODE-FOR-COPY-PASTING</a>
</p>" >> $HTML_INDEX_FILE ;

  ##############################################################################
  ##############################################################################
  ## END: CREATING THE INDIVIDUAL RECIPE HTML FILE ###########################
  ##############################################################################
  ##############################################################################

done
##############################################################################
## END: MAIN FOR LOOP ######################################################
##############################################################################


## OPEN INDEX HTML FILE IN BROWSER
echo;
echo ">>>> Opening HTML INDEX file for recipes ..." ;
open $HTML_INDEX_FILE ;


##############################################################################
####################### PROGRAM ENDS #########################################
