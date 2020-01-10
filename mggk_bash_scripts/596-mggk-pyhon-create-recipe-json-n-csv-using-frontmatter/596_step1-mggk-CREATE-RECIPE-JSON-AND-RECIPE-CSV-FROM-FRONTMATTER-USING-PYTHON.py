THIS_PYTHON_SCRIPT_INFO = """
  ## THIS PYTHON SCRIPT TAKES AN MD_FILENAME AS COMMAND LINE ARGUMENT, THEN EXTRACTS
  ## THE mggk_json_recipe YAML FRONTMATTER CONTENT, PARSES IT AND FINALLY CREATES
  ## A RECIPE JSON AND A RECIPE CSV FILE. THIS CSV FILE
  ## IS THEN TO BE READ BY 513B SCRIPT FOR MAKING THE RECIPE JSON AND HTML BLOCKS.
"""
print(THIS_PYTHON_SCRIPT_INFO)
################################################################################

import frontmatter
import io
import sys
import json
import pandas as pd
from pandas import DataFrame
from pandas.io.json import json_normalize

################################################################################
## BEGIN: EXTRACTING THE VARIABLES FROM THE FRONTMATTER OF MD FILE AND SAVING TO JSON FILE
################################################################################

## GETTING THE MD FILENAME ARGUMENT FROM CLI
#fname = '/Users/anu/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/popular-posts/2019-09-07-T184741-rajasthani-mohanthal-gujarati-mohanthal-mohan-thal-2-ways-video-recipe.md'
fname = sys.argv[1]

with io.open(fname, 'r') as f:
    # Parse file's front matter
    post = frontmatter.load(f)

MGGK_JSON_RECIPE = str(post['mggk_json_recipe'])

## REPLACE ALL UNNECESSARY WORDS+PHRASES TO MAKE IT A PROPER JSON CODE
WORDS_TO_REPLACE = ['<!-- JSON+LD RECIPE SCHEMA BLOCK BELOW THIS -->','<!-- JSON+LD RECIPE SCHEMA BLOCK ABOVE THIS -->','<script type="application/ld+json">','<script type=\'application/ld+json\'>','</script>','\n','\t', ',""', '""']

for word in WORDS_TO_REPLACE:
    MGGK_JSON_RECIPE = MGGK_JSON_RECIPE.replace(word,'')

## REMOVING LEADING AND TRALING SPACES BEFORE FINALIZING THE VARIABLE
MGGK_JSON_RECIPE = MGGK_JSON_RECIPE.strip()
MGGK_JSON_RECIPE = MGGK_JSON_RECIPE.rstrip() # removing newlines + linebreaks
#print(MGGK_JSON_RECIPE)

##------------------------------------------------------------------------------
## WRITING TO A JSON FILE CORRESPONDING TO THAT URL
URL_TMP = str(post['url'])
URL_TMP = URL_TMP.replace('/','')
##
FILE_TO_WRITE = "" ;
FILE_TO_WRITE = '_recipe-' + URL_TMP + '.json'
fw = open(FILE_TO_WRITE,'w')
fw.write(MGGK_JSON_RECIPE)
fw.close() ;
################################################################################
## END: EXTRACTING THE VARIABLES FROM THE FRONTMATTER AND SAVING TO JSON FILE
################################################################################

################################################################################
## BEGIN: READING THE JSON DATA AND SAVING TO ONE CSV FILE PER RECIPE JSON FILE
################################################################################
# DO ERROR CHECKING, IF CAN'T LOAD JSON FILE, EXIT SCRIPT IMMEDIATELY.
with open(FILE_TO_WRITE,'r') as recipe_json_data:
    try:
         recipe_data = json.load(recipe_json_data)
    except ValueError:
         print('\n\n>>>> JSON LOAD ERROR: Looks like there are some empty values, meaning nothing inside double-quotes, somewhere. THIS PYTHON SCRIPT WILL EXIT NOW.\n') ;
         sys.exit() ; ## Exit this script right here.
         recipe_data = []

