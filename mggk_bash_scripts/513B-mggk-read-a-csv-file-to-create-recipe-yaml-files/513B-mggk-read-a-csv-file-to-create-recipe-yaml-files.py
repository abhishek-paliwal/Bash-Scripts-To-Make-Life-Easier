##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USAGE FOR PYTHON
## Print this help as >> this_script_name --help
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
import sys
####
def usage():
    print('########################################')
    print('## USAGE: ' + sys.argv[0])
    HELP_TEXT = """
    ##############################################################################
    ## THIS PYTHON SCRIPT READS A CSV FILE OBTAINED FROM GOOGLE SHEETS.
    ## THAT CSV CONTAINS THE NECESSARY TEXT CONTENT FOR EACH MGGK URL
    ## ARRANGED AS ONE ROW PER RECIPE.
    ## WE WILL USE THIS CSV FILE TO OUTPUT ONE YAML RECIPE FILE FOR INPUT EACH ROW.
    #######################################
    #######################################
    ## MADE ON: JULY 07 2019
    ## BY: PALI
    ##############################################################################
    """
    print(HELP_TEXT)
    print('########################################')
####
## Calling the usage function
## First checking if there are more than one argument in cli, .
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
TODAY = str(time.strftime("%Y-%m-%d %H:%M"))
TMP_STEP2_INDEX_FILE = MYHOME + '/Desktop/Y/_TMP_STEP3_INDEX_FILE.HTML'
AUTOCREATED_BASH_SCRIPT = MYHOME + '/Desktop/Y/_TMP_AUTOCREATED_BASH_SCRIPT_FOR_ANU.sh'

## INITIALIZING THE TMP INDEX HTML FILE
TMP_INDEX_INIT = open(TMP_STEP2_INDEX_FILE,'w')
TMP_INDEX_INIT.write( '<p>Updated: ' + TODAY + '</p><h1 style="color:#cd1c62;">TMP INDEX FILE with HUGO MARKDOWN FILENAME + YAML RECIPE FILENAME</h1>' )
TMP_INDEX_INIT.close()

## INITIALIZING THE AUTOCREATED_BASH_SCRIPT
BASHFILE = open(AUTOCREATED_BASH_SCRIPT,'w')
BASHFILE.write( '#/bin/bash' )
BASHFILE.write( '\n##############################################################################' )
BASHFILE.write( '\n## THIS BASH SCRIPT OPENS SELECTED FILES IN ATOM, BASED UPON A PROPER USER INPUT' )
BASHFILE.write( '\n## AUTOCREATED ON: ' + TODAY )
BASHFILE.write( '\n##############################################################################' )
BASHFILE.write( '\n\nread -p "Enter a number [from 1-178]: " VAR' )
BASHFILE.write( '\n\n' )
BASHFILE.write( '\nif [ -z $VAR ] ; then' )
BASHFILE.write( '\n\necho "YOU ENTERED WORNG VALUE FOR VAR. PLEASE ENTER A VALUE BETWEEN 1-73. IGNORE ANY FURTHER ERROR MESSAGES BELOW.\n\n" ;' )
BASHFILE.write( '\nfi\n\n' )
BASHFILE.close()

## CREATING A DIRECTORY =  MY_YAML_DIR
pathlib.Path(MY_YAML_DIR).mkdir(parents=True, exist_ok=True)

##############################################################################
##############################################################################
## READING 1ST CSV FILE
data = pd.read_csv("513B-REQUIREMENT-2019-MGGK-YAML-RECIPE-MAKER-TEMPLATE - Sheet-1.csv")
## adding an extra columns with row numbers minus 1 = index_value
data['index_data'] = data.reset_index().index
print(data)
## PRINTING COLUMNS NAMES
print(data.columns)
for colname in data.columns:
    print(colname)
####################################

##############################################################################
## FINAL MERGING OF THE TWO CSV FILES ALONG RECIPE_FILENAME COLUMN
data_final=data
print(data_final)

