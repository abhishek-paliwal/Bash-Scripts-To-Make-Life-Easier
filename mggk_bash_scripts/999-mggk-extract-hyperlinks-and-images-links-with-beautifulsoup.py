################################################################################
## THIS PROGRAM EXPECTS A USER INPUT AS A URL, SO THAT IT CAN EXTRACT THE LINKS FROM IT.
## THIS PROGRAM USER PYTHON PACKAGE BEAUTIFULSOUP TO EXTRACT ALL RELEVANT INFORMATION.
## MADE BY: PALI
## CODED ON: 2020-03-03
################################################################################

from newspaper import Article
from bs4 import BeautifulSoup
import urllib.request
import os
import sys
from datetime import datetime
##
# Create a logger object.
import coloredlogs
import logging
logger = logging.getLogger(__name__)
coloredlogs.install(level='DEBUG')
print()
#########################################################

logger.warning(">>>> This program expects a user input as a URL, so that it can extract the links from it. If the user input is missing, it will choose the default URL, which you might not want. The default URL is only good for debugging purposes.")
print() 

#########################################################
## BEGIN: GETTING SOME MORE DETAILS USING BeautifulSoup
#########################################################
## FIRS YOU NEED TO SET HEADER PARAMETERS TO AVOID ANY HTTP 403, 406, ETC ERRORS
## MAKE THIS ERROR DEFAULT IN EVERYTHING YOU DO WITH BEAUTIFUL SOUP
hdr = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A'}

## IF COMMAND LINE ARGUMENT IS PRESENT IN FORM OF URL
url = 'https://www.mygingergarlickitchen.com/best-holi-recipes/'
logger.debug("If the user input will be absent, default URL will be chosen as => " + url)
print()
print()

## ASKING FOR USER INPUT AND CHECKING IT'S PRESENCE
url = input("Enter The URL You Want The Link Extraction For [PRESS ENTER AFTER DONE // OR SIMPLY PRESS ENTER TO USE THE DEFAULT VALUE FOR URL]: ")
if url != "":
    print()
    logger.debug(">>>> URL IS NOT CHOSEN BY THE USER. URL WILL BE => " + url)
else:
    url = 'https://www.mygingergarlickitchen.com/best-holi-recipes/'
    print()
    logger.critical(">>>> NO URL IS NOT CHOSEN BY THE USER. HENCE, DEFAULT URL WILL BE => " + url)

# removes all unnecessary character in line (leading and trailing)
url = url.strip()

req = urllib.request.Request(url, headers=hdr)
content = urllib.request.urlopen(req).read()
soup = BeautifulSoup(content, 'html.parser')


## EXTRACTING THE META DESCRIPTON FROM THE WEBPAGE
#### Description is Case-Sensitive. So, we need to look for both 'Description' and 'description'.
meta_desc = soup.find(attrs={'name': 'Description'})
if meta_desc == None:
    meta_desc = soup.find(attrs={'name': 'description'})
## PRINTING THE META CONTENT DESCRIPTION
META_DESCRIPTION = str(meta_desc['content'])
print() ; print(">>>> META_DESCRIPTION: \n", META_DESCRIPTION)

## FINDING ALL IMAGES AND THEIR ALT TAGS
print() ; print(">>>> ALL IMAGES ON WEBPAGE: \n")
ALL_IMAGES = soup.find_all('img')

## WRITING OUTPUT TO AN EXTERNAL TEXT FILE
tmpfile1_filename = "_TMP_999_BS4_LINK_EXTRACTION_OUTPUT_IMAGES.TXT"
tmpfile1 = open(tmpfile1_filename, "w")
##
for myimg in ALL_IMAGES:
    #print(myimg)
    print("\nIMAGE_URL: ", myimg.get('src'))
    print("IMAGE_ALT_TAG: ", str(myimg.get('alt')))
    print('')
    tmpfile1.write("\nIMAGE_URL: " + myimg.get('src'))
    tmpfile1.write("\n")
    tmpfile1.write("IMAGE_ALT_TAG: " + str(myimg.get('alt')) )
    tmpfile1.write("\n")
##
tmpfile1.close()

################################################################################
## GETTING THE TITLE TAG TEXT
TITLE_VALUE = soup.find('title').get_text()
print("PAGE TITLE: ", TITLE_VALUE)
################################################################################

################################################################################
## FINDING THE META GENERATOR NAME VALUE FROM THE WEBPAGE
#### This is of the format such as = <meta name="generator" content="WordPress 5.2.4" />
meta_generator_tmp = soup.find(attrs={'name': 'generator'})
META_GENERATOR = str(meta_generator_tmp['content'])
print("\n>>>> WEBSITE_CREATED_USING: ", META_GENERATOR)
################################################################################

################################################################################
## FINDING THE ANCHOR TEXT OF THE HYPERLINKS
print() ; print(">>>> FINDING THE ANCHOR TEXT OF THE HYPERLINKS: \n")
all_links = soup.find_all('a')