## CREATING A DATAFRAME FROM THUS OBTAINED DATA
recipe_df = json_normalize(recipe_data)
print(recipe_df.columns)

CSVFILE_RECIPE_RAW_INPUT = '_TMP_TO_DELETE_'+URL_TMP+'.csv' ;
recipe_df.to_csv(CSVFILE_RECIPE_RAW_INPUT, index=False)

######################################################################
## GETTING STRING VARIABLES FROM DATAFRAME. THIS DATAFRAME HAS ONLY 1 ROW.
COUNT = 1
HTML_RECIPENAME = recipe_df.loc[0,'name']
HTML_RECIPEDESCRIPTION = recipe_df.loc[0,'description']
HTML_RECIPEAUTHOR = recipe_df.loc[0,'author.name']
PREPTIME = recipe_df.loc[0,'prepTime']
COOKTIME = recipe_df.loc[0,'cookTime']
TOTALTIME = recipe_df.loc[0,'totalTime']
CATEGORY = recipe_df.loc[0,'recipeCategory']
CUISINE = recipe_df.loc[0,'recipeCuisine']
SERVINGS = recipe_df.loc[0,'recipeYield']
CALORIES = recipe_df.loc[0,'nutrition.calories']
CALORIES_SERVINGS = recipe_df.loc[0,'nutrition.servingSize']
KEYWORDS = recipe_df.loc[0,'keywords']
MY_INGREDIENTS_FINAL = recipe_df.loc[0,'recipeIngredient']
MY_INSTRUCTIONS_FINAL = recipe_df.loc[0,'recipeInstructions']
RATING_VALUE = recipe_df.loc[0,'aggregateRating.ratingValue']
RATING_USERS = recipe_df.loc[0,'aggregateRating.ratingCount']
RECIPE_DATE = recipe_df.loc[0,'datePublished']
RECIPE_FEATURED_IMAGE = recipe_df.loc[0,'image']
URL_PART_MINUS_MGGK = recipe_df.loc[0,'url']
HTML_RECIPE_NOTES = "No notes."

## VIDEO DATA DOES NOT GET NORMALIZED SOMETIMES, HENCE NORMALIZING IT LATER.
YOUTUBE_VIDEO_ID = ""
try:
    YOUTUBE_VIDEO_ID = recipe_df.loc[0,'video.embedUrl']
except:
    print('\n\n>>>> VIDEO DATA WILL BE NORMAMIZED NOW...')
    recipe_df_video = json_normalize(recipe_data, 'video', record_prefix='video.')
    print(recipe_df_video.columns)
    YOUTUBE_VIDEO_ID = recipe_df_video.loc[0,'video.embedUrl']

######################################################################
## PROCESSING SOME VARIABLES FURTHER
######################################################################
## MODIFYING RECIPE DATE
RECIPE_DATE = RECIPE_DATE.replace('\'', '') ;

## MODIFYING YOUTUBE_VIDEO_ID
YOUTUBE_VIDEO_ID = str(YOUTUBE_VIDEO_ID).replace('https://www.youtube.com/embed/', '')

######################################################################
## MODIFYING RECIPE_FEATURED_IMAGE
images = RECIPE_FEATURED_IMAGE
images_all = ""
for image in images:
    images_all = images_all + image + '\n'

RECIPE_FEATURED_IMAGE = images_all

######################################################################
## MODIFYING URL_PART_MINUS_MGGK
url = URL_PART_MINUS_MGGK
url = url.lower() ## making sure it's all in lowercase, for replacement below.
url = url.replace('https://www.mygingergarlickitchen.com/', '')
url = url.replace('/', '')
URL_PART_MINUS_MGGK = url
print('URL-PART' + URL_PART_MINUS_MGGK)

######################################################################
## MODIFYING MY_INGREDIENTS_FINAL
recipeIngredient = MY_INGREDIENTS_FINAL
recipeIngredient = str(recipeIngredient)
recipeIngredient = recipeIngredient.replace('"', '\'')
recipeIngredient = recipeIngredient.replace('[', '')
recipeIngredient = recipeIngredient.replace(']', '')
recipeIngredient = recipeIngredient.replace('\',' , '\'\n')
recipeIngredient = recipeIngredient.replace('!!', '\n!!')
recipeIngredient = recipeIngredient.replace('\'', '')
MY_INGREDIENTS_FINAL = recipeIngredient
print(MY_INGREDIENTS_FINAL)
print("==============================================================")

######################################################################
## MODIFYING MY_INSTRUCTIONS_FINAL
recipeInstructions = str(MY_INSTRUCTIONS_FINAL)
#print('BEFORE: ' + recipeInstructions)

chars_to_delete = [ '{' , '[' , ']'
, '\'name\': '
, '\'itemListElement\': '
, '\'@type\': '
, '\'text\': '
, '\'@type\': ' ]

for char in chars_to_delete:
    recipeInstructions = recipeInstructions.replace(char, '')

recipeInstructions = recipeInstructions.replace('\'HowToSection\',' , '\n!!')
recipeInstructions = recipeInstructions.replace('\'HowToStep\',' , '\n')
recipeInstructions = recipeInstructions.replace('"', '\'')
recipeInstructions = recipeInstructions.replace('},', '')
recipeInstructions = recipeInstructions.replace('}', '')
recipeInstructions = recipeInstructions.replace('\',', '')
recipeInstructions = recipeInstructions.replace('!!', '\n!!')
recipeInstructions = recipeInstructions.replace('\'', '')
MY_INSTRUCTIONS_FINAL = recipeInstructions

print('AFTER: ' + MY_INSTRUCTIONS_FINAL)

#final_df = pd.DataFrame(recipeInstructions)
#final_df.to_csv('demo2.csv', index=False)

######################################################################
## WRITING ALL DATA TO A CSV FILE
import csv

myData = [["COUNT",
"HTML_RECIPENAME",
"HTML_RECIPEDESCRIPTION",
"HTML_RECIPEAUTHOR",
"PREPTIME",
"COOKTIME",
"TOTALTIME",
"CATEGORY",
"CUISINE",
"SERVINGS",
"CALORIES",
"CALORIES_SERVINGS",
"KEYWORDS",
"MY_INGREDIENTS_FINAL",
"MY_INSTRUCTIONS_FINAL",
"RATING_VALUE",
"RATING_USERS",
"YOUTUBE_VIDEO_ID",
"RECIPE_DATE",
"RECIPE_FEATURED_IMAGE",
"URL_PART_MINUS_MGGK",
"HTML_RECIPE_NOTES"],
[COUNT,
HTML_RECIPENAME,
HTML_RECIPEDESCRIPTION,
HTML_RECIPEAUTHOR,
PREPTIME,
COOKTIME,
TOTALTIME,
CATEGORY,
CUISINE,
SERVINGS,
CALORIES,
CALORIES_SERVINGS,
KEYWORDS,
MY_INGREDIENTS_FINAL,
MY_INSTRUCTIONS_FINAL,
RATING_VALUE,
RATING_USERS,
YOUTUBE_VIDEO_ID,
RECIPE_DATE,
RECIPE_FEATURED_IMAGE,
URL_PART_MINUS_MGGK,
HTML_RECIPE_NOTES]]

CSVFILE_RECIPE_FINAL = '_TMP_FINAL_RECIPE_INPUT_FOR_513B_SCRIPT_'+URL_TMP+'.csv' ;
myFile = open(CSVFILE_RECIPE_FINAL, 'w')

with myFile:
    writer = csv.writer(myFile)
    writer.writerows(myData)
myFile.close() ;

print("\n>>>> Final writing to CSV complete.")
################################################################################
