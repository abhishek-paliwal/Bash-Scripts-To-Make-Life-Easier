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
    ## THIS PYTHON SCRIPT PARSES THE YAML FRONTMATTER METADATA FROM HUGO MARKDOWN FILES.
    ## FOUND BY PARSING ALL THE MARKDOWN FILES IN ROOTDIR
    ## THEN CREATES PDF FILES FOR ALL THE RECIPE VALID RECIPE FILES AND SAVES THEM
    ## TO APPROPRIATE DIRECTORY.
    #######################################
    ## IMPORTANT NOTE:
    ## This program needs these python packages => python-frontmatter + fpdf
    ## FRONTMATTER: Install: from: https://github.com/eyeseast/python-frontmatter
    ## FPDF: Tutorial: https://pyfpdf.readthedocs.io/en/latest/Tutorial/index.html
    #######################################
    ## MADE ON: JUNE 16 2021
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
## Tutorial here: https://pyfpdf.readthedocs.io/en/latest/Tutorial/index.html
from fpdf import FPDF

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
LOGO_IMAGE = MYHOME + "/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/logos/logo-mggk-for-pdfs-100px.png"
#ROOTDIR = MYHOME_WIN + "/Desktop/Y/recipes_demo/"
PDFDIR = MYHOME_WIN + "/Desktop/Y/PRINT-PDFs/"
ROOTDIR = MYHOME + "/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/"
#PDFDIR = MYHOME + "/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/PRINT-PDFs/"
## Create dir if not exists
if not os.path.exists(PDFDIR):
    os.mkdir(PDFDIR)
