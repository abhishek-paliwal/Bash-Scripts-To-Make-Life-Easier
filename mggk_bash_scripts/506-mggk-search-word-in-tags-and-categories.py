##############################################################################
## THIS SCRIPT PARSES THE YAML FRONTMATTER METADATA FROM HUGO MARKDOWN FILES.
## IT ALSO SEARCHES FOR A SEARCH TERM AND FINDS THAT WORD IN THE TAGS AND CATEGORIES
## FOUND BY PARSING ALL THE MARKDOWN FILES IN ROOTDIR
#######################################
## IMPORTANT NOTE:
## This program needs python package = python-frontmatter
## Install it by learning from: https://github.com/eyeseast/python-frontmatter
#######################################
## MADE ON: APRIL 02 2019
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
ROOTDIR = MYHOME + "/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/"
## printing all filenames found in ROOTDIR
for filename in glob.iglob(ROOTDIR + '**/*.md', recursive=True):
    print(filename)
##############################################################################

## CREATING TWO EMPTY LISTS TO BE POPULATED LATER
finalTags=[]
finalCategories=[]

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

        ## PRINTING METADATA VALUES + OTHER STUFF
        print("TITLE: " + str(post['title'])) ## Prints title metadata value from yaml frontmatter
        print("AUTHOR: " + str(post['author'])) ## Prints author
        print("DATE: " + str(post['date'])) ## Prints date
        print("URL: " + str(post['url'])) ## Prints url
        print("FEATURED-IMAGE: " + str(post['featured_image'])) ## Prints featured_image
        print("YOAST-DESCRIPTION: " + str(post['yoast_description'])) ## Prints yoast_description
        print("YOUTUBE-VIDEO-ID: " + str(post['youtube_video_id'])) ## Prints youtube_video_id
        #print("MGGK-JSON-RECIPE: " + post['mggk_json_recipe']) ## Prints mggk_json_recipe

        print("CATEGORIES: " + str(post['categories'])) ## printing cagtegories found in frontmatter
        print("TAGS: " + str(post['tags'])) ## printing tags found in frontmatter

        ######### APPENDING TO ALL TAGS/CATEGORIES list
        finalTags = finalTags + post['tags']
        finalCategories = finalCategories + post['categories']

###############################################################################
########################### FOR TAGS
###############################################################################
##### CONVERTING TO SET FOR UNIQUE VALUES + FINAL PRINTING
## converting to lowercase
finalTags = [x.lower() for x in finalTags ]
## converting to a set for getting the unique values
finalTagsUniq = list(sorted(set(finalTags)))

print("\n>>>>>> PRINTING ALL FINAL TAGS FOUND IN FILES")
for t in finalTagsUniq:
    print(" - " + t)

###############################################################################
########################### FOR CATEGORIES
###############################################################################
##### CONVERTING TO SET FOR UNIQUE VALUES + FINAL PRINTING
## converting to lowercase
finalCategories = [x.lower() for x in finalCategories ]
## converting to a set for getting the unique values
finalCategoriesUniq = list(sorted(set(finalCategories)))

print("\n>>>>>> PRINTING ALL FINAL CATEGORIES FOUND IN FILES")
for t in finalCategoriesUniq:
    print(" - " + t)

###############################################################################
#################### FINDING THE SEARCH WORDS IN ALL THE TAGS THUS FOUND
###############################################################################
print("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
print("\nYOU NOW NEED TO ENTER YOUR MULTIPLE SEARCH TERMS BELOW. THE PROGRAM WILL THEN SEARCH FOR THAT WORD IN ALL THE TAGS AND CATEGORIES IN ALL YOUR MARKDOWN POSTS.") ;
print("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")

print("\n >>>>[Case Independent] ENTER YOUR SEARCH TERMS :") ;
print(" >>>> Press ENTER after every line // Finally press CTRL+D after entering your last line. Program will begin its SEARCH then.): \n") ;

## PROMPTING USER FOR SINGLE LINE INPUT
## searchTerm = input("\n >>>> ENTER YOUR SEARCH TERM [Case Independent]: \n") ;
##
## PROMPTING USER FOR MULTILINE INPUT
searchTermListInput = sys.stdin.readlines() ## NOTE: this will insert \n after every line

print("\n\n####################################################################") ;
print("Entered SEARCH TERMS ARRAY LIST as it is = ") ;
print(searchTermListInput) ;

##
## Stripping newlines characters (\n) inserted automatically. Else, the program
## does not find the entered search Terms because they all have these extra characters.
##
searchTermList = list( map(lambda each:each.strip("\n"), searchTermListInput) ) ;
print("\nEntered SEARCH TERMS ARRAY LIST after stripping \\n = ") ;
print(searchTermList) ;
print("####################################################################\n") ;

joinString="\n - " ;

## FOR LOOP FOR TAGS
print("\n>>>>>> NOW PRINTING ALL TAGS CONTAINING YOUR SEARCH TERMS = ") ;
for searchTerm in searchTermList:
    #print(">>>>>>>>>>>>>>>>>>>>>> " + searchTerm + " <<<<<<<<<<<<<<<<<<<<<<<<<<<<<") ;
    print( '{1}{0}{1}'.format(joinString.join( s for s in finalTagsUniq if searchTerm.lower() in s.lower() ) , joinString) ) ;

## FOR LOOP FOR CATEGORIES
print("\n>>>>>> NOW PRINTING ALL CATEGORIES CONTAINING YOUR SEARCH TERMS = ") ;
for searchTerm in searchTermList:
    #print(">>>>>>>>>>>>>>>>>>>>>> " + searchTerm + " <<<<<<<<<<<<<<<<<<<<<<<<<<<<<") ;
    print( '{1}{0}{1}'.format(joinString.join( s for s in finalCategoriesUniq if searchTerm.lower() in s.lower() ) , joinString) ) ;

###############################################################################
############################# PROGRAM ENDS ####################################