data_final.to_csv("_TMP_STEP3_FINAL_OUTPUT.CSV",sep=",",index=True)

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

    PREPTIME_FINAL	      =str(data_final.at[x,'PREPTIME'])
    COOKTIME_FINAL	      =str(data_final.at[x,'COOKTIME'])
    TOTALTIME_FINAL       =str(data_final.at[x,'TOTALTIME'])

    SERVINGS	          =str(data_final.at[x,'SERVINGS'])
    CATEGORY	          =str(data_final.at[x,'CATEGORY'])
    CUISINE	          =str(data_final.at[x,'CUISINE'])
    CALORIES	          =str(data_final.at[x,'CALORIES'])
    CALORIES_SERVINGS =str(data_final.at[x,'CALORIES_SERVINGS'])

    RATING_VALUE	          =str(data_final.at[x,'RATING_VALUE'])
    RATING_USERS	          =str(data_final.at[x,'RATING_USERS'])

    RECIPE_TITLE      =str(data_final.at[x,'HTML_RECIPENAME'])
    RECIPE_AUTHOR     =str(data_final.at[x,'HTML_RECIPEAUTHOR'])
    RECIPE_DESCRIPTION=str(data_final.at[x,'HTML_RECIPEDESCRIPTION'])

    YOUTUBE_VIDEO_ID = str(data_final.at[x,'YOUTUBE_VIDEO_ID'])

    HTML_RECIPE_NOTES = str(data_final.at[x,'HTML_RECIPE_NOTES'])


    ## FORMATTING DATE (getting date from date time variable)
    RECIPE_DATE       =str(data_final.at[x,'RECIPE_DATE'])
    TMP_DATE_TIME_OBJECT = datetime.datetime.strptime(RECIPE_DATE, '%Y-%m-%d')
    RECIPE_DATE_MGGK  =str(TMP_DATE_TIME_OBJECT.date())

    RECIPE_FEATURED_IMAGE =str(data_final.at[x,'RECIPE_FEATURED_IMAGE'])

    URL	              =str(data_final.at[x,'URL_PART_MINUS_MGGK'])
    MGGK_URL          = "https://www.mygingergarlickitchen.com/" +  URL + '/'

    RECIPE_FILENAME   = URL.strip() ## removing trailing and leading whitespaces
    COUNT   =str(data_final.at[x,'COUNT'])

    TMP_NAMEVAR = re.sub("/", "", URL)
    TMP_NAMEVAR = re.sub("http:localhost:1313", "", TMP_NAMEVAR)
    YAML_RECIPE_FILENAME   = "recipe-" + TMP_NAMEVAR + "-" + RECIPE_DATE_MGGK + "-" + COUNT + ".yaml"

    ##########################################################################
    ###### FORMATTING INGREDIENTS FOR USING IN YAML FILE
    ##########################################################################
    MY_INGREDIENTS_INITIAL = str(data_final.at[x,'MY_INGREDIENTS_FINAL'])
    MY_INGREDIENTS_FINAL=""

    ing_list = MY_INGREDIENTS_INITIAL.split("\n")
    for mying in ing_list:
        mying = mying.strip() ##removing leading + trailing spaces
        if mying != "":
            new_ing = '  - "' + mying + '"'
            print(new_ing)
            MY_INGREDIENTS_FINAL = MY_INGREDIENTS_FINAL + new_ing + '\n'

    #########################################################################
    ###### FORMATTING INSTRUCTIONS FOR USING IN YAML FILE
    #########################################################################
    MY_INSTRUCTIONS_INITIAL = str(data_final.at[x,'MY_INSTRUCTIONS_FINAL'])
    MY_INSTRUCTIONS_FINAL=""

    ins_list = MY_INSTRUCTIONS_INITIAL.split("\n") ;

    ####### DELETING THE UNNECESSARY WORD WHICH CREATES ERRORS IN YAML RECIPE RENDITION
    print("\n>>>> Printing: List BEFORE deleting the WORD <<<<") ;
    print(ins_list) ;

    for word_to_delete in ['!!instructions','!!Instructions','!!INSTRUCTIONS']:
        try:
            ins_list.remove(word_to_delete) ## this word will be deleted from list
            print('\n >>>> SELECTED WORD = '+ word_to_delete + ' FOUND. So, it will be deleted <<<< \n') ;

        except:
            print('\n >>>> SELECTED WORD = '+ word_to_delete + ' NOT FOUND. So, it can not be deleted <<<< \n') ;


    print("\n>>>> Printing: List AFTER deleting the WORD <<<<") ;
    print(ins_list)
    ########

    ## If the first instruction line does not contain a '!!', then add an extra heading line
    ## to the instructions list
    if (re.search('!!',ins_list[0])) :
        ins_list = ins_list
    else :
        ins_list = ['!!Step by step instructions below:'] + ins_list

    for myins in ins_list:
        myins = myins.strip() ##removing leading + trailing spaces
        if myins != "" and myins.lower() != '!!instructions':
            if (re.search('^!!', myins)):
                myins = myins.replace('!!','')
                new_ins = '- \"@type\": HowToSection\n  name: \"' + myins + '\"\n  itemListElement:'
            else:
                new_ins = '  - "@type": HowToStep\n    text: \"' + myins + '\"'

            print(new_ins)
            MY_INSTRUCTIONS_FINAL = MY_INSTRUCTIONS_FINAL + new_ins + '\n'

    ##########################################################################
    ##########################################################################

    KEYWORDS	      =str(data_final.at[x,'KEYWORDS'])

    ## FIXING EXTRA SPACES AND TABS IN KEYWORDS
    ## THEN, REMOVING UNNECESSARY COMMAS AT THE END OF LINE
    KEYWORDS_REGEXED = re.sub(r"\s+", " ", KEYWORDS)
    KEYWORDS_REGEXED = re.sub(r",\s*$", " ", KEYWORDS_REGEXED)


    ##########################################################################
    ## REMOVING EMPTY LINES FROM SOME VARIABLES (ALSO REMOVING EMPTY WHITESPACES)
    ##########################################################################

    RECIPE_DESCRIPTION="".join([s for s in RECIPE_DESCRIPTION.strip().splitlines(True) if s.strip()])
    HTML_RECIPE_NOTES="".join([s for s in HTML_RECIPE_NOTES.strip().splitlines(True) if s.strip()])

    ##########################################################################
    ## PRINTING FINAL COLUMNS VARIABLES FROM ORIGINAL VARIABLES
    ##########################################################################

    print("\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    print( "Index " + str(x) + " // Line " + str(x+1) )
    print("\n")

    print("RECIPE_TITLE: " + RECIPE_TITLE)
    print("RECIPE_AUTHOR: " + RECIPE_AUTHOR)
    print("RECIPE_DESCRIPTION: " + RECIPE_DESCRIPTION)


    print("RECIPE_FEATURED_IMAGE: " + RECIPE_FEATURED_IMAGE)
    print("RECIPE_FILENAME: " + RECIPE_FILENAME)


    print("KEYWORDS_ORIGINAL: " + KEYWORDS)
    print("KEYWORDS_REGEXED: " + KEYWORDS_REGEXED)


    print("PREPTIME_FINAL: " + PREPTIME_FINAL)
    print("COOKTIME_FINAL: " + COOKTIME_FINAL)
    print("TOTALTIME_FINAL: " + TOTALTIME_FINAL)

    print("RECIPE_DATE: " + RECIPE_DATE)
    print('RECIPE_DATE_MGGK:', RECIPE_DATE_MGGK)
    print("YOUTUBE_VIDEO_ID: " + YOUTUBE_VIDEO_ID)

    print("URL: " + URL)
    print("MGGK_URL: " + MGGK_URL)

    print("YAML_RECIPE_FILENAME: " + YAML_RECIPE_FILENAME)

    print("MY_INGREDIENTS_FINAL: " + MY_INGREDIENTS_FINAL)
    print("MY_INSTRUCTIONS_FINAL: " + MY_INSTRUCTIONS_FINAL)

    print("CALORIES: " + CALORIES)
    print("CALORIES_SERVINGS: " + CALORIES_SERVINGS)
    print("RATING_VALUE: " + RATING_VALUE)
    print("RATING_USERS: " + RATING_USERS)
    print("HTML_RECIPE_NOTES: " + HTML_RECIPE_NOTES)


    ## SAVING THE RESULTS TO A CSV FILE

    print("\n====> PRINTING TO OUTPUT RECIPE_FILE ==> " + YAML_RECIPE_FILENAME )

    RECIPE_FILE = open(MY_YAML_DIR + "/" + YAML_RECIPE_FILENAME,'w')

    RECIPE_FILE.write('---')

    RECIPE_FILE.write('\n\"@context\": http://schema.org/')

    RECIPE_FILE.write('\n\n\"@type\": Recipe')

    RECIPE_FILE.write('\n\nname: \"' + RECIPE_TITLE + '\"')

    RECIPE_FILE.write('\n\ndescription: \"' + RECIPE_DESCRIPTION + '\"')

    RECIPE_FILE.write('\n\nimage:')
    RECIPE_FILE.write('\n  - ' + RECIPE_FEATURED_IMAGE )

    RECIPE_FILE.write('\n\nprepTime: ' + PREPTIME_FINAL)
    RECIPE_FILE.write('\n\ncookTime: ' + COOKTIME_FINAL)
    RECIPE_FILE.write('\n\ntotalTime: ' + TOTALTIME_FINAL)
    RECIPE_FILE.write('\n\nrecipeCategory: ' + CATEGORY)
    RECIPE_FILE.write('\n\nrecipeCuisine: ' + CUISINE)
    RECIPE_FILE.write('\n\nrecipeYield: ' + SERVINGS)

    RECIPE_FILE.write('\n\naggregateRating:')
    RECIPE_FILE.write('\n  \"@type\": AggregateRating')
    RECIPE_FILE.write('\n  ratingValue: ' + RATING_VALUE)
    RECIPE_FILE.write('\n  ratingCount: ' + RATING_USERS)

    RECIPE_FILE.write('\n\nnutrition:')
    RECIPE_FILE.write('\n  \"@type\": NutritionInformation')
    RECIPE_FILE.write('\n  calories: ' + CALORIES + ' calories')
    RECIPE_FILE.write('\n  servingSize: '+ CALORIES_SERVINGS)

    RECIPE_FILE.write('\n\nauthor:')
    RECIPE_FILE.write('\n  \"@type\": Person')
    RECIPE_FILE.write('\n  name: Anupama Paliwal')
    RECIPE_FILE.write('\n  brand: My Ginger Garlic Kitchen')
    RECIPE_FILE.write('\n  url: https://www.MyGingerGarlicKitchen.com')

    RECIPE_FILE.write('\n\nrecipeNotes: \"'+ HTML_RECIPE_NOTES + '\"')

    RECIPE_FILE.write('\n\nkeywords: \"'+ KEYWORDS_REGEXED + '\"')

    ############# VIDEO BLOCK ####################################
    if YOUTUBE_VIDEO_ID !="" and YOUTUBE_VIDEO_ID != "['ZZZZ - NOTHING FOUND for youtube_video_id']" :
        RECIPE_FILE.write('\n\nvideo:')
        RECIPE_FILE.write('\n  \"@type\": \"VideoObject\"')
        RECIPE_FILE.write('\n  name: \"' + RECIPE_TITLE + '\"')
        RECIPE_FILE.write('\n  description: \"' + RECIPE_DESCRIPTION + '\"')
        RECIPE_FILE.write('\n  thumbnailUrl:')
        RECIPE_FILE.write('\n    - ' + RECIPE_FEATURED_IMAGE )
        RECIPE_FILE.write('\n    - https://www.mygingergarlickitchen.com/wp-content/youtube_video_cover_images/'+ YOUTUBE_VIDEO_ID +'.jpg')
        RECIPE_FILE.write('\n  contentUrl: \"https://youtu.be/'+ YOUTUBE_VIDEO_ID + '\"')
        RECIPE_FILE.write('\n  embedUrl: \"https://www.youtube.com/embed/'+ YOUTUBE_VIDEO_ID + '\"')
        RECIPE_FILE.write('\n  uploadDate: '+ RECIPE_DATE_MGGK)
    ##############################################################

    RECIPE_FILE.write('\n\ndatePublished: '+ RECIPE_DATE_MGGK)

    RECIPE_FILE.write('\n\nurl: '+ MGGK_URL)

    ################################################################
    ###################
    def ingr_inst_sample_block_print():
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
    ###################
    #ingr_inst_sample_block_print()
    RECIPE_FILE.write('\n\nrecipeIngredient:')
    RECIPE_FILE.write('\n' + MY_INGREDIENTS_FINAL)
    RECIPE_FILE.write('\n\nrecipeInstructions:')
    RECIPE_FILE.write('\n' + MY_INSTRUCTIONS_FINAL)

    #################################################################

    RECIPE_FILE.close()

    ##########################################################################
    ## CREATING AN HTML INDEX FILE TO MAKE ANU'S WORK EASY.
    ## THIS INDEX FILE WILL CONTAIN THE MARKDOWN FILENAME + CORRESPONDING YAML RECIPE FILENAME
    print("\n====> APPENDING TO AN HTML INDEX FILE TO MAKE ANU'S WORK EASY ==> " + TMP_STEP2_INDEX_FILE )

    TMP_INDEX = open(TMP_STEP2_INDEX_FILE,'a+')
    TMP_INDEX.write('<h2>FILE # ' + str(x+1) + ' = ' + RECIPE_TITLE + '</h2> <p>URL: <a href="'+ URL + '">' + URL + '</a> <br>HUGO MARKDOWN FILENAME = <TEXTAREA ROWS="1" COLS="150">' + RECIPE_FILENAME + '</TEXTAREA> <br>YAML RECIPE FILENAME = <TEXTAREA ROWS="1" COLS="150">' + MY_YAML_DIR + '/' + YAML_RECIPE_FILENAME + '</TEXTAREA></p>' )
    TMP_INDEX.close()

    ##########################################################################
    ## CREATING A BASH SCRIPT FILE TO MAKE ANU'S WORK EASY.
    ## THIS INDEX FILE WILL CONTAIN THE ATOM LINKS TO OPEN MARKDOWN FILENAME + CORRESPONDING YAML RECIPE FILENAME
    print("\n====> APPENDING TO A BASH SCRIPT FILE TO MAKE ANU'S WORK EASY ==> " + AUTOCREATED_BASH_SCRIPT )
    BASHFILE = open(AUTOCREATED_BASH_SCRIPT,'a+')
    BASHFILE.write( '\nif [ $VAR = "' + str(x+1) + '" ] ; then' )
    BASHFILE.write( '\necho "YOU ENTERED $VAR" ;' )
    BASHFILE.write( '\necho "====> OPENING: \n==> ' + URL + '\n==> ' + RECIPE_FILENAME + '\n==> ' + MY_YAML_DIR + '/' + YAML_RECIPE_FILENAME + '"' )
    BASHFILE.write( '\n\nopen ' + URL )
    BASHFILE.write( '\n# atom ' + RECIPE_FILENAME )
    BASHFILE.write( '\natom ' + MY_YAML_DIR + '/' + YAML_RECIPE_FILENAME )
    BASHFILE.write( '\nfi\n\n' )
    BASHFILE.close()


##############################################################################
############ END: MAIN FOR LOOP FOR EACH ROW ###############################
##############################################################################

## FINAL PRINTING
print('====> Printing all column names in dataframe = data_final')
for colname in data_final.columns:
    print(colname)


################################################################################
