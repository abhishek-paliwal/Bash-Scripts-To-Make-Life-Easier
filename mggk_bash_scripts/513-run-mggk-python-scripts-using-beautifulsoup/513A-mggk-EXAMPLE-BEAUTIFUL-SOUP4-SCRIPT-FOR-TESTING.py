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
################################################################################

RULER="#"*80 ;

#### CREATE AUTOMATIC HEADING BLOCK
def make_heading_type1(myheading):
    print('\n' + RULER)
    mylen = round( ( 78 - len(myheading) )/2 )
    print('#'*mylen + ' ' + myheading.upper() + ' ' + '#'*mylen)
    print('#'*mylen + ' ' + str(datetime.now()) + ' ' + '#'*mylen)
    print(RULER + '\n')
################################################################################
################################################################################

url = "https://www.mygingergarlickitchen.com/szechuan-spiced-carrot-fettuccine-video-recipe/"

content = urllib.request.urlopen(url).read()
soup = BeautifulSoup(content, 'html.parser' )
#print(soup.prettify())

make_heading_type1("printing the recipe block html output")
easyrecipe_block=soup.find('div',class_='easyrecipe').prettify()
print(easyrecipe_block)
make_heading_type1("program ends")
