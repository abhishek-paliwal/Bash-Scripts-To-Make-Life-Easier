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
    ## THEN CREATE A COMBINED CSV FILE FOR ALL THE RELEVANT YAML KEYS
    #######################################
    ## IMPORTANT NOTE:
    ## This program needs python package = python-frontmatter
    ## Install it by learning from: https://github.com/eyeseast/python-frontmatter
    #######################################
    ## MADE ON: MAY 23 2019
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

##############################################################################
## WHERE ARE THE FILES TO MODIFY
MYHOME = os.environ['HOME'] ## GETTING THE ENVIRONMENT VALUE FOR HOME
ROOTDIR = MYHOME+"/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/blog/_DONE_2_easyrecipe/"
OUTPUT_DIR = MYHOME+"/Desktop/Y"
OUTPUT_FILE = OUTPUT_DIR+"/_TMP_513_STEP1_OUTPUT.CSV"

## printing all filenames found in ROOTDIR
for filename in glob.iglob(ROOTDIR + '**/*.md', recursive=True):
    print(filename)
##############################################################################

## CREATING A STRING WHICH WILL BE APPENDED LATER
## FIRST INITIALIZING THAT STRING WITH THE COLUMNS NAME HEADERS
FINAL_ALL_RECIPE_ROWS=str( "URL,RECIPE_TITLE,RECIPE_AUTHOR,RECIPE_DATE,RECIPE_FEATURED_IMAGE,RECIPE_FILENAME,RECIPE_DESCRIPTION,YOUTUBE_VIDEO_ID" )

print("\n\n////////////////////// REAL MAGIC HAPPENS BELOW //////////////////\n\n" )

# LOOPING THROUGH ALL MARKDOWN FILES
for fname in glob.iglob(ROOTDIR + '**/*.md', recursive=True):
    with io.open(fname, 'r') as f:
        # Parse file's front matter
        post = frontmatter.load(f)

        ## Print all post content part
        print(post.content)

        ######################################################################
        ## ASSIGN NEW VALUES IF NO VALUES FOR KEYS ARE FOUND
        MYKEYS = ["title","author","date","url","featured_image","yoast_description","youtube_video_id","mggk_json_recipe","tags","categories"]

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
        URL=str("http://localhost:1313" + post['url'] )
        TITLE=str(post['title'])
        AUTHOR=str(post['author'])
        DATE=str(post['date'])
        FEATURED_IMAGE=str(post['featured_image'])
        YOAST_DESCRIPTION=str(post['yoast_description'])
        YOUTUBE_VIDEO_ID=str(post['youtube_video_id'])
        CATEGORIES=str(post['categories'])
        TAGS=str(post['tags'])
        MGGK_JSON_RECIPE=str(post['mggk_json_recipe'])

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


        ######### APPENDING
        SEP = "\"" ;
        FINAL_ALL_RECIPE_ROWS = FINAL_ALL_RECIPE_ROWS + "\n" + str( SEP + URL + SEP + "," + SEP + TITLE + SEP + "," + SEP + AUTHOR + SEP +  "," + SEP + DATE + SEP +  "," + SEP + FEATURED_IMAGE + SEP + "," + SEP + FILENAME + SEP + "," + SEP + YOAST_DESCRIPTION + SEP + "," + SEP + YOUTUBE_VIDEO_ID + SEP)

##
print(FINAL_ALL_RECIPE_ROWS)

## SAVING THE RESULTS TO A CSV FILE
print("\n====> PRINTING TO OUTPUT CSV FILE.")
OUTFILE_CSV = open(OUTPUT_FILE,'w')
OUTFILE_CSV.write(FINAL_ALL_RECIPE_ROWS)
OUTFILE_CSV.close()

###############################################################################
############################# PROGRAM ENDS ####################################
