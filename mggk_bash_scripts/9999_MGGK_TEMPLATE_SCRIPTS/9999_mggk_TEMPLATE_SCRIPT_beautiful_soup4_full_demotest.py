from newspaper import Article
from bs4 import BeautifulSoup
from bs4.diagnose import diagnose
import urllib.request
import os
import glob
import csv
from datetime import datetime
from random import randint
import matplotlib.pyplot as plt

#########################################################
## BEGIN: GETTING SOME MORE DETAILS USING BeautifulSoup
#########################################################
## FIRS YOU NEED TO SET HEADER PARAMETERS TO AVOID ANY HTTP 403, 406, ETC ERRORS
## MAKE THIS ERROR DEFAULT IN EVERYTHING YOU DO WITH BEAUTIFUL SOUP
hdr = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A'}

url = 'https://www.mygingergarlickitchen.com/punjabi-chole-bhature-chana-bhatura/'
url = url.strip() ## removes all unnecessary character in line (leading and trailing)

req = urllib.request.Request(url,headers=hdr)
content = urllib.request.urlopen(req).read()
soup = BeautifulSoup(content, 'html.parser' )


## EXTRACTING THE META DESCRIPTON FROM THE WEBPAGE
#### Description is Case-Sensitive. So, we need to look for both 'Description' and 'description'.
meta_desc = soup.find(attrs={'name':'Description'})
if meta_desc == None:
    meta_desc = soup.find(attrs={'name':'description'})
## PRINTING THE META CONTENT DESCRIPTION
META_DESCRIPTION = str(meta_desc['content'])
print(">>>> META_DESCRIPTION: \n", META_DESCRIPTION)

## FINDING ALL IMAGES AND THEIR ALT TAGS
print(">>>> ALL IMAGES ON WEBPAGE: \n")
ALL_IMAGES = soup.find_all('img')
for myimg in ALL_IMAGES:
    #print(myimg)
    print( "IMAGE_URL: ", myimg.get('src') )
    print( "IMAGE_ALT_TAG: ", myimg.get('alt') )
    print('')

################################################################################
## GETTING THE TITLE TAG TEXT
TITLE_VALUE = soup.find('title').get_text()
print("PAGE TITLE: ",TITLE_VALUE)
################################################################################

################################################################################
## FINDING THE META GENERATOR NAME VALUE FROM THE WEBPAGE
#### This is of the format such as = <meta name="generator" content="WordPress 5.2.4" />
meta_generator_tmp = soup.find(attrs={'name':'generator'})
META_GENERATOR = str(meta_generator_tmp['content'])
print("\n>>>> WEBSITE_CREATED_USING: ", META_GENERATOR)
################################################################################

################################################################################
## FINDING THE ANCHOR TEXT OF THE HYPERLINKS
print(">>>> FINDING THE ANCHOR TEXT OF THE HYPERLINKS: \n")
all_links = soup.find_all('a')

for link in all_links:
    link_ref = link.get('href')
    print("\nLINK: ",link_ref[:80],"...")
    print("ANCHOR TEXT: ", link.get_text() )
################################################################################

################################################################################
## BEGIN: FINDING PUBLISHED AND UPDATED/MODIFIED TIMES FOR WEBPAGE USING BEAUTIFUL SOUP
################################################################################
print('\n///////////////////////////////////////////////////////////////////////\n')
#### The webpage has this format in the HTML source code:
#### <meta property="article:published_time" content="2014-03-16T23:10:22+00:00" />
#### <meta property="article:modified_time" content="2014-03-16T23:10:22+00:00" />
meta_published_time_tmp = soup.find(attrs={'property':'article:published_time'})
META_PUBLISHED_DATETIME = str(meta_published_time_tmp['content'])
print("\n>>>> META_PUBLISHED_DATETIME: ", META_PUBLISHED_DATETIME)

meta_modified_time_tmp = soup.find(attrs={'property':'article:modified_time'})
META_MODIFIED_DATETIME = str(meta_modified_time_tmp['content'])
print(">>>> META_MODIFIED_DATETIME: ", META_MODIFIED_DATETIME)

## CONVERTING OBTAINED DATE STRINGS INTO PYTHON DATE OBJECTS FOR CALCULATIONS
#### a.) converting string to corresponding date format (by using strptime)
date_post_published_tmp = datetime.strptime(META_PUBLISHED_DATETIME, "%Y-%m-%dT%H:%M:%S%z")
date_post_modified_tmp = datetime.strptime(META_MODIFIED_DATETIME, "%Y-%m-%dT%H:%M:%S%z")
#### b.) converting thus created date into desired format for printing (by using strftime)
date_post_published = datetime.strftime(date_post_published_tmp, '%Y-%m-%d')
date_post_modified = datetime.strftime(date_post_modified_tmp, '%Y-%m-%d')

## GETTING TODAY
today_tmp = datetime.now()
date_today = datetime.strftime(today_tmp,'%Y-%m-%d')

## DEFINE FUNCTION TO CALCULATE DATE DIFFERENCE
def days_between(d1, d2):
    d1 = datetime.strptime(d1, "%Y-%m-%d")
    d2 = datetime.strptime(d2, "%Y-%m-%d")
    return abs((d2 - d1).days) ## RETURNS A TIMEDELTA OBJECT

days_diff_first_published = days_between(date_today, date_post_published)
print(">>>> POST FIRST PUBLISHED: ", days_diff_first_published, " days ago", " = ", round(days_diff_first_published/365,3), " years ago" )

days_diff_modified = days_between(date_today, date_post_modified)
print(">>>> POST FIRST MODIFIED: ", days_diff_modified, " days ago", " = ", round(days_diff_modified/365,3), " years ago" )

BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP = []

BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('META_PUBLISHED_DATETIME: ' + META_PUBLISHED_DATETIME)
BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('META_MODIFIED_DATETIME: ' + META_MODIFIED_DATETIME)
BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('<h2>POST FIRST PUBLISHED: ' + str(days_diff_first_published) + ' days ago' + ' = ' + str( round(days_diff_first_published/365,3) ) + ' years ago</h2>' )
BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('<h2>POST FIRST MODIFIED: ' + str(days_diff_modified) + ' days ago' + ' = ' + str( round(days_diff_modified/365,3) ) + ' years ago</h2>' )

BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY = '<br>'.join(str(v) for v in BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP)

print(">>>>>>")
print(BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY)
################################################################################
## END: FINDING PUBLISHED AND UPDATED/MODIFIED TIMES FOR WEBPAGE USING BEAUTIFUL SOUP
################################################################################