##    
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
        ## PRINTING ALL DATA TO A PDF FILE
        ##------------------------------------------------------------------------------
        PDF_FILENAME = 'PDF-' + URL_NO_SLASHES + '.pdf'
        pdf = FPDF('P', 'mm', 'A4')
        ##
        effective_page_width = pdf.w - 2*pdf.l_margin ; ## in mm        
        page_width = pdf.w  # in mm
        page_height = pdf.h  # in mm
        chosen_box_height = 7 ; ## in mm
        ##

        pdf.add_page()
        pdf.set_font('Arial', 'B', 16)

        ## print website logo
        pdf.image(LOGO_IMAGE, x=page_width/2.6, y=None, w=0, h=0, type='', link=URL_MGGK)
        ## line break
        pdf.ln(chosen_box_height)

        ##
        #print RECIPE URL LINK:
        pdf.set_font('Arial', '', 9)
        pdf.set_text_color(0, 0, 255)
        pdf.set_fill_color(220, 220, 220)  # fill color to grey
        pdf.cell(effective_page_width, chosen_box_height,
                 'RECIPE DOWNLOADED FROM: My Ginger Garlic Kitchen Food Website', border=0, ln=1, align='C')
        pdf.multi_cell(effective_page_width, chosen_box_height,
                       URL_MGGK, border=0, align='C', fill=True)
        pdf.set_fill_color(0, 0, 0)  # fill color reset
        ## line break
        pdf.ln(chosen_box_height)


        ## print recipe image
        recipeImage = MYHOME + \
            '/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/wp-content/rich-markup-images/4x3/4x3-' + \
            URL_NO_SLASHES + '.jpg'
        pdf.image(recipeImage, x=10, y=None,
                  w=effective_page_width, h=0, type='', link=URL_MGGK)
        ## line break
        pdf.ln(chosen_box_height)


        #print TITLE:
        pdf.set_font('Times', 'B', 30)
        pdf.set_text_color(205,30,100)
        TITLE = remove_unreadable_characters(TITLE)
        pdf.multi_cell(effective_page_width, chosen_box_height*2, TITLE + ' [RECIPE]', border=0, align='C', fill=False)
        pdf.set_text_color(0, 0, 0)  # text color reset



        pdf.add_page()

        #print description
        #through multi_cell => it requires declaring the height of the cell.
        pdf.set_font('Arial', '', 16)
        pdf.set_text_color(205,30,100)
        YOAST_DESCRIPTION = remove_unreadable_characters(YOAST_DESCRIPTION)
        pdf.multi_cell(effective_page_width, chosen_box_height, YOAST_DESCRIPTION, border=0, align='L', fill=False )
        pdf.ln(chosen_box_height)
        pdf.set_text_color(0, 0, 0) ## text color reset


        #print PREPTIME, COOKTIME, TOTALTIME
        pdf.set_font('Arial', 'B', 12)
        time_fulltext='Prep Time = ' + PREPTIME + ' // Cook Time = ' + COOKTIME + ' // Total Time = ' + TOTALTIME ;
        pdf.cell(effective_page_width, chosen_box_height, time_fulltext, 0, 1, 'R')

        #print category, cuisine, serves
        pdf.set_font('Arial', 'B', 12)
        category_fulltext='Category = ' + RECIPE_CATEGORY + ' // Cuisine = ' + RECIPE_CUISINE + ' // Serves = ' + RECIPE_YIELD ;
        pdf.cell(effective_page_width, chosen_box_height, category_fulltext, 0, 1, 'R')

        #print calories, serving_size
        pdf.set_font('Arial', 'B', 12)
        nutrition_fulltext='Nutrition Info = ' + str( NUTRITION.get("calories") ) + ' // Serving Size = ' + str( NUTRITION.get("servingSize") ) ;
        pdf.cell(effective_page_width, chosen_box_height, nutrition_fulltext, 0, 1, 'R')
    
        ##------------------------------------------------------------------------------
        #print recipe ingredients
        pdf.ln(chosen_box_height)
        pdf.set_font('Arial', '', 13)
        pdf.set_fill_color(220, 220, 220)  # fill color to grey
        pdf.multi_cell(effective_page_width, chosen_box_height*1.5,
                       "RECIPE INGREDIENTS", border=0, align='C', fill=True)
        pdf.set_fill_color(0, 0, 0)  # fill color reset
        ##
        count=1
        for ingr_group in RECIPE_INGREDIENTS:
            print(type(ingr_group)) ## should be dictionary
            print(list(ingr_group.keys())) ## printing all keys in dictionary, as list
            print()
            ingr_group_title = ingr_group.get("recipeIngredientTitle")
            print(ingr_group_title)
            pdf.set_font('Arial', 'B', 13)
            ingr_group_title = remove_unreadable_characters(ingr_group_title)
            pdf.multi_cell(effective_page_width, chosen_box_height*2,
                           '»   ' + ingr_group_title, border=0, align='L', fill=False)
            list_ingredients= ingr_group.get("recipeIngredientList")
            for ingr in list_ingredients:
                print(ingr)
                pdf.set_font('Arial', '', 12)
                ingr = remove_unreadable_characters(ingr)
                pdf.multi_cell(effective_page_width, chosen_box_height, str(count) + '.   ' + ingr, 0, 1, 'L') 
                count=count+1   

        ##------------------------------------------------------------------------------
        #print recipe instructions
        pdf.ln(chosen_box_height)
        pdf.set_font('Arial', '', 13)
        pdf.set_fill_color(220, 220, 220)  # fill color to grey
        pdf.multi_cell(effective_page_width, chosen_box_height*1.5,"RECIPE INSTRUCTIONS", border=0, align='C', fill=True)
        pdf.set_fill_color(0, 0, 0)  # fill color reset
        ##
        count=1
        for ingr_group in RECIPE_INSTRUCTIONS:
            print(type(ingr_group)) ## should be dictionary
            print(list(ingr_group.keys())) ## printing all keys in dictionary, as list
            print()
            ingr_group_title = ingr_group.get("recipeInstructionsTitle")
            print(ingr_group_title)
            pdf.set_font('Arial', 'B', 13)
            ingr_group_title = remove_unreadable_characters(ingr_group_title)
            pdf.multi_cell(effective_page_width, chosen_box_height*2,
                           '»   ' + ingr_group_title, border=0, align='L', fill=False)
            list_ingredients= ingr_group.get("recipeInstructionsList")
            for ingr in list_ingredients:
                print(ingr)
                pdf.set_font('Arial', '', 12)
                ingr = remove_unreadable_characters(ingr)
                pdf.multi_cell(effective_page_width, chosen_box_height, str(count) + '.   ' + ingr, 0, 1, 'L') 
                count=count+1   
        
        ##------------------------------------------------------------------------------
        #print recipe notes
        pdf.ln(chosen_box_height)
        count=1
        pdf.set_font('Arial', '', 13)
        pdf.set_fill_color(220, 220, 220)  # fill color to grey
        pdf.multi_cell(effective_page_width, chosen_box_height*1.5,"RECIPE NOTES", border=0, align='C', fill=True)
        pdf.set_fill_color(0, 0, 0)  # fill color reset
        for single_note in RECIPE_NOTES:
            pdf.set_font('Arial', '', 12)
            single_note = remove_unreadable_characters(single_note)
            pdf.multi_cell(effective_page_width, chosen_box_height, str(count) + '.   ' + single_note, 0, 1, 'L')
            count=count+1

        ##------------------------------------------------------------------------------
        ## FINAL PDF OUTPUT FOR THIS RECIPE 
        pdf.output(PDFDIR + PDF_FILENAME, 'F')
        print();
        print('PDF File Saved => ' + PDFDIR + PDF_FILENAME) ;
        print();

        ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        ## SUMMARY PRINTING
        ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        print(">> PDF SUMMARY (in millimeters): ") ;
        print("Page Height = {} // Page width = {} // Effective Page Width = {} // Chosen Box Height = {}".format(page_height, page_width,
                                      effective_page_width, chosen_box_height))

###############################################################################
############################# PROGRAM ENDS ####################################
