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
    ## TEST PYTHON SCRIPT TO TEST BEAUTIFUL SOUP4 LIBRARY USAGE USING URL
    ## CODED ON: Saturday May 23, 2019
    ## USAGE ON COMMAND PROMPT: python3 THIS_SCRIPT_FILE.PY
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

############################################################################
############################################################################
from bs4 import BeautifulSoup
from bs4.diagnose import diagnose
import urllib.request
import os
import glob
import csv
from datetime import datetime
import math
################################################################################

################################################################################
#### FUNCTION DEFINITIONS: CREATE AUTOMATIC HEADING BLOCK ######################
################################################################################
## THE FOLLOWING FUNCTION WRAPS TEXT AFTER CERTAIN NUMBER OF CHARACTERS
def wrap_text_after(MYSTRING, RULERCHAR, NUMCHARS=70):
    MYSTRING_NEW = "\n" ;
    MYSTRING = MYSTRING.upper()
    MYY = math.ceil(len(MYSTRING)/NUMCHARS)
    for MYZ in range(MYY):
        MYSTRING_NEW = MYSTRING_NEW + RULERCHAR*4 + ' ' + MYSTRING[(MYZ)*NUMCHARS:(MYZ+1)*NUMCHARS] + ' ' + RULERCHAR*4 + '\n' ;
    return MYSTRING_NEW

## THE FOLLOWING FUNCION MAKES PRETTY HEADINGS TO OUTPUT ON THE COMMAND LINE
## AND CONVERTS THE UNDERLYING TEXT TO UPPERCASE
def make_heading(myheading, RULERCHAR="#"):
    if len(myheading) > 80:
        myheading_new = wrap_text_after(MYSTRING=myheading, RULERCHAR=RULERCHAR, NUMCHARS=70)
    else:
        myheading_new = myheading

    RULER = 80*RULERCHAR
    print('\n' + RULER)
    mylen = round( ( 78 - len(myheading_new) )/2 )
    print(RULERCHAR*mylen + ' ' + myheading_new.upper() + ' ' + RULERCHAR*mylen)
    #print(myheading_new.upper())
    print(RULER + '\n')
################################################################################
################################################################################

make_heading("program begins", RULERCHAR="#")

################################################################################
## SUPPLYING THE USER AGENT BECAUSE SOMETIMES URLs CHECK FOR IT, ELSE THEY
## SHOW 403 FORBIDDEN ERROR.
################################################################################
from urllib.request import urlopen, Request
headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.3'}

################################################################################
## SET WHICH URL TO FETCH, and ACTUALLY FETCH CONTENT
################################################################################
#req_url ="https://www.mygingergarlickitchen.com/instant-mawa-modak/"
req_url = "https://www.mygingergarlickitchen.com/masala-mathri-2-ways-baked-masala-mathri-recipe-video-spicy-indian-crackers/"
req = Request(url=req_url, headers=headers)
content = urlopen(req).read()
#print(content)

################################################################################
## BEAUTIFUL SOUP MAGIC BEGINS BELOW
################################################################################
soup = BeautifulSoup(content, 'html.parser' )
#print(soup.prettify())

make_heading("printing the recipe block html output", RULERCHAR="+")

mainDiv=soup.find('div',class_="mggk-main-article-content")
print(mainDiv.prettify())


allH2s=mainDiv.find_all('h2') ## it will be a list, so later we will have to loop over it to get individual elements
print(allH2s)

for x in allH2s:
    print("\n")
    print(x)

#easyrecipe_block=soup.find_all('h2').prettify()
#print(easyrecipe_block)


## Getting all the json ld blocks on the webpage
## Since, we don't know how many they would be, we are going for upto 10
##
for x in range(0,10):
    try:
        ld_json_block = soup.select("[type='application/ld+json']")[x] ;
        print(ld_json_block) ;
        print('++++++++++++++++++++++++++++++++++++++++++++++++') ;
        print() ;
    except:
        print ( str(x) + " >>>> NOTE: No more indexes found. >>>>") ;


##################################################################################
make_heading("program ends", RULERCHAR="/")


