##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USAGE FOR PYTHON
## Print this help as >> this_script_name --help
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
import sys
####
def usage():
    print('## USAGE: ' + sys.argv[0])
    HELP_TEXT = """
    ##################################################################################
    ## THIS SCRIPT GETS AN INDIVIDUAL LD-JSON FILE FROM ITS PARENT BASH SCRIPT, AND 
    ## CREATE ITS CORRESPONDING YAML FILE BY PARSING IT.
    ## THIS PROGRAM USES yaml and json PYTHON MODULE LIBRARIES
    ##################################################################################
    ## MADE BY: PALI
    ## CODED ON: 2020-09-27
    ##############################################################################
    """
    print(HELP_TEXT)
####
## Calling the usage function
## First checking if there are more than one argument on CLI .
print()
if (len(sys.argv) > 1) and (sys.argv[1] == "--help"):
    print('## USAGE HELP IS PRINTED BELOW. SCRIPT WILL EXIT AFTER THAT.')
    usage()
    ## EXITING IF ONLY USAGE IS NEEDED
    quit()
else:
    print('## USAGE HELP IS PRINTED BELOW. NORMAL PROGRAM RUN WILL CONTINE AFTER THAT.')
    usage()  # Printing normal help and continuing script run.
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################
################################################################################

import sys
import yaml 
import json 
import re

############ JSON 

myfile_json = sys.argv[1] ;
print ('>>> FILE = ' + myfile_json)

with open(myfile_json,"r") as json_file:
    data = json.load(json_file)

## json_validate
print(data) ;

####################################################
## GETTING SOME VARIABLES FROM OBTAINED JSON FILE
RecipeName = str(data['name']) ;
RecipeImage = str(data['image'][0]) ;
RecipeImage = RecipeImage.replace('https://www.mygingergarlickitchen.com','') ;
RecipeAuthor = str(data['author']) ;
RecipeDate = str(data['datePublished']) ;

RecipeUrl = str(data['url']) ;
RecipeUrl = RecipeUrl.replace('https://www.mygingergarlickitchen.com','') ;

RecipeDescription = str(data['description']) ;
RecipeDescription = RecipeDescription.replace('"','') ;

RecipeCodeImage =  '/wp-content/rich-markup-images/1x1/1x1-' + RecipeUrl.replace('/','') + '.jpg' ;

####################################################

###############################
###############################
## Remove some unwanted elements from json
ELEMENTS_TO_DELETE_FROM_JSON=("@context", "@type", "name", "image", "description", "datePublished", "author", "video" ,"url") ;
##
JSON_FILE_WITH_DELETED_ELEMENTS = sys.argv[2] ; 
##
with open(JSON_FILE_WITH_DELETED_ELEMENTS, 'w') as dest_file:
    with open(myfile_json, 'r') as source_file:
        for line in source_file:
            #print(line.strip())
            element = json.loads(line.strip())
            ##
            for delete_this in ELEMENTS_TO_DELETE_FROM_JSON:    
                if delete_this in element:
                    del element[delete_this]
            ####
            print (""); print('+++++++++++++++ NEW JSON DATA +++++++++++++++++++') ; print (""); 
            print(json.dumps(element)) ;
            ####        
            dest_file.write(json.dumps(element))

#################################
#################################

############ YAML 
myfile_yaml = JSON_FILE_WITH_DELETED_ELEMENTS + '.yaml'
##
with open(JSON_FILE_WITH_DELETED_ELEMENTS,"r") as json_file:
    ## Store all data in a data dictionary
    newdata = json.load(json_file)

##########################
prepTime = str(newdata['prepTime']) ;
cookTime = str(newdata['cookTime']) ;
totalTime = str(newdata['totalTime']) ;

recipeCategory = str(newdata['recipeCategory']) ;
recipeCuisine = str(newdata['recipeCuisine']) ;
recipeYield = str(newdata['recipeYield']) ;
keywords = str(newdata['keywords']) ;

####################################################
## SOME ELEMENTS ARE INFACT DICTIONARIES IN THE JSON FILE
## THESE ARE: aggregateRating AND nutrition
## SO WE WILL FORMAT THEIR OUTPUT VIA A FUNCTION
def iterate_multidimensional(myDictionary):
    myList=[] ;
    for myKey,myValue in myDictionary.items():
        dontConsiderThis = '@type' ;
        if dontConsiderThis in myKey:
            print() ; ## simply prints a blank line
        else:    
            myVar = myKey + ": " + str(myValue) ; 
            print( myVar )
            myList.append(myVar)
    return myList ;    
####################################################

##########################
aggregateRating = newdata['aggregateRating']
print ('aggregateRating: ') ;
iterate_multidimensional(aggregateRating)
##
nutrition = newdata['nutrition']
print ('nutrition: ') ;
iterate_multidimensional(nutrition)
##########################

## DUMPING ALL JSON DATA TO YAML FILE
#data_yaml = yaml.dump({"prepTime" : newdata['prepTime'], "cookTime" : newdata['cookTime']})
data_yaml = yaml.dump(newdata)

## yaml data validate
yaml.safe_load(data_yaml)
##

####################################################
## BEGIN: WRITING CHOSEN VARIABLES TO A YAML FILE
####################################################
f = open(myfile_yaml, "w") ;

f.write('---') ; 

"""
##>>>>> BEGIN: tags to comment later
f.write('title: \"' + RecipeName + '\"\n')

f.write("\ndate: \"" + RecipeDate + '\"\n')
f.write("\nfirst_published_on: \"" + RecipeDate + '\"\n')

f.write("\nfeatured_image: \"" + RecipeImage + '\"\n')
f.write("\nurl: \"" + RecipeUrl + '\"\n')
f.write("\nauthor: \"Anupama" + '\"\n')
f.write("\nyoast_description: \"" + RecipeDescription + '\"\n') ;
f.write('\nyoutube_video_id: \"XXXXXXXXXXX\"\n') ;

f.write('\ncategories: \n')
f.write('  - \"demoCategory\"\n')

f.write('\ntags: \n')
f.write('  - \"demoTags\"\n')
##>>>>> END : tags to comment later

"""

f.write('\nmy_custom_variable: \"custom_variable_value\"\n')

f.write('\nsteps_images_present: \"no\"\n')

f.write("\nrecipe_code_image: \"" + RecipeCodeImage + '\"\n')

f.write("\nprepTime: " + prepTime + '\n')
f.write("cookTime: " + cookTime + '\n')
f.write("totalTime: " + totalTime + '\n')
f.write("\n")

f.write("recipeCategory: " + recipeCategory + '\n')
f.write("recipeCuisine: " + recipeCuisine + '\n')
f.write("recipeYield: " + recipeYield + '\n')
f.write("\n")

f.write('recipe_keywords: \"' + keywords + '\"\n')

f.write('\naggregateRating: \n') ;
aggregateRatingElements = iterate_multidimensional(aggregateRating)
for y in aggregateRatingElements:
    f.write( '  ' + y + '\n')

f.write('\nnutrition: \n') ;
nutritionElements = iterate_multidimensional(nutrition)
for y in nutritionElements:
    f.write( '  ' + y + '\n')

##########################
list_all_ingredients = newdata['recipeIngredient']
## The same ingredients list but without the empty elements
list_all_ingredients = [ var for var in list_all_ingredients if var ]

print(list_all_ingredients)
print('recipeIngredient:') ;
f.write('\nrecipeIngredient:') ;

list_or_not = isinstance(list_all_ingredients, list) ; 

f.write ( '\n  - recipeIngredientTitle: List of Ingredients' ) ;
f.write ( '\n    recipeIngredientList: ') ;
f.write ( '\n    - \"Following are all the ingredients\"') ;

for x in list_all_ingredients:
    x = x.strip() ; ## removing leading + trailing whitespaces
    x = x.replace('"','\"') ;
    x = x.replace(':',' //') ;
    x = x.replace('<h4>','!!') ;
    x = x.replace('</h4>','') ;

    if x[:3] == "For":
        ## only the first occurence is replaced       
        x = x.replace('For','!!For', 1) ;

    lookforthis="!!"

    if lookforthis in x:
        print ( '  - recipeIngredientTitle: "' + x.replace('!!','') + '"' ) ;
        print ( '    recipeIngredientList: ') ;
        f.write ( '\n  - recipeIngredientTitle: "' + x.replace('!!','') + '"' ) ;
        f.write ( '\n    recipeIngredientList: ') ;
    else:
        print ( '    - "' + x + '"') ;
        f.write ( '\n    - "' + x + '"') ;
        
##########################

##########################
print("////////////////////////////////////////////////") ;
recipeInstructions = newdata['recipeInstructions']
print('recipeInstructions:') ;
f.write('\n\nrecipeInstructions:') ;

list_or_not = isinstance(recipeInstructions, list) ; 

if list_or_not == True:
    for HowToSection in recipeInstructions:
        nameOfSection = HowToSection['name']
        nameOfSection = nameOfSection.replace('"','\"')
        nameOfSection = nameOfSection.replace(":"," //")
        print('  - recipeInstructionsTitle: "' + nameOfSection + '"') ;
        print('    recipeInstructionsList: ') ;
        f.write('\n  - recipeInstructionsTitle: "' + nameOfSection + '"') ;
        f.write('\n    recipeInstructionsList: ') ;
        itemListElement = HowToSection['itemListElement']
        for HowToStep in itemListElement:
            HowToStepText = HowToStep['text']
            HowToStepText = HowToStepText.replace('"','\"') ;
            HowToStepText = HowToStepText.replace(':',' //') ;
            print('    - "' + HowToStepText + '"');
            f.write('\n    - "' + HowToStepText + '"');
else:
    f.write('\n  - recipeInstructionsTitle: List of Instructions') ;
    f.write('\n    recipeInstructionsList: ') ;
    ## Replacing prefix digits such as 1. .2 .3 .... 11. 12. etc, with newlines
    recipeInstructionsNew = re.sub(r'\d{1,2}\.','\n', str(recipeInstructions) ) ;
    recipeInstructionsNew = recipeInstructionsNew.replace('1.','') ;   
    recipeInstructionsNew = recipeInstructionsNew.replace('<h4>','!!') ;
    recipeInstructionsNew = recipeInstructionsNew.replace('</h4>',' //') ;
    ## converting it to array
    recipeInstructionsNewArray = recipeInstructionsNew.split('\n') ;
    for instructions_text in recipeInstructionsNewArray:
        f.write('\n    - \"' + instructions_text.strip() + '\"' ) ;

##########################


       
f.write("\n")
f.write('\nrecipeNotes: \n')
notes_file = sys.argv[3] ;
notes_file = notes_file.strip() ;
with open(notes_file) as fp:
   for line in fp:
       line = line.replace('"','') ;
       line = re.sub(r'\d{1,2}\.','', str(line) ) ;
       f.write('  - ' + line )
#f.write('  - \"No notes.\"\n')

"""
##>>>>> BEGIN: tags to comment later
f.write('\n\n---\n') ; 
f.write('\n') ; 
f.write('{{< mggk-button-block-for-recipe-here-link >}}') ;
f.write('\n') ;
f.write('This is just a test line.') ; 
f.write('\n') ;
f.write('{{< mggk-INSERT-RECIPE-HTML-BLOCK >}}') ;
##>>>>> END: tags to comment later
"""
f.write('\n\nXYZXYZXYZ') ;

f.close() ;
####################################################
## END: WRITING CHOSEN VARIABLES TO A YAML FILE
####################################################


