#!/anaconda3/bin/python3
##############################################################################
## THIS PYTHON SCRIPT READS A CSV FILE OBTAINED FROM GOOGLE SHEETS.
## THAT CSV CONTAINS THE NECESSARY TEXT CONTENT FOR EACH MGGK URL
## ARRANGED AS ONE ROW PER URL.
## WE WILL USE THIS CSV FILE TO OUTPUT ONE YAML RECIPE FILE FOR INPUT EACH ROW.
#######################################
#######################################
## MADE ON: MAY 09 2019
## BY: PALI
##############################################################################
##############################################################################

import numpy as np ;
import pandas as pd ;
import re ;
import datetime ;
import os ;
import pathlib ;
import time ;

## SETTING HOME VARIABLE FROM ENVIRONMENTAL VARIABLE + SOME MORE VARIABLES
MYHOME = os.environ['HOME'] ## GETTING THE ENVIRONMENT VALUE FOR HOME
MY_YAML_DIR = MYHOME + '/Desktop/Y/_TMP_OUTPUTS_YAML' ;
TMP_STEP2_INDEX_FILE = MYHOME + '/Desktop/Y/_TMP_STEP2_INDEX_FILE.HTML'

## INITIALIZING THE TMP INDEX HTML FILE
TMP_INDEX_INIT = open(TMP_STEP2_INDEX_FILE,'w')
TODAY = str(time.strftime("%Y-%m-%d %H:%M"))
TMP_INDEX_INIT.write( '<p>Updated: ' + TODAY + '</p><h1 style="color:#cd1c62;">TMP INDEX FILE with HUGO MARKDOWN FILENAME + YAML RECIPE FILENAME</h1>' )
TMP_INDEX_INIT.close()

## CREATING A DIRECTORY =  MY_YAML_DIR
pathlib.Path(MY_YAML_DIR).mkdir(parents=True, exist_ok=True)


##############################################################################
## READING 1ST CSV FILE
data = pd.read_csv("_STEP2-INPUT-MGGK-GOOGLE-SHEETS-CSV.CSV")
## adding an extra columns with row numbers minus 1 = index_value
data['index_data'] = data.reset_index().index
print(data)
## PRINTING COLUMNS NAMES
print(data.columns)
for colname in data.columns:
    print(colname)
####################################
## READING 2ND CSV FILE
data1 = pd.read_csv("_TMP_STEP1_OUTPUT.CSV")
## adding an extra columns with row numbers minus 1 = index_value
data1['index_data1'] = data1.reset_index().index
data1['data1_URL'] = data1['URL']
print(data1)
## PRINTING COLUMNS NAMES
print(data1.columns)
for colname in data1.columns:
    print(colname)

##############################################################################
## FINAL MERGING OF THE TWO CSV FILES ALONG URL COLUMN
data_final=pd.merge(data, data1, on='URL')
print(data_final)

data_final.to_csv("_TMP_STEP2_FINAL_OUTPUT.CSV",sep=",",index=True)

##############################################################################
print("\n====> RUNNING FINAL PRINTING MAGIC ...")
## USING FINAL DATA = data_final TO RUN THE PROGRAM FURTHER TO CREATE YAML RECIPE FILES
COUNT_ROWS = data_final.shape[0]  # gives number of row count for dataframe = data
COUNT_COLS = data_final.shape[1]  # gives number of col count for dataframe = data