## WRITING OUTPUT TO AN EXTERNAL TEXT FILE
tmpfile2_filename = "_TMP_999_BS4_LINK_EXTRACTION_OUTPUT_HYPERLINKS.TXT"
tmpfile2 = open(tmpfile2_filename, "w")
##
for link in all_links:
    link_ref = link.get('href')
    print("\nANCHOR TEXT: " + link.get_text())
    print("LINK: " + link_ref)
    tmpfile2.write("\nANCHOR TEXT: "+  link.get_text())
    tmpfile2.write("\n")
    tmpfile2.write("LINK: " + link_ref)
    tmpfile2.write("\n")
##
tmpfile2.close()


################################################################################

################################################################################
## BEGIN: FINDING PUBLISHED AND UPDATED/MODIFIED TIMES FOR WEBPAGE USING BEAUTIFUL SOUP
################################################################################
print('\n///////////////////////////////////////////////////////////////////////\n')
#### The webpage has this format in the HTML source code:
#### <meta property="article:published_time" content="2014-03-16T23:10:22+00:00" />
#### <meta property="article:modified_time" content="2014-03-16T23:10:22+00:00" />
meta_published_time_tmp = soup.find(attrs={'property': 'article:published_time'})
META_PUBLISHED_DATETIME = "1970-01-01T00:00:00+00:00"
#####
try:
    META_PUBLISHED_DATETIME = str(meta_published_time_tmp['content'])
except:
    META_PUBLISHED_DATETIME = META_PUBLISHED_DATETIME
######
print(">>>> META_PUBLISHED_DATETIME: ", META_PUBLISHED_DATETIME)

meta_modified_time_tmp = soup.find(attrs={'property': 'article:modified_time'})
META_MODIFIED_DATETIME = "1970-01-01T00:00:00+00:00"
####
try:
    META_MODIFIED_DATETIME = str(meta_modified_time_tmp['content'])
except:
    META_MODIFIED_DATETIME = META_MODIFIED_DATETIME
####
print(">>>> META_MODIFIED_DATETIME: ", META_MODIFIED_DATETIME)

## CONVERTING OBTAINED DATE STRINGS INTO PYTHON DATE OBJECTS FOR CALCULATIONS
#### a.) converting string to corresponding date format (by using strptime)
date_post_published_tmp = datetime.strptime(
    META_PUBLISHED_DATETIME, "%Y-%m-%dT%H:%M:%S%z")
date_post_modified_tmp = datetime.strptime(
    META_MODIFIED_DATETIME, "%Y-%m-%dT%H:%M:%S%z")
#### b.) converting thus created date into desired format for printing (by using strftime)
date_post_published = datetime.strftime(date_post_published_tmp, '%Y-%m-%d')
date_post_modified = datetime.strftime(date_post_modified_tmp, '%Y-%m-%d')

## GETTING TODAY
today_tmp = datetime.now()
date_today = datetime.strftime(today_tmp, '%Y-%m-%d')

## DEFINE FUNCTION TO CALCULATE DATE DIFFERENCE


def days_between(d1, d2):
    d1 = datetime.strptime(d1, "%Y-%m-%d")
    d2 = datetime.strptime(d2, "%Y-%m-%d")
    return abs((d2 - d1).days)  # RETURNS A TIMEDELTA OBJECT


days_diff_first_published = days_between(date_today, date_post_published)
print(">>>> POST FIRST PUBLISHED: ", days_diff_first_published,
      " days ago", " = ", round(days_diff_first_published/365, 3), " years ago")

days_diff_modified = days_between(date_today, date_post_modified)
print(">>>> POST FIRST MODIFIED: ", days_diff_modified, " days ago",
      " = ", round(days_diff_modified/365, 3), " years ago")

BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP = []

BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append(
    'META_PUBLISHED_DATETIME: ' + META_PUBLISHED_DATETIME)
BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append(
    'META_MODIFIED_DATETIME: ' + META_MODIFIED_DATETIME)
BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('<h2>POST FIRST PUBLISHED: ' + str(
    days_diff_first_published) + ' days ago' + ' = ' + str(round(days_diff_first_published/365, 3)) + ' years ago</h2>')
BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('<h2>POST FIRST MODIFIED: ' + str(
    days_diff_modified) + ' days ago' + ' = ' + str(round(days_diff_modified/365, 3)) + ' years ago</h2>')

BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY = '<br>'.join(
    str(v) for v in BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP)

print(">>>>>>")
print(BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY)

print()
print("##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
logger.error("IMPORTANT NOTE: If you see any dates as 1970-01-01-XXXX above, that means that the program could not find any dates on the webpage content whatsoever, and just used the default ones chosen for debugging.")
print("##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")

################################################################################
print()
logger.debug(">>>> Extraction completed from URL => " + url)
logger.warning(">> The following temporary output text files are created in working directory :")
logger.warning(tmpfile1_filename)
logger.warning(tmpfile2_filename)
print()
################################################################################
## END: FINDING PUBLISHED AND UPDATED/MODIFIED TIMES FOR WEBPAGE USING BEAUTIFUL SOUP
################################################################################
