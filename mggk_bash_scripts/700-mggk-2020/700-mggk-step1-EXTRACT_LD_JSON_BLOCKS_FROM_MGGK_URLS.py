##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USAGE FOR PYTHON
## Print this help as >> this_script_name --help
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
import sys
####
def usage():
    print('## USAGE: ' + sys.argv[0])
    HELP_TEXT = """
    ##################################################################################
    ## THIS SCRIPT GETS ARGUMENTS INPUTS FROM WITHIN A BASH SCRIPT 
    # THIS PROGRAM USES BEAUTIFUL SOUP TO EXTRACT ALL VALID LD+JSON SCRIPT BLOCKS ON 
    ## THOSE URLS.
    ##################################################################################
    ## MADE BY: PALI
    ## CODED ON: 2020-03-03
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

################################################################################
################################################################################

import json
import sys
from bs4 import BeautifulSoup
from bs4.diagnose import diagnose
import urllib.request
import os
import glob
import math

##################################################################################


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
#req_url = "https://www.mygingergarlickitchen.com/masala-mathri-2-ways-baked-masala-mathri-recipe-video-spicy-indian-crackers/"
#req = Request(url=req_url, headers=headers)
#content = urlopen(req).read()
#print(content)

## Getting the arguments from the CLI
#sys.argv[1] = "/kiwi-raita/" ; ## this is an example value
url_input = sys.argv[1] ;
url_input_without_slashes = url_input.replace("/","") ;
my_url = 'https://www.mygingergarlickitchen.com' + url_input ;
req = Request(url=my_url, headers=headers)
content = urlopen(req).read()

################################################################################
## BEAUTIFUL SOUP MAGIC BEGINS BELOW
################################################################################
page_soup = BeautifulSoup(content, 'html.parser' )

##################################################################################
## Using Beautiful soup for the processing of individual urls
##################################################################################
## Looping through to find all possible ld+json codes on this webpage
#### Since, we don't know how many they will be, we will loop it upto
#### 10 timess as we are sure that the page don't have more than 10 such
#### ld+json script blocks.
#ret = requests.get(my_url)
## 
for x in range(0,10):
    #page_soup = soup(ret.text, 'lxml')
    try:
        data = page_soup.select("[type='application/ld+json']")[x] ;
        print(data.text)
        print('++++++++++++++++++++++++++++++++++++++++++++++++') ;
        print() ;
        ####
        # writing to an output json file
        json_output_dir = sys.argv[2] ;
        json_output_file = json_output_dir + "/" + url_input_without_slashes + "-" + str(x) + '.json' ;
        file1 = open(json_output_file, 'w') 
        file1.write(data.text)
        file1.close() 
    except:
        print ( str(x) + " >>>> NOTE: No more indexes found. >>>>") ;
