################################################################################
THIS_PROGRAM_DETAILS = """
    ################################################################################
    THIS_SCRIPT_NAME_TEMPLATE_SCRIPT-get_all_urls_from_ALL_sitemap_urls.py
    ################################################################################
    REQUIREMENTS_FILE  = NONE
    ################################################################################
    USAGE: python3 THIS_SCRIPT_NAME
    ################################################################################
    ################################################################################
    THIS SCRIPT EXTRACTS URLS AND LASTMOD TIMES FROM A LIST OF SITEMAP URLS, AND
    SAVES THEM TO A OUTPUT CSV FILE.
    ################################################################################
    CREATED ON: November 6, 2019
    CREATED BY: Pali
    ################################################################################
"""

################################################################################
print(THIS_PROGRAM_DETAILS)
################################################################################

## IMPORTING MODULES
from bs4 import BeautifulSoup
import requests
################################################################################
################################################################################
OUTPUT_CSV_FILE = '_OUTPUT_9999_SITEMAP_ALL_URLS.csv'

################################################################################
## LIST OF SITEMAPS FOR VARIOUS WEBSITES (comment and uncomment as needed)
#### Note: Make sure to keep only one valid sitemap uncommented below
################################################################################

## CONCEPRO.COM SITEMAPS (uncomment if running the following)
sitemap_urls = ['https://www.whiskaffair.com/post-sitemap1.xml', 'https://www.whiskaffair.com/post-sitemap2.xml']

################################################################################
xmlDict = {} ## initializing an empty dictionary
####################
####################
def get_all_urls_from_sitemaps(URL):
    #########################################################
    ## BEGIN: GETTING SOME MORE DETAILS USING BeautifulSoup
    #########################################################
    ## FIRS YOU NEED TO SET HEADER PARAMETERS TO AVOID ANY HTTP 403, 406, ETC ERRORS
    ## MAKE THIS ERROR DEFAULT IN EVERYTHING YOU DO WITH BEAUTIFUL SOUP
    hdr = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A'}

    URL = URL.strip() ## removes all unnecessary character in line (leading and trailing)
    r = requests.get(URL,headers=hdr)
    xml = r.text

    soup = BeautifulSoup(xml, features="lxml")
    sitemapTags = soup.find_all("url")

    print("The number of URLs in this sitemap = {1} => {0}".format( len(sitemapTags) , URL ) )
    print() ## Blank line

    for sitemap in sitemapTags:
        xmlDict[sitemap.findNext("loc").text] = sitemap.findNext("lastmod").text
####################
####################

## EXECUTING THE FUNCION
for link in sitemap_urls:
    get_all_urls_from_sitemaps(URL=link)

################################################################################
## SORTING THE DICTIONARY
################################################################################
import collections

SORTED_xmlDict = collections.OrderedDict(sorted(xmlDict.items()))


################################################################################
## SAVING URL NAMES DATA TO A CSV FILE
################################################################################
file = open(OUTPUT_CSV_FILE,'w') ## initializing
#####################
print(">>>> PRINTING ALL SORTED URLS IN ALL THE SITEMAP URLS\n\n")

## WRITING AND PRINTING THE VALUES THE DICTIONARY WITH TOTAL COUNTS
COUNT=0
COUNT_VALID=0
COUNT_INVALID=0
for urlname,lastmod_date in SORTED_xmlDict.items():
    COUNT=COUNT+1
    VAR_TO_PRINT = str(COUNT) + ', ' + urlname + ', '+ lastmod_date + '\n'
    VAR_TO_WRITE = urlname + '\n'

    print("==========================") ##printing blank line
    print(VAR_TO_PRINT) ## printing all found URLs
    ## WRITING TO FILE ALL URLs NOT CONTAINING '/tags/' and '/categories/' WORDS
    if ('/tags/' not in urlname) and ('/categories/' not in urlname):
        COUNT_VALID = COUNT_VALID +1
        print(COUNT_VALID, "VALID URL FOR CSV FILE: ",urlname)
        file.write(VAR_TO_WRITE) ## writing to file
    else:
        COUNT_INVALID = COUNT_INVALID +1
        print(COUNT_INVALID, "INVALID URL FOR CSV FILE: ",urlname)

print("\n\n>>>> SUMMARY: \n")
print( "TOTAL URLS IN SITEMAPS = ",COUNT )
print( "VALID URLS = ",COUNT_VALID )
print( "INVALID URLS = ",COUNT_INVALID )
#####################
file.close()
################################################################################
################################################################################