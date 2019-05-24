## PYTHON FILE
###############################################################################
## THIS PYTHON SCRIPT USES BEAUTIFUL SOUP 4 LIBRARY TO EXTRACT ALL HTML CODE RECIPE
## VARIABLES PRESENT IN THE MARKDOWN FILES OF ALL ORIGINAL EASYRECIPE MD FILES
#### IT ALSO CREATES AN OUTPUT CSV FILE WITH ALL THOSE EXTRACTED VARIABLES
#### (SEE SUCCESS FILE).
###############################################################################
## CODED ON: May 22, 2019
## CODED BY: PALI
###############################################################################
###############################################################################

from bs4 import BeautifulSoup
from bs4.diagnose import diagnose
import urllib.request
import os
import glob
import csv
from datetime import datetime

###############################################################################
#### EXAMPLE USAGE FOR USING URL WITH BEAUTIFUL SOUP:
###############################################################################
#### IF USING A SPECIFIC URL FOR TESTING (UNCOMMENT FOLLOWING LINES)
#url = "https://www.mygingergarlickitchen.com/watermelon-onion-yogurt-chip-dip/"
#content = urllib.request.urlopen(url).read()
#soup = BeautifulSoup(content, 'html.parser' )
#print(soup.prettify())
#parse_my_soup()
###############################################################################
###############################################################################

###############################################################################
###################### REAL MAGIC HAPPENS BELOW ###############################
###############################################################################
## DEFINING SOME VARIABLES
MYHOME = os.environ['HOME']
DIRPATH = MYHOME+"/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/blog/_DONE_2_easyrecipe"
OUTPUT_DIR = MYHOME+"/Desktop/Y"
SUCCESS_FILE = OUTPUT_DIR+"/_TMP_513_STEP2_OUTPUT_FILE_AFTER_SUCCESS_RAW.CSV"
ERROR_FILE = OUTPUT_DIR+"/_TMP_513_CHECK_THIS_FILE_FOR_ERRORS.CSV"
FILELIST_USED = OUTPUT_DIR+"/_TMP_513_THIS_FILELIST_IS_USED.CSV"

## INITIALIZE SOME FILES FOR SUCCESS AND ERROR REPORTING
with open(SUCCESS_FILE, 'w') as csv_file:
    writer = csv.writer(csv_file)
    writer.writerow(["COUNT", "DATETIME_AT_PROGRAM_RUN", "RECIPE_FILENAME", "HTML_RECIPENAME", "HTML_RECIPEDESCRIPTION", "HTML_RECIPEAUTHOR", "PREPTIME", "COOKTIME", "TOTALTIME", "CATEGORY", "CUISINE", "SERVINGS","CALORIES","CALORIES_SERVINGS","KEYWORDS", "MY_INGREDIENTS_FINAL", "MY_INSTRUCTIONS_FINAL", "EXTRA_INGREDIENTS_RAW", "EXTRA_INSTRUCTIONS_RAW","EXTRA_INGREDIENTS_HEADINGS_RAW", "EXTRA_INSTRUCTIONS_HEADINGS_RAW", "EXTRA_INGREDIENTS_HEADINGS_ALL", "EXTRA_INSTRUCTIONS_HEADINGS_ALL"])

with open(ERROR_FILE, 'w') as csv_file:
    writer = csv.writer(csv_file)
    writer.writerow(["COUNT", "MYFILE", "DATETIME"])

with open(FILELIST_USED, 'w') as csv_file:
    writer = csv.writer(csv_file)
    writer.writerow(["COUNT", "FILENAME"])

