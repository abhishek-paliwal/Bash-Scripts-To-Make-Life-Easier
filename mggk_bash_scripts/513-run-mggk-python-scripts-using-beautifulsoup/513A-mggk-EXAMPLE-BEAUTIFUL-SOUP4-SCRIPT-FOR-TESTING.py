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

#### CREATE AUTOMATIC HEADING BLOCK ###########################################
def make_heading(myheading, RULERCHAR="#"):
    RULER = 80*RULERCHAR
    print('\n' + RULER)
    mylen = round( ( 78 - len(myheading) )/2 )
    print(RULERCHAR*mylen + ' ' + myheading.upper() + ' ' + RULERCHAR*mylen)
    print(RULER + '\n')
################################################################################
################################################################################

url = "https://www.mygingergarlickitchen.com/szechuan-spiced-carrot-fettuccine-video-recipe/"

content = urllib.request.urlopen(url).read()
soup = BeautifulSoup(content, 'html.parser' )
#print(soup.prettify())

make_heading("printing the recipe block html output", RULERCHAR="#")
easyrecipe_block=soup.find('div',class_='easyrecipe').prettify()
print(easyrecipe_block)
make_heading("program ends", RULERCHAR="/")


x="This is a good one very good one. This is a good one very good one. This is a good one very good one. This is a good one very good one. This is a good one very good one. This is a good one very good one. This is a good one very good one. This is a good one very good one. This is a good one very good one. This is a good one very good one. This is a good one very good one. "
num=74
x=x.upper()
if len(x) > num:
    y=round(len(x)/num)
    print(len(x))
    print(y)
    for z in range(y-1):
        print('## ' + x[(z-1)*num:z*num] + ' ##')
