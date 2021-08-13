##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USAGE FOR PYTHON
## Print this help as >> this_script_name --help
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
import sys
####
def usage():
    print('## USAGE: ' + sys.argv[0])
    HELP_TEXT = """
    ##############################################################################
    ## THIS PYTHON SCRIPT PARSES THE YAML FRONTMATTER METADATA FROM HUGO 
    ## MARKDOWN FILES.
    ## IT THEN CREATES PRINT READY HTML FILES FOR ALL THE VALID RECIPE FILES 
    ## AND SAVES THEM TO APPROPRIATE DIRECTORY.
    #######################################
    ## IMPORTANT NOTE:
    ## This program needs these python packages => python-frontmatter
    ## FRONTMATTER: Install: from: https://github.com/eyeseast/python-frontmatter
    #######################################
    ## MADE ON: 2021-08-13
    ## BY: PALI
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

##############################################################################
##############################################################################

import frontmatter
import io
import os
from os.path import basename, splitext
import glob
import sys
import re

##############################################################################

##################################################################################
## VARIABLE INITIALIZATION
## IF THE HOME USER IS UBUNTU, CHANGE THE HOME PATH (BCOZ WE ARE USING WSL)
## WHERE ARE THE FILES TO MODIFY (is it on WSL or elsewhere on MAC, for eg.)
if os.environ['USER'] == "ubuntu":
    MYHOME = os.environ['HOME'] 
    MYHOME_WIN = os.environ['HOME_WINDOWS']
else:
    MYHOME = os.environ['HOME']
    MYHOME_WIN = os.environ['HOME']

#######################################
#ROOTDIR = MYHOME_WIN + "/Desktop/Y/recipes_demo/"
HTMLPRINTDIR = MYHOME_WIN + "/Desktop/X/"
ROOTDIR = MYHOME + "/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/"
#HTMLPRINTDIR = MYHOME + "/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/PRINT-RECIPES/"
## printing all filenames found in ROOTDIR
for filename in glob.iglob(ROOTDIR + '**/*.md', recursive=True):
    print(filename)
##############################################################################

##################################################################################
## DEFINE HTML TAGS and UNPRINTABLE CHARACTERS CLEANING FUNCTION
def remove_unreadable_characters(some_text):
    ## replace some unprintable characters
    some_text = some_text.replace("\u2013", "-") #replace en dash
    some_text = some_text.replace("\u2014", "-") #replace em dash
    ## clean html tags (if any)
    cleanr = re.compile('<.*?>')
    some_text = re.sub(cleanr, '', some_text)
    ## finally replace any more unreadable characters to question marks
    some_text = some_text.encode('latin-1', 'replace').decode('latin-1') ;                 
    return some_text 
##################################################################################

## CREATING A STRING WHICH WILL BE APPENDED LATER
## FIRST INITIALIZING THAT STRING WITH THE COLUMNS NAME HEADERS
FINAL_ALL_RECIPE_ROWS=str( "URL,RECIPE_TITLE,RECIPE_AUTHOR,RECIPE_DATE,RECIPE_FEATURED_IMAGE,RECIPE_FILENAME,RECIPE_DESCRIPTION" )

print("\n\n////////////////////// REAL MAGIC HAPPENS BELOW //////////////////\n\n" )

# LOOPING THROUGH ALL MARKDOWN FILES
for fname in glob.iglob(ROOTDIR + '**/*.md', recursive=True):
    with io.open(fname, 'r') as f:
        ####################################
        # Parse file's front matter
        post = frontmatter.load(f)
        ####################################
        ## CHECK WHETHER THIS FILE IS A RECIPE FILE
        ## WE'LL CHECK IF PREPTIME TAG IS PRESENT IN ALL YAML TAGS THUS FOUND
        if 'prepTime' not in str(sorted(post.keys())) :
            print('=> NOT A VALID RECIPE FILE ... Skipping this, and moving onto the next file ...')
            print() ;
            continue;
        ####################################
        ######################################################################
        ## ASSIGN NEW VALUES IF NO VALUES FOR KEYS ARE FOUND
        #MYKEYS = ["title","author","date","url","featured_image","yoast_description","youtube_video_id","mggk_json_recipe","tags","categories"]

        MYKEYS = ['aggregateRating', 'author', 'categories', 'cookTime', 'date', 'featured_image', 'first_published_on', 'mggk_json_recipe', 'my_custom_variable', 'nutrition', 'prepTime', 'recipeCategory', 'recipeCuisine', 'recipeIngredient', 'recipeInstructions', 'recipeNotes', 'recipeYield', 'recipe_code_image', 'recipe_keywords', 'steps_images_present', 'tags', 'title', 'totalTime', 'type', 'url', 'yoast_description', 'youtube_video_id']

        for p in MYKEYS:
            if post.get(p) == None:
                post[p] = ['ZZZZ - NOTHING FOUND for ' + p]
        ######################################################################

        ## PRINTING PRIMARY STUFF
        print("\n#########################\n") ## prints line
        print("FILENAME: " + fname) ## printing filename
        print("SORTED-KEYS-FOUND: " + str(sorted(post.keys()))) ## prints all metadata keys


        ## ASSIGNING VARIABLES
        FILENAME=str(fname)        
        TITLE=str(post['title'])
        AUTHOR=str(post['author'])
        DATE=str(post['date'])
        FEATURED_IMAGE=str(post['featured_image'])
        YOAST_DESCRIPTION=str(post['yoast_description'])
        YOUTUBE_VIDEO_ID=str(post['youtube_video_id'])
        CATEGORIES=str(post['categories'])
        TAGS=str(post['tags'])
        MGGK_JSON_RECIPE=str(post['mggk_json_recipe'])
        
        ## TIMES
        PREPTIME=str(post['prepTime'])
        COOKTIME=str(post['cookTime'])
        TOTALTIME=str(post['totalTime'])
        
        ## NUTRITION INFO
        NUTRITION=post['nutrition']
        RECIPE_YIELD=str(post['recipeYield'])
        RECIPE_CUISINE=str(post['recipeCuisine'])   
        RECIPE_CATEGORY=str(post['recipeCategory'])
        
        ## INGREDIENTS AND INSTRUCTIONS
        RECIPE_INGREDIENTS=post['recipeIngredient']
        RECIPE_INSTRUCTIONS=post['recipeInstructions']
        RECIPE_NOTES=post['recipeNotes']

        ## URL FORMATTING
        URL = str(post['url'])
        URL_NO_SLASHES = URL.replace("/", "") ## replace all slashes
        URL_MGGK = str("https://www.mygingergarlickitchen.com" + URL )



        ## PRINTING METADATA VALUES + OTHER STUFF
        print("TITLE: " + TITLE ) ## Prints title metadata value from yaml frontmatter
        print("AUTHOR: " + AUTHOR ) ## Prints author
        print("DATE: " + DATE ) ## Prints date
        print("URL: " + URL ) ## Prints url
        print("FEATURED_IMAGE: " + FEATURED_IMAGE ) ## Prints featured_image
        print("YOAST_DESCRIPTION: " + YOAST_DESCRIPTION ) ## Prints yoast_description
        print("YOUTUBE_VIDEO_ID: " + YOUTUBE_VIDEO_ID ) ## Prints youtube_video_id
        print("CATEGORIES: " + CATEGORIES ) ## printing cagtegories found in frontmatter
        print("TAGS: " + TAGS ) ## printing tags found in frontmatter
        #print("MGGK_JSON_RECIPE: " + MGGK_JSON_RECIPE ) ## Prints mggk_json_recipe
        ##
        print("PREPTIME: " + PREPTIME )
        print("COOKTIME: " + COOKTIME )
        print("TOTALTIME: " + TOTALTIME )
        ##
        print("NUTRITION: " + str(NUTRITION) )
        print("RECIPE_YIELD: " + RECIPE_YIELD )
        print("RECIPE_CUISINE: " + RECIPE_CUISINE )
        print("RECIPE_CATEGORY: " + RECIPE_CATEGORY )
        ##
        print("RECIPE_INGREDIENTS: " + str(RECIPE_INGREDIENTS) )
        print("RECIPE_INSTRUCTIONS: " + str(RECIPE_INSTRUCTIONS) )
        print("RECIPE_NOTES: " + str(RECIPE_NOTES) ) 
    
        ##
        print()
        print()
        print(type(RECIPE_INGREDIENTS)) ## should be list containing dictionary
        print(type(RECIPE_INSTRUCTIONS)) ## should be list containing dictionary
        print(type(RECIPE_NOTES)) ## should be a list

        ##
        print()
        for ingr_group in RECIPE_INGREDIENTS:
            print(type(ingr_group)) ## should be dictionary
            print(list(ingr_group.keys())) ## printing all keys in dictionary, as list
            print()
            print(ingr_group.get("recipeIngredientTitle"))
            list_ingredients= ingr_group.get("recipeIngredientList")
            for ingr in ingr_group.get("recipeIngredientList"):
                print(ingr)

        ##
        print()
        for instr_group in RECIPE_INSTRUCTIONS:
            print(type(instr_group)) ## should be dictionary
            print(list(instr_group.keys())) ## printing all keys in dictionary, as list
            print()
            print(instr_group.get("recipeInstructionsTitle"))
            list_instructions= instr_group.get("recipeInstructionsList")
            for instr in instr_group.get("recipeInstructionsList"):
                print(instr)

        ##
        print()
        for single_note in RECIPE_NOTES:
            print(single_note)

        ##------------------------------------------------------------------------------
        ## PRINTING ALL DATA TO A HTML FILE
        ##------------------------------------------------------------------------------
        HTML_FILENAME = 'RECIPE-PRINT-' + URL_NO_SLASHES + '.html'

        f = open(HTMLPRINTDIR + HTML_FILENAME,'w')

        htmlHeader = """<!doctype html>
        <html lang='en'>
        <head>
            <!-- Required meta tags -->
            <meta charset='utf-8'>
            <meta name='viewport' content='width=device-width, initial-scale=1'>
            <!-- Bootstrap CSS -->
            <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We' crossorigin='anonymous'>
            <title>"""

        htmlMidContent= "</title></head><body>"

        htmlFooter = """<!-- Optional JavaScript; choose one of the two! -->
            <!-- Option 1: Bootstrap Bundle with Popper -->
            <script src='https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js' integrity='sha384-U1DAWAznBHeqEIlVSCgzq+c9gqGAJn5c/t99JyeKa9xxaYpSvHU5awsuZVVFIhvj' crossorigin='anonymous'></script>
            </div>
            </main></body></html>"""

        f.write(htmlHeader)
        ##
        headTitle = remove_unreadable_characters(TITLE)
        f.write('PRINT RECIPE OF ' + headTitle)
        ##
        f.write(htmlMidContent)   

        ## print website logo
        logoImage = """<div class='container'>
