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
#############################################################################

url = "https://www.mygingergarlickitchen.com/szechuan-spiced-carrot-fettuccine-video-recipe/"

content = urllib.request.urlopen(url).read()
soup = BeautifulSoup(content, 'html.parser' )
#print(soup.prettify())

easyrecipe_block=soup.find('div',class_='easyrecipe').prettify()
print(easyrecipe_block)
