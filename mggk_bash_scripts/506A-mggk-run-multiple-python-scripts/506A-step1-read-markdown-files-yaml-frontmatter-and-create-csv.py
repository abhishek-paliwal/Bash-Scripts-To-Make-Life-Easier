#!/anaconda3/bin/python3
##############################################################################
## THIS PYTHON SCRIPT PARSES THE YAML FRONTMATTER METADATA FROM HUGO MARKDOWN FILES.
## FOUND BY PARSING ALL THE MARKDOWN FILES IN ROOTDIR
## THEN CREATE A COMBINED CSV FILE FOR ALL THE RELEVANT YAML KEYS
#######################################
## IMPORTANT NOTE:
## This program needs python package = python-frontmatter
## Install it by learning from: https://github.com/eyeseast/python-frontmatter
#######################################
## MADE ON: MAY 09 2019
## BY: PALI
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
ROOTDIR = MYHOME + "/Github/ZZ-HUGO-TEST/content/blog/2-fixed-by-anu/"
## printing all filenames found in ROOTDIR
for filename in glob.iglob(ROOTDIR + '**/*.md', recursive=True):
    print(filename)
##############################################################################

## CREATING A STRING WHICH WILL BE APPENDED LATER
## FIRST INITIALIZING THAT STRING WITH THE COLUMNS NAME HEADERS
FINAL_ALL_RECIPE_ROWS=str( "URL,RECIPE_TITLE,RECIPE_AUTHOR,RECIPE_DATE,RECIPE_FEATURED_IMAGE,RECIPE_FILENAME,RECIPE_DESCRIPTION" )

print("\n\n////////////////////// REAL MAGIC HAPPENS BELOW //////////////////\n\n" )

# LOOPING THROUGH ALL MARKDOWN FILES
for fname in glob.iglob(ROOTDIR + '**/*.md', recursive=True):
    with io.open(fname, 'r') as f:
        # Parse file's front matter
        post = frontmatter.load(f)

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
        FINAL_ALL_RECIPE_ROWS = FINAL_ALL_RECIPE_ROWS + "\n" + str( SEP + URL + SEP + "," + SEP + TITLE + SEP + "," + SEP + AUTHOR + SEP +  "," + SEP + DATE + SEP +  "," + SEP + FEATURED_IMAGE + SEP + "," + SEP + FILENAME + SEP + "," + SEP + YOAST_DESCRIPTION + SEP )

##
print(FINAL_ALL_RECIPE_ROWS)

## SAVING THE RESULTS TO A CSV FILE
print("\n====> PRINTING TO OUTPUT CSV FILE.")
OUTFILE_CSV = open("_TMP_STEP1_OUTPUT.CSV",'w')
OUTFILE_CSV.write(FINAL_ALL_RECIPE_ROWS)
OUTFILE_CSV.close()

###############################################################################
############################# PROGRAM ENDS ####################################