<a href='https://www.mygingergarlickitchen.com'>
<img class='d-block mx-auto' src='https://www.mygingergarlickitchen.com/logos/mggk-new-logo-transparent-1000px.svg' alt='My Ginger Garlic Kitchen' width='100' height='81'>
</a>
</div><div class='container'>"""

        tagLine = "RECIPE DOWNLOADED FROM: My Ginger Garlic Kitchen Food Website"
        ##

        f.write(logoImage)
        f.write("<hr>")
        f.write(tagLine)
        
        #print RECIPE URL LINK:
        f.write('<div>' + URL_MGGK + '</div>')

        ####
        ## print recipe image + title
        recipeImage = '<div><img width="100%" src="https://www.mygingergarlickitchen.com/wp-content/rich-markup-images/4x3/4x3-' + URL_NO_SLASHES + '.jpg"></div>'
        ##
        ##
        #f.write(recipeImage)
        ####

        ## print title + description
        TITLE = remove_unreadable_characters(TITLE)
        YOAST_DESCRIPTION = remove_unreadable_characters(YOAST_DESCRIPTION)
        ##
        #f.write("<h1>" + TITLE + "</h1>")
        #f.write("<div style='color: rgb(205,30,100);'>" + YOAST_DESCRIPTION + "</div>")

        htmlJumbotron = """<main class='container'>
            <div class='bg-light p-5 rounded mt-3'>
            <h1>""" + TITLE + """</h1>
            <p class='lead'>""" + YOAST_DESCRIPTION + """</p>
            <a class='btn btn-lg btn-primary' href='#' role='button'>Print this recipe &raquo;</a>
            </div>"""    

        f.write(htmlJumbotron)   

        ##
        #print PREPTIME, COOKTIME, TOTALTIME + category, cuisine, serves + nutrition info
        time_fulltext='Prep Time = ' + PREPTIME + ' // Cook Time = ' + COOKTIME + ' // Total Time = ' + TOTALTIME ;
        category_fulltext='Category = ' + RECIPE_CATEGORY + ' // Cuisine = ' + RECIPE_CUISINE + ' // Serves = ' + RECIPE_YIELD ;
        nutrition_fulltext='Nutrition Info = ' + str( NUTRITION.get("calories") ) + ' // Serving Size = ' + str( NUTRITION.get("servingSize") ) ;
        ##
        f.write('<hr>')
        f.write('<div>' + time_fulltext + '</div>')
        f.write('<div>' + category_fulltext + '</div>')
        f.write('<div>' + nutrition_fulltext + '</div>')
    
        ##------------------------------------------------------------------------------
        #print recipe ingredients
        f.write('<hr>')
        f.write('<h2> RECIPE INGREDIENTS </h2>')
        ##
        count=1
        for ingr_group in RECIPE_INGREDIENTS:
            print(type(ingr_group)) ## should be dictionary
            print(list(ingr_group.keys())) ## printing all keys in dictionary, as list
            print()
            ingr_group_title = ingr_group.get("recipeIngredientTitle")
            print(ingr_group_title)
            ingr_group_title = remove_unreadable_characters(ingr_group_title)
            ##
            f.write('<h3>' + '»   ' + ingr_group_title + '</h3>')
            ##
            list_ingredients= ingr_group.get("recipeIngredientList")
            for ingr in list_ingredients:
                print(ingr)
                ingr = remove_unreadable_characters(ingr)
                ##
                f.write('<br>' + str(count) + '.   ' + ingr)
                ##
                count=count+1   

        ##------------------------------------------------------------------------------
        #print recipe instructions
        f.write('<hr>')
        f.write('<h2> RECIPE INSTRUCTIONS </h2>')
        ##
        count=1
        for ingr_group in RECIPE_INSTRUCTIONS:
            print(type(ingr_group)) ## should be dictionary
            print(list(ingr_group.keys())) ## printing all keys in dictionary, as list
            print()
            ingr_group_title = ingr_group.get("recipeInstructionsTitle")
            print(ingr_group_title)
            ingr_group_title = remove_unreadable_characters(ingr_group_title)
            ##
            f.write('<h3>' + '»   ' + ingr_group_title + '</h3>')
            ##
            list_ingredients= ingr_group.get("recipeInstructionsList")
            for ingr in list_ingredients:
                print(ingr)
                ingr = remove_unreadable_characters(ingr)
                ##
                f.write('<br>' + str(count) + '.   ' + ingr)
                ##
                count=count+1   
        
        ##------------------------------------------------------------------------------
        #print recipe notes
        f.write('<hr>')
        f.write('<h2> RECIPE NOTES </h2>')
        ##
        count=1
        for single_note in RECIPE_NOTES:
            single_note = remove_unreadable_characters(single_note)
            f.write('<br>' + single_note)
            count=count+1

        ##------------------------------------------------------------------------------
        ## printing final html elements
        f.write(htmlFooter)
        f.close()

        ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        ## SUMMARY FOR THIS MD FILE RECIPE
        ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        print();
        print('PRINT HTML File Saved => ' + HTMLPRINTDIR + HTML_FILENAME ) ;
        print();

###############################################################################
############################# PROGRAM ENDS ####################################