##############################################################################
############ BEGIN: MAIN FOR LOOP FOR EACH ROW ###############################
##############################################################################
## LOOPING THROUGH ALL ROWS ONE BY ONE
for x in range(0, COUNT_ROWS):

    print("\n")

    ## GETTING ALL ORIGINAL COLUMNS VARIABLES

    PREPTIME_H	      =str(int(data_final.at[x,'PREPTIME_H']))
    PREPTIME_M	      =str(int(data_final.at[x,'PREPTIME_M']))
    COOKTIME_H	      =str(int(data_final.at[x,'COOKTIME_H']))
    COOKTIME_M	      =str(int(data_final.at[x,'COOKTIME_M']))
    TOTALTIME_H       =str(int(data_final.at[x,'TOTALTIME_H']))
    TOTALTIME_M       =str(int(data_final.at[x,'TOTALTIME_M']))
    SERVINGS	          =str(data_final.at[x,'SERVINGS'])
    CATEGORY	          =str(data_final.at[x,'CATEGORY'])
    CUISINE	          =str(data_final.at[x,'CUISINE'])
    CALORIES	          =str(data_final.at[x,'CALORIES'])
    CALORIES_SERVINGS =str(data_final.at[x,'CALORIES_SERVINGS'])
    KEYWORDS	          =str(data_final.at[x,'KEYWORDS'])

    RECIPE_TITLE      =str(data_final.at[x,'RECIPE_TITLE'])
    RECIPE_AUTHOR     =str(data_final.at[x,'RECIPE_AUTHOR'])
    RECIPE_DESCRIPTION=str(data_final.at[x,'RECIPE_DESCRIPTION'])


    ## FORMATTING DATE (getting date from date time variable)
    RECIPE_DATE       =str(data_final.at[x,'RECIPE_DATE'])
    TMP_DATE_TIME_OBJECT = datetime.datetime.strptime(RECIPE_DATE, '%Y-%m-%d %H:%M:%S')
    RECIPE_DATE_MGGK  =str(TMP_DATE_TIME_OBJECT.date())

    RECIPE_FEATURED_IMAGE =str(data_final.at[x,'RECIPE_FEATURED_IMAGE'])

    URL	              =str(data_final.at[x,'URL'])
    MGGK_URL          =re.sub("http://localhost:1313", "https://www.mygingergarlickitchen.com", URL)

    RECIPE_FILENAME   =str(data_final.at[x,'RECIPE_FILENAME'])

    TMP_NAMEVAR = re.sub("/", "", URL)
    TMP_NAMEVAR = re.sub("http:localhost:1313", "", TMP_NAMEVAR)
    YAML_RECIPE_FILENAME   = "recipe-" + TMP_NAMEVAR + "-" + RECIPE_DATE_MGGK + ".yaml"

    ##########################################################################
    ## CREATING FINAL COLUMNS VARIABLES FROM ORIGINAL VARIABLES
    ##########################################################################

    ## CREATING FINAL TIME VARIABLES, AND REMOVING '0H' IN OUTPUTS
    PREPTIME_FINAL=str("PT" + PREPTIME_H + "H" + PREPTIME_M + "M")
    PREPTIME_FINAL = re.sub("0H", "", PREPTIME_FINAL)

    COOKTIME_FINAL=str("PT" + COOKTIME_H + "H" + COOKTIME_M + "M")
    COOKTIME_FINAL = re.sub("0H", "", COOKTIME_FINAL)


    TOTALTIME_FINAL=str("PT" + TOTALTIME_H + "H" + TOTALTIME_M + "M")
    TOTALTIME_FINAL = re.sub("0H", "", TOTALTIME_FINAL)



    ## FIXING EXTRA SPACES AND TABS IN KEYWORDS
    ## THEN, REMOVING UNNECESSARY COMMAS AT THE END OF LINE
    KEYWORDS_REGEXED = re.sub("\s+", " ", KEYWORDS)
    KEYWORDS_REGEXED = re.sub(",\s*$", " ", KEYWORDS_REGEXED)
    ##########################################################################

    print( "Index " + str(x) + " // Line " + str(x+1) )
    print("\n")

    print("RECIPE_TITLE: " + RECIPE_TITLE)
    print("RECIPE_AUTHOR: " + RECIPE_AUTHOR)
    print("RECIPE_DESCRIPTION: " + RECIPE_DESCRIPTION)


    print("RECIPE_FEATURED_IMAGE: " + RECIPE_FEATURED_IMAGE)
    print("RECIPE_FILENAME: " + RECIPE_FILENAME)


    print("KEYWORDS_ORIGINAL: " + KEYWORDS)
    print("KEYWORDS_REGEXED: " + KEYWORDS_REGEXED)

    print("PREPTIME_M: " + PREPTIME_M)
    print("COOKTIME_M: " + COOKTIME_M)
    print("TOTALTIME_M: " + TOTALTIME_M)


    print("PREPTIME_FINAL: " + PREPTIME_FINAL)
    print("COOKTIME_FINAL: " + COOKTIME_FINAL)
    print("TOTALTIME_FINAL: " + TOTALTIME_FINAL)

    print("RECIPE_DATE: " + RECIPE_DATE)
    print('RECIPE_DATE_MGGK:', RECIPE_DATE_MGGK)


    print("URL: " + URL)
    print("MGGK_URL: " + MGGK_URL)

    print("YAML_RECIPE_FILENAME: " + YAML_RECIPE_FILENAME)


    ## SAVING THE RESULTS TO A CSV FILE

    print("\n====> PRINTING TO OUTPUT RECIPE_FILE ==> " + YAML_RECIPE_FILENAME )

    RECIPE_FILE = open(MY_YAML_DIR + "/" + YAML_RECIPE_FILENAME,'w')

    RECIPE_FILE.write('---')

    RECIPE_FILE.write('\n\"@context\": http://schema.org/')

    RECIPE_FILE.write('\n\n\"@type\": Recipe')

    RECIPE_FILE.write('\n\nname: \"' + RECIPE_TITLE + '\"')

    RECIPE_FILE.write('\n\ndescription: \"' + RECIPE_DESCRIPTION + '\"')

    RECIPE_FILE.write('\n\nimage:')
    RECIPE_FILE.write('\n  - https://www.mygingergarlickitchen.com' + RECIPE_FEATURED_IMAGE)

    RECIPE_FILE.write('\n\nprepTime: ' + PREPTIME_FINAL)
    RECIPE_FILE.write('\n\ncookTime: ' + COOKTIME_FINAL)
    RECIPE_FILE.write('\n\ntotalTime: ' + TOTALTIME_FINAL)
    RECIPE_FILE.write('\n\nrecipeCategory: ' + CATEGORY)
    RECIPE_FILE.write('\n\nrecipeCuisine: ' + CUISINE)
    RECIPE_FILE.write('\n\nrecipeYield: ' + SERVINGS)

    RECIPE_FILE.write('\n\naggregateRating:')
    RECIPE_FILE.write('\n  \"@type\": AggregateRating')
    RECIPE_FILE.write('\n  ratingValue: 5')
    RECIPE_FILE.write('\n  ratingCount: 1')

    RECIPE_FILE.write('\n\nnutrition:')
    RECIPE_FILE.write('\n  \"@type\": NutritionInformation')
    RECIPE_FILE.write('\n  calories: ' + CALORIES + ' calories')
    RECIPE_FILE.write('\n  servingSize: '+ CALORIES_SERVINGS)

    RECIPE_FILE.write('\n\nauthor:')
    RECIPE_FILE.write('\n  \"@type\": Person')
    RECIPE_FILE.write('\n  name: Anupama Paliwal')
    RECIPE_FILE.write('\n  brand: My Ginger Garlic Kitchen')
    RECIPE_FILE.write('\n  url: https://www.MyGingerGarlicKitchen.com')

    RECIPE_FILE.write('\n\nrecipeNotes: No notes.')

    RECIPE_FILE.write('\n\nkeywords: \"'+ KEYWORDS_REGEXED + '\"')

    RECIPE_FILE.write('\n\nvideo:')
    RECIPE_FILE.write('\n  name: \"\"')
    RECIPE_FILE.write('\n  description: \"\"')
    RECIPE_FILE.write('\n  thumbnailUrl:')
    RECIPE_FILE.write('\n    - \"\"')
    RECIPE_FILE.write('\n    - \"\"')
    RECIPE_FILE.write('\n  contentUrl: \"\"')
    RECIPE_FILE.write('\n  embedUrl: \"\"')
    RECIPE_FILE.write('\n  uploadDate: \"\"')

    RECIPE_FILE.write('\n\ndatePublished: '+ RECIPE_DATE_MGGK)

    RECIPE_FILE.write('\n\nurl: '+ MGGK_URL)

    RECIPE_FILE.write('\n\nrecipeIngredient:')
    RECIPE_FILE.write('\n  - \"!!TITLE 1:\"')
    RECIPE_FILE.write('\n  - ingredient1')
    RECIPE_FILE.write('\n  - ingredient2')

    RECIPE_FILE.write('\n\nrecipeInstructions:')
    RECIPE_FILE.write('\n- \"@type\": HowToSection')
    RECIPE_FILE.write('\n  name: TITLE 1 TITLE 1')
    RECIPE_FILE.write('\n  itemListElement:')
    RECIPE_FILE.write('\n  - \"@type\": HowToStep')
    RECIPE_FILE.write('\n    text: Sample instruction text1')
    RECIPE_FILE.write('\n  - \"@type\": HowToStep')
    RECIPE_FILE.write('\n    text: Sample instruction text2')

    RECIPE_FILE.close()

    ##########################################################################
    ## CREATING AN HTML INDEX FILE TO MAKE ANU'S WORK EASY.
    ## THIS INDEX FILE WILL CONTAIN THE MARKDOWN FILENAME + CORRESPONDING YAML RECIPE FILENAME
    print("\n====> CREATING AN HTML INDEX FILE TO MAKE ANU'S WORK EASY ==> " + TMP_STEP2_INDEX_FILE )

    TMP_INDEX = open(TMP_STEP2_INDEX_FILE,'a+')
    TMP_INDEX.write('<h2>FILE # ' + str(x+1) + '</h2> <p>URL: <a href="'+ URL + '">' + URL + '</a> <br>HUGO MARKDOWN FILENAME = <TEXTAREA ROWS="1" COLS="150">' + RECIPE_FILENAME + '</TEXTAREA> <br>YAML RECIPE FILENAME = <TEXTAREA ROWS="1" COLS="150">' + YAML_RECIPE_FILENAME + '</TEXTAREA></p>' )
    TMP_INDEX.close()



##############################################################################
############ END: MAIN FOR LOOP FOR EACH ROW ###############################
##############################################################################

## FINAL PRINTING
print('====> Printing all column names in dataframe = data_final')
for colname in data_final.columns:
    print(colname)


################################################################################