#### ********************************************************************* ####
#### ********************************************************************* ####
## DEFINING MAIN FUNCTION
def parse_my_soup():
   try: recipename=soup.find('div', attrs={'class':'ERSName'}).string ;
   except Exception as e: recipename="NO-RECIPENAME-DEFINED" ;

   try: author=soup.find('span', attrs={'itemprop':'author'}).string ;
   except Exception as e: author="NO-AUTHOR-DEFINED" ;

   try: preptime=soup.find('time', attrs={'itemprop':'prepTime'})['datetime'] ;
   except Exception as e: preptime="NO-PREPTIME-DEFINED" ;

   try: cooktime=soup.find('time', attrs={'itemprop':'cookTime'})['datetime'] ;
   except Exception as e: cooktime="NO-COOKTIME-DEFINED" ;

   try: totaltime=soup.find('time', attrs={'itemprop':'totalTime'})['datetime'] ;
   except Exception as e: totaltime="NO-TOTALTIME-DEFINED" ;

   try: description=soup.find('div', attrs={'itemprop':'description'}).string ;
   except Exception as e: description="NO-DESCRIPTION-DEFINED" ;

   try: recipeCategory=soup.find('span', attrs={'itemprop':'recipeCategory'}).string ;
   except Exception as e: recipeCategory="NO-CATEGORY-DEFINED" ;

   try: recipeCuisine=soup.find('span', attrs={'itemprop':'recipeCuisine'}).string ;
   except Exception as e: recipeCuisine="NO-CUISINE-DEFINED" ;

   try: recipeServings=soup.find('span', attrs={'itemprop':'recipeYield'}).string ;
   except Exception as e: recipeServings="NO-RECIPEYIELD-DEFINED" ;

   CALORIES = "50" ; ## example value (do change it later)
   CALORIES_SERVINGS = "1 serving" ; ## example value (do change it later)

   ##### GENERATING RECIPE KEYWORDS ###########
   KEYWORDS = recipename.strip() ; ## assigning keywords
   KEYWORDS = KEYWORDS.lower() ; # converting to lowercase

   KEYWORDS = KEYWORDS.replace('&','') ;
   KEYWORDS = KEYWORDS.replace('!','') ;
   KEYWORDS = KEYWORDS.replace('//','') ;
   KEYWORDS = KEYWORDS.replace('|','') ;
   KEYWORDS = KEYWORDS.replace('[','') ;
   KEYWORDS = KEYWORDS.replace(']','') ;
   KEYWORDS = KEYWORDS.replace('(','') ;
   KEYWORDS = KEYWORDS.replace(')','') ;
   KEYWORDS = KEYWORDS.replace('{','') ;
   KEYWORDS = KEYWORDS.replace('}','') ;
   KEYWORDS = KEYWORDS.replace('-','') ;
   KEYWORDS = KEYWORDS.replace('+','') ;
   KEYWORDS = KEYWORDS.replace("'","\'") ;
   KEYWORDS = KEYWORDS.replace(' for ','') ;
   KEYWORDS = KEYWORDS.replace(' with ','') ;
   KEYWORDS = KEYWORDS.replace(' the ','') ;
   KEYWORDS = KEYWORDS.replace(' and ','') ;
   KEYWORDS = KEYWORDS.replace('video','') ;
   KEYWORDS = KEYWORDS.replace('recipe','') ;
   KEYWORDS = KEYWORDS.replace(' ',',') ; ## finally splitting recipename into keywords
   KEYWORDS = KEYWORDS.replace(',,',',') ; ## replacing multiple commas
   KEYWORDS = KEYWORDS.replace(', ','') ;



   ######### INGREDIENTS BLOCK ################################################
   try: ingredients_all=soup.find_all('li', attrs={'itemprop':'recipeIngredient'}) ;
   except Exception as e: ingredients_all="NO-INGREDIENTS-DEFINED" ;

   ingredients="" ## INITIALIZING EMPTY STRING
   for i in ingredients_all:
     ingredients=ingredients + "\n" +  str(i.string)
     ingredients=ingredients.strip()

   #####
   full_ingredients_htmlblock=soup.find(class_='ERSIngredients')
   ingredients_all_headings=full_ingredients_htmlblock.find_all(class_='ERSSectionHead')

   ingr_head_all=[] ## INITIALIZING EMPTY LIST
   for ingr_heading in ingredients_all_headings:
       ingr_head_all.append(ingr_heading.get_text())
   ############################################################################

   ######### INSTRUCTIONS BLOCK ###############################################
   try: instructions_all=soup.find_all('li', attrs={'itemprop':'recipeInstructions'}) ;
   except Exception as e: instructions_all="NO-INSTRUCTIONS-DEFINED" ;

   instructions="" ## INITIALIZING EMPTY STRING
   for i in instructions_all:
     instructions=instructions + "\n" +  str(i.string)
     instructions=instructions.strip()

   full_instructions_htmlblock=soup.find(class_='ERSInstructions')
   instructions_all_headings=full_instructions_htmlblock.find_all(class_='ERSSectionHead')

   instr_head_all=[] ## INITIALIZING EMPTY LIST
   for instr_heading in instructions_all_headings:
     instr_head_all.append(instr_heading.get_text())
   ############################################################################

   ###############################################################################
   ########## PRINTING OUT INSTRUCTIONS AND INGREDIENTS IN A NICER WAY TO BE
   ########## LATER USED UP IN YAML RECIPE FILES
   ###############################################################################
   ing = soup.find('div',class_='ERSIngredients')
   ins = soup.find('div',class_='ERSInstructions')
   #print(ing)
   #print(ins)
   ################################################################################
   ## WORKING WITH INGREDIENTS
   MYING = ""
   for x in ing:
           if x.name == 'div' :
               y = x.get_text()
               if y != "":
                   #print( "!!" + y )
                   MYING = MYING + "!!" + y + "\n"

           if x.name == 'ul':
               y = x.find_all('li')
               for i in y:
                   #print(i.string)
                   MYING = MYING + i.string + "\n"

   print(MYING)

   ################################################################################
   print("================ +++ ===================")
   ################################################################################
   ## WORKING WITH INSTRUCTIONS
   MYINS = ""
   for x in ins:
       if x.name == 'div' :
           y = x.get_text()
           if y != "":
               #print( "!!" + y )
               MYINS = MYINS + "!!" + y + "\n"

       if x.name == 'ol' :
           y = x.find_all('li')
           for i in y:
               #print(i.string)
               MYINS = MYINS + i.string + "\n"

   print(MYINS)

   ################################################################################
   ################################################################################

   ############################################################################
   print("\n\n===== PRINTING OUT VARIABLE VALUES ON COMMAND LINE ====\n")
   print(recipename)
   print(preptime)
   print(cooktime)
   print(totaltime)
   print(description)
   print(author)
   print(recipeCategory)
   print(recipeCuisine)
   print("=============================================")

   print("\n===== INGREDIENTS ====\n")
   print(ingredients)

   print("\n===== INSTRUCTIONS ====\n")
   print(instructions)

   #############################
   full_recipe_block=soup.find('div', attrs={'class':'easyrecipe'}) ;
   print("\n\n===== ORIGINAL HTML - PRETTIFIED =====\n")
   print(full_recipe_block.prettify())
   print("\n\n===== EXTRACTED RAW TEXT: EASYRECIPE BLOCK =====\n")
   print(full_recipe_block.get_text())

   #### CSV MAGIC = Opens a csv file with append, so old data will not be erased
   with open(SUCCESS_FILE, 'a') as csv_file:
       writer = csv.writer(csv_file)
       writer.writerow([count, datetime.now(), myfile, recipename, description, author, preptime, cooktime, totaltime, recipeCategory, recipeCuisine, recipeServings, CALORIES, CALORIES_SERVINGS, KEYWORDS, MYING, MYINS, ingredients, instructions, ingredients_all_headings, instructions_all_headings, ingr_head_all, instr_head_all ])

   return
#### ********************************************************************* ####
#### ********************************************************************* ####

###############################################################################
## LOOPING THROUGH ALL FILES IN DIRPATH
all_md_files = glob.glob(DIRPATH + '**/*.md', recursive=True) ;

########################################
c=0
for filename in all_md_files:
    c=c+1 ;
    with open(FILELIST_USED, 'a') as csv_filelist:
        writer_f = csv.writer(csv_filelist)
        writer_f.writerow([c,filename])

########################################
count=0
for myfile in all_md_files:
    print("\n\n////////////////////////////////////////////////////////////////\n") ;
    count=count+1
    print(count)
    print(myfile)

    fd = open(myfile, 'r')
    file_content=fd.read()  # could be write(), read(), readline(), etc...
    #print(file_content)
    soup = BeautifulSoup(file_content, 'html.parser' )

    try:
        parse_my_soup()
    except Exception as e:
        print ('ERRORS FOUND, BUT WILL NOT BE PRINTED // ERROR FOUND IN FILE =' + myfile )
        with open(ERROR_FILE, 'a') as csv_error_file:
            writer_e = csv.writer(csv_error_file)
            writer_e.writerow([count, myfile, datetime.now()])

    fd.close()
