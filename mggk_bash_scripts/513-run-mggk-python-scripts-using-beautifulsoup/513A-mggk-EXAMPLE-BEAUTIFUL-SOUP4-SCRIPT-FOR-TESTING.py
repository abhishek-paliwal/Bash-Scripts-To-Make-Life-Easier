############################################################################
## TEST PYTHON SCRIPT TO TEST BEAUTIFUL SOUP4 LIBRARY USAGE USING URL
## CODED ON: Saturday May 23, 2019
## USAGE ON COMMAND PROMPT: python3 THIS_SCRIPT_FILE.PY
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

#### FUNCTION DEFINITIONS: CREATE AUTOMATIC HEADING BLOCK ######################
## THE FOLLOWING FUNCION WRAPS TEXT AFTER CERTAIN NUMBER OF CHARACTERS
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

############################################
url = "https://www.mygingergarlickitchen.com/szechuan-spiced-carrot-fettuccine-video-recipe/"

content = urllib.request.urlopen(url).read()
soup = BeautifulSoup(content, 'html.parser' )
#print(soup.prettify())

make_heading("printing the recipe block html output", RULERCHAR="+")
easyrecipe_block=soup.find('div',class_='easyrecipe').prettify()
print(easyrecipe_block)
make_heading("program ends", RULERCHAR="/")
