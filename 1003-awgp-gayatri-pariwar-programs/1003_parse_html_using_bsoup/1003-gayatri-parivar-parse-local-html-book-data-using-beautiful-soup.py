##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USAGE FOR PYTHON
## Print this help as >> this_script_name --help
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
from bs4 import BeautifulSoup
from bs4.diagnose import diagnose
import urllib.request
import os
import glob
import csv
from datetime import datetime
from random import randint
import sys

## GET FROM CLI ARGUMENTS
bookname = sys.argv[1] ; 
number_of_pages_to_download = int(sys.argv[2]) ; 
LOCALPATH_PREFIX = sys.argv[3] ; 
#LOCALPATH_PREFIX = 'file:///Users/abhishek/Desktop/Y/0/v4.' ; 
##################################################################################

#########################################################
## BEGIN: GETTING SOME MORE DETAILS USING BeautifulSoup
#########################################################
### DEFINING FUNCTION WHICH WILL BE LOOPED LATER FOR ALL HTML PAGES
def parse_title_for_this_url(myurl,x):
    response = urllib.request.urlopen(myurl, timeout=1)
    html = response.read()
    soup = BeautifulSoup(html, 'html.parser')
    ##
    ################################################################################
    ## GETTING THE TITLE TAG TEXT
    TITLE_VALUE = soup.find('title').get_text()
    print("<li>CHAPTER " + str(x) + ': ' ,TITLE_VALUE,"</li>")
    ################################################################################

##########

def parse_data_for_this_url(myurl,x):
    response = urllib.request.urlopen(myurl, timeout=1)
    html = response.read()
    soup = BeautifulSoup(html, 'html.parser')
    ##
    ################################################################################
    ## GETTING THE TITLE TAG TEXT
    TITLE_VALUE = soup.find('title').get_text()
    print("<h2>CHAPTER " + str(x) + ': ' ,TITLE_VALUE,"</h2>")
    ################################################################################
    ##
    #page_headings = soup.find_all("h3")
    #print(page_headings) 
    main_content = soup.find("div", ["versionPage"])
    print(main_content)
    print ('<hr>')


####
print('<h1>' + bookname + '</h1>')
print('<h2>Table of contents</h2>')
print('<ul>')
for x in range(1, number_of_pages_to_download+1):
    myurl = LOCALPATH_PREFIX + str(x) + '.html' ;
    #print(myurl) ; 
    parse_title_for_this_url(myurl,x) ; 
print('</ul>')
print ('<hr>')

####
for x in range(1,number_of_pages_to_download+1):
    myurl = LOCALPATH_PREFIX + str(x) + '.html' ;
    #print(myurl) ; 
    parse_data_for_this_url(myurl,x) ;
