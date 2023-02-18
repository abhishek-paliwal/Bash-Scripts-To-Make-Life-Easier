##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USAGE FOR PYTHON
## Print this help as >> this_script_name --help
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
import sys
####
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
##################################################################################
from bs4 import BeautifulSoup
from bs4.diagnose import diagnose
import urllib.request
import os
import glob
import csv
from datetime import datetime
from random import randint

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
    print("<li>SECTION " + str(x) + ': ' ,TITLE_VALUE,"</li>")
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
    print("<h3>CHAPTER " + str(x) + ': ' ,TITLE_VALUE,"</h3>")
    ################################################################################
    ##
    #page_headings = soup.find_all("h3")
    #print(page_headings) 
    main_content = soup.find("div", ["versionPage"])
    print(main_content)
    print ('<hr>')


####

## CHANGE THE FOLLOWING VARIABLES FOR EACH BOOK YOU WISH TO DOWNLOAD
bookname = "हमारी वसीयत और विरासत - Text for Audiobook" ; 
number_of_pages_to_download = 23 ; 
MYURL_BASEPATH = 'file:///Users/abhishek/Desktop/Y/0/v4.' ; 
##

print('<h1>' + bookname + '</h1>')
print('<h2>Table of contents</h2>')
print('<ol>')
for x in range(1, number_of_pages_to_download+1):
    myurl = MYURL_BASEPATH + str(x) + '.html' ;
    parse_title_for_this_url(myurl,x)
print('</ol>')
print ('<hr>')

####
for x in range(1,number_of_pages_to_download+1):
    myurl = MYURL_BASEPATH + str(x) + '.html' ;
    parse_data_for_this_url(myurl,x)
