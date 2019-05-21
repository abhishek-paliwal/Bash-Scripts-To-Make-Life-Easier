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
SUCCESS_FILE = OUTPUT_DIR+"/_TMP_513_CHECK_THIS_FILE_FOR_SUCCESS.CSV"
ERROR_FILE = OUTPUT_DIR+"/_TMP_513_CHECK_THIS_FILE_FOR_ERRORS.CSV"
FILELIST_USED = OUTPUT_DIR+"/_TMP_513_THIS_FILELIST_IS_USED.CSV"

## INITIALIZE SOME FILES FOR SUCCESS AND ERROR REPORTING
with open(SUCCESS_FILE, 'w') as csv_file:
    writer = csv.writer(csv_file)
    writer.writerow(["COUNT", "MYFILE", "RECIPENAME", "DESCRIPTION", "AUTHOR", "PREPTIME", "COOKTIME", "TOTALTIME", "RECIPECATEGORY", "RECIPECUISINE", "DATETIME"])

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

   try: preptime=soup.find('time', attrs={'itemprop':'prepTime'}).string ;
   except Exception as e: preptime="NO-PREPTIME-DEFINED" ;

   try: cooktime=soup.find('time', attrs={'itemprop':'cookTime'}).string ;
   except Exception as e: cooktime="NO-COOKTIME-DEFINED" ;

   try: totaltime=soup.find('time', attrs={'itemprop':'totalTime'}).string ;
   except Exception as e: totaltime="NO-TOTALTIME-DEFINED" ;

   try: description=soup.find('div', attrs={'itemprop':'description'}).string ;
   except Exception as e: description="NO-DESCRIPTION-DEFINED" ;

   try: recipeCategory=soup.find('span', attrs={'itemprop':'recipeCategory'}).string ;
   except Exception as e: recipeCategory="NO-CATEGORY-DEFINED" ;

   try: recipeCuisine=soup.find('span', attrs={'itemprop':'recipeCuisine'}).string ;
   except Exception as e: recipeCuisine="NO-CUISINE-DEFINED" ;

   try: ingredients=soup.find_all('li', attrs={'itemprop':'recipeIngredient'}) ;
   except Exception as e: ingredients="NO-INGREDIENTS-DEFINED" ;

   try: instructions=soup.find_all('li', attrs={'itemprop':'recipeInstructions'}) ;
   except Exception as e: instructions="NO-INSTRUCTIONS-DEFINED" ;

   #try: ingredientsHeaders=soup.find_all('div', attrs={'class':'ERSIngredients'}) ;
   #except Exception as e: instructions="NO-INGREDIENTS-HEADERS-DEFINED" ;

   print("\n\n===== PRINTING OUT VALUES ====\n")
   print(recipename)
   print(preptime)
   print(cooktime)
   print(totaltime)
   print(description)
   print(author)
   print(recipeCategory)
   print(recipeCuisine)
   print(ingredients)
   print("=====")
   print(instructions)

   print("\n===== INGREDIENTS ====\n")
   for ingr in ingredients:
       print(ingr.string)

   print("\n===== INSTRUCTIONS ====\n")
   for instr in instructions:
       print(instr.string)

   #############################
   full_recipe_block=soup.find('div', attrs={'class':'easyrecipe'}) ;
   print("\n\n===== ORIGINAL HTML - PRETTIFIED =====\n")
   print(full_recipe_block.prettify())
   print("\n\n===== EXTRACTED RAW TEXT: EASYRECIPE BLOCK =====\n")
   print(full_recipe_block.get_text())

   #### CSV MAGIC = Opens a csv file with append, so old data will not be erased
   with open(SUCCESS_FILE, 'a') as csv_file:
       writer = csv.writer(csv_file)
       writer.writerow([count, myfile, recipename, description, author, preptime, cooktime, totaltime, recipeCategory, recipeCuisine, datetime.now()])

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
