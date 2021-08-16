##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USAGE FOR PYTHON
## Print this help as >> this_script_name --help
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
import sys
####
def usage():
    print('## USAGE: ' + sys.argv[0])
    HELP_TEXT = """
    ##############################################################################
    THIS SCRIPT USES NATURAL LANGUAGE PROCESSING (NLP + AI), Newspaper3k, and BeautifulSoup 4
    OVER AN EXTERNAL TEXT FILE CONTAINING URLS FOR KEYWORDS ANALYSIS, AND PRODUCES
    A DETAILED HTML FILE WITH ALL THE EXTRACTED DATA FOR EACH URL PRESENT IN
    THE REQUIREMENTS_FILE.
    ################################################################################
    THIS SCRIPT ALSO PRODUCES SOME CSV FILES FOR LATER ANALYSES (OR FOR PLOTTING).
    ################################################################################
    REQUIREMENTS_FILE  = 601-MGGK-REQUIREMENT-ALL-URLS-FOR-NLP.txt
    (Note: This file should be present in the Present Working Directory)
    ################################################################################
    USAGE: python3 THIS_SCRIPT_NAME
    ################################################################################
    CREATED ON: 2021-08-15
    CREATED BY: Pali
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
## IMPORTING MODULES
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

################################################################################
## DEFINING SOME VARIABLES (Only edit these paths if running on the VPS SERVER)
################################################################################
from os.path import expanduser
home = expanduser("~") ;
home_windows = os.getenv('HOME_WINDOWS') ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## IF THIS SCRIPT IS RUNNING ON THE VPS SERVER, THEN CHECK FOR THE USERNAME 'ubuntu' IN HOME DIRECTORY,
#### AND SET DIRECTORY PATHS APPROPRIATELY. ELSE, SET OTHER PATHS FOR EXECUTION LOCALLY.
myhostname = os.uname()[1] ;

if ('digitalocean' in myhostname):  # if running on VPS
    dirpath = '/scripts-made-by-pali/600-mggk-ai-nlp-scripts/' ;
    rake_stop_dir = home + dirpath + '601-MGGK-PYTHON-RAKE-SmartStoplist.txt' ;
    working_directory = home + dirpath ;
else: ## if running elsewhere
    dirpath = '/GitHub/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/600-mggk-artificial-intelligence-nlp-programs/601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls' ;
    rake_stop_dir = home + dirpath + '/601-MGGK-PYTHON-RAKE-SmartStoplist.txt' ;
    working_directory = home_windows + '/Desktop/Y/' ;
####   
## PRINTING IMPORTANT PATHS
print('') ## empty line
print('>>>> HOME = ',home)
print('>>>> CURRENT WORKING DIRECTORY = ',dirpath)
print('>>>> RAKE STOP WORDS DIRECTORY = ',rake_stop_dir)
print('') ## empty line
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
prefix_dateformat="%Y%m%d"
prefix_today = datetime.strftime(datetime.now(), prefix_dateformat)
NLP_URLS_TEXT_FILE = working_directory + '601-MGGK-REQUIREMENT-ALL-URLS-FOR-NLP.txt'
OUTPUT_HTML_FILE = working_directory + str(prefix_today) + '_TMP_601_MGGK_AI_NLP_HTML_OUTPUT.HTML'
OUTPUT_CSV_FILE = working_directory + str(prefix_today) +'_TMP_601_MGGK_AI_NLP_OUTPUT_FOR_FUTURE_ANALYSES.CSV'
##
dateformat="%Y-%m-%d %H:%M"
TIME_NOW = datetime.strftime(datetime.now(), dateformat)
##
## BOOTSTRAP4 HTML HEADER + FOOTER (defining multiline string variables)
BOOTSTRAP4_HTML_HEADER = """<!doctype html>
<html lang='en'>
<head>
    <!-- Required meta tags -->
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
    <!-- Bootstrap CSS -->
    <link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css'>
    <style>td {vertical-align: baseline; font-family: sans-serif; padding: 5px; }</style>
    <title>601 - AI + NLP Program output</title>
</head>
<body>
<div class='container-fluid'><!-- BEGIN: main containter div -->"""
##
BOOTSTRAP4_HTML_FOOTER = """</div> <!-- END: main containter div -->
    <!-- Optional Bootstrap JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src='https://code.jquery.com/jquery-3.3.1.slim.min.js'></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js'></script>
    <script src='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js'></script>
</body>
</html>"""
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def downloadArticleText(url):
    ## BEGIN: GETTING SOME PRIMARY DETAILS USING NEWSPAPER3K
    article = Article(url)
    articleText = "" ;
    try:
        #print("//-----------------------------------------------------------------//")
        ## Downloading and parse the article
        article.download()
        article.parse()
        article.nlp()
        articleText = article.text
        #print(article.html)
        #print(">>>> ARTICLE FULL TEXT [via NLP] = ", article.text)
    except:
        print('***** NLP ERROR: FAILED TO DOWNLOAD *****', article.url)
        pass
    ##
    return articleText
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def countOccurenceOfWords(articleText):
    ## COUNT THE NUMBER OF OCCURENCES OF EACH WORD IN FULL TEXT
    all_words = articleText.split()
    word_with_counts = {}
    for word in all_words:
        count = word_with_counts.get(word, 0)
        count += 1
        word_with_counts[word] = count
    #print(word_with_counts)
    ## SORTING THE COUNT
    word_with_counts_list = sorted(word_with_counts, key=word_with_counts.get, reverse=True)
    ## SHOW TOP 20 WORDS
    print(">>>> TOP 20 WORDS BY COUNTS (count, word):")
    TOP20_WORDS=[] ## init empty array
    X=0
    for word in word_with_counts_list[:20]:
        print(word_with_counts[word], word)
        ## INSERTING THIS ELEMENT IN ARRAY
        TOP20_WORDS.append( str(word_with_counts[word]) + " " + str(word) )
        X=X+1
    ## CONVERTING THIS ARRAY TO A STRING OF WORDS FOR HTML OUTPUT
    TOP20_WORDS_STRING_HTML = '<br>'.join(TOP20_WORDS)
    ##
    return TOP20_WORDS_STRING_HTML
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def BeautifulSoupGetArticleMainContent(url):
    ## FIRS YOU NEED TO SET HEADER PARAMETERS TO AVOID ANY HTTP 403, 406, ETC ERRORS
    ## MAKE THIS DEFAULT IN EVERYTHING YOU DO WITH BEAUTIFUL SOUP
    hdr = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A'}
    req = urllib.request.Request(url,headers=hdr)
    content = urllib.request.urlopen(req).read()
    soup = BeautifulSoup(content, 'html.parser' )
    return soup
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def BSgetMetaDesc(soup):
    ############# EXTRACTING THE META DESCRIPTION FROM THE WEBPAGE #############
    #### Description is Case-Sensitive. So, we need to look for both 'Description' and 'description'.
    META_DESCRIPTION = "No meta description found." ## INITIALIZING
    META_DESCRIPTION_TMP = "No meta description found." ## INITIALIZING
    try:
        meta_desc = soup.find(attrs={'name':'description'})
        if meta_desc == None:
            meta_desc = soup.find(attrs={'name':'Description'})
        ## PRINTING THE META CONTENT DESCRIPTION
        META_DESCRIPTION_TMP = meta_desc['content']
        META_DESCRIPTION_TMP = META_DESCRIPTION_TMP.strip('\n') ## Stripping newline chars
        LEN_META_DESC = str(len(META_DESCRIPTION_TMP)) ## CONVERT INT TO STRING
        print(">> LENGTH OF META DESCRIPTION: ", LEN_META_DESC)
        ## Meta description should be less than 160 characters long, ideal for Google SERP. 155-160 is ideal.
        META_DESCRIPTION = '<strong>CURRENT LENGTH: </strong>' + LEN_META_DESC + '<br><span style="color:blue;" >' + META_DESCRIPTION_TMP[:160] + '</span>' + META_DESCRIPTION_TMP[160:]
        ##
        print(">>>> META_DESCRIPTION: \n", META_DESCRIPTION)
    except:
        print("***** BEAUTIFUL SOUP ERROR: FAILED TO FIND META DESCRIPTION TAG IN WEBPAGE ***** = ")
    ##
    return META_DESCRIPTION    
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def BSfindMainContentArticleDivHtml(soup):
    try:
        print("-------------------------------------------------------------------")
        ## finding main post content in mggk site
        my_main_div_html = soup.find("div", class_="mggk-main-article-content")
        ## finding main post content in all other sites worldwide
        if my_main_div_html == None:
            my_main_div_html = soup.find("article")
        ## if no main content is found still, try with the whole webpage
        if my_main_div_html == None:
            my_main_div_html = soup
        #print(my_main_div_html.prettify())
    except:
        print("***** BEAUTIFUL SOUP ERROR: FAILED TO FIND ARTICLE HTML TAG IN WEBPAGE ***** = ", url)
    ##
    return my_main_div_html  
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def BSgetNumberOfWords(my_main_div_html):
    num_words = 0 ;
    BSOUP_NUMWORDS = 0
    my_main_div_text = my_main_div_html.get_text()
    num_words = len(my_main_div_text.split())
    BSOUP_NUMWORDS = num_words
    return BSOUP_NUMWORDS
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def BScalculateReadingTime(BSOUP_NUMWORDS):
    BSOUP_READINGTIME_212WPM = round(BSOUP_NUMWORDS/212, 1)
    return BSOUP_READINGTIME_212WPM
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def BSgetAllHeadings(soup):
    ########## FINDING HEADINGS: H1,H2,H3,H4,H5,H6
    h1_array = []
    h2_array = []
    h3_array = []
    h4_array = []
    h5_array = []
    h6_array = []
    ##
    h1_array = soup.find_all("h1")
    h2_array = soup.find_all("h2")
    h3_array = soup.find_all("h3")
    h4_array = soup.find_all("h4")
    h5_array = soup.find_all("h5")
    h6_array = soup.find_all("h6")
    ## PRINTING ALL HEADINGS
    FULL_HEADINGS_ARRAY = []
    ##
    FULL_HEADINGS_ARRAY.append("<h1>H1 headings</h1>")
    for h1 in h1_array:
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h1.get_text())
    ##
    FULL_HEADINGS_ARRAY.append("<br><br><h2>H2 headings</h2>")
    for h2 in h2_array:
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h2.get_text())
    ##
    FULL_HEADINGS_ARRAY.append("<br><br><h2>H3 headings</h3>")
    for h3 in h3_array:
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h3.get_text())
    ##
    FULL_HEADINGS_ARRAY.append("<br><br><h4>H4 headings</h4>")
    for h4 in h4_array:
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h4.get_text())
    ##
    FULL_HEADINGS_ARRAY.append("<br><br><h5>H5 headings</h5>")
    for h5 in h5_array:
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h5.get_text())
    ##
    FULL_HEADINGS_ARRAY.append("<br><br><h6>H6 headings</h6>")
    for h6 in h6_array:
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h6.get_text())
    ##
    FULL_HEADINGS_ARRAY_FINAL = ''.join(str(v) for v in FULL_HEADINGS_ARRAY)
    ##print("\n>>>> ALL HEADINGS IN WEBPAGE: \n", FULL_HEADINGS_ARRAY_FINAL)
    return FULL_HEADINGS_ARRAY_FINAL
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def BSgetAllHyperlinks(my_main_div_html):    
    ## FINDING ALL HYPERLINKS ON WEBPAGE 
    all_hyperlinks = [] ;
    all_hyperlinks = my_main_div_html.find_all("a")
    ALL_HYPERLINKS_ARRAY_TMP = []
    print("\n>>>> ALL HYPERLINKS IN ARTICLE BLOCK: \n")
    for hlink in all_hyperlinks:
        hlink_href= str(hlink.get('href')) ## convert NoneType to String
        if ("http" in hlink_href):
            anchor_text_for_link = hlink.get_text() ## get the anchor text for this hyperlink
            print(hlink_href)
            hlink_href_substr = str(hlink_href[0:100]) ## extracting substring till 100 characters
            ALL_HYPERLINKS_ARRAY_TMP.append('<br>&rarr; LINK: <a target="_blank" href="'+ hlink_href + '">' + hlink_href_substr + '...</a>' + '<br>ANCHOR-TEXT: <strong>' + anchor_text_for_link + '</strong>')
    ##
    ALL_HYPERLINKS_ARRAY_TMP = sorted(ALL_HYPERLINKS_ARRAY_TMP) ## sorting the list
    ALL_HYPERLINKS_ARRAY = '<br>'.join(str(v) for v in ALL_HYPERLINKS_ARRAY_TMP)
    ##
    return ALL_HYPERLINKS_ARRAY
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def BSgetAllImages(my_main_div_html):
    ############# FINDING ALL IMAGES URLS + THEIR ALT_TAGS ON WEBPAGE ##########
    ALL_IMAGES = [] ;
    ALL_IMAGES = my_main_div_html.find_all('img')
    ALL_IMAGES_ARRAY_TMP = []
    for myimg in ALL_IMAGES:
        IMAGE_URL = str(myimg.get('src'))
        IMAGE_URL_SUBSTR = IMAGE_URL[0:100]
        IMAGE_ALT_TAG = str(myimg.get('alt'))
        #print(myimg)
        #print(IMAGE_URL)
        #print(IMAGE_ALT_TAG)
        #print('')
        ALL_IMAGES_ARRAY_TMP.append('<br>&rarr; IMAGE_URL: <a target="_blank" href="' + IMAGE_URL + '">' + IMAGE_URL_SUBSTR + '...</a>')
        ALL_IMAGES_ARRAY_TMP.append('IMAGE_ALT_TAG: <strong>' + IMAGE_ALT_TAG + '</strong>')
    ##
    ALL_IMAGES_ARRAY = '<br>'.join(str(v) for v in ALL_IMAGES_ARRAY_TMP)
    #print("\n>>>> ALL IMAGES IN ARTICLE BLOCK: \n")
    #print(ALL_IMAGES_ARRAY)
    ##
    return ALL_IMAGES_ARRAY
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def BSgetMetaGeneratorName(soup):
    #### FINDING THE META GENERATOR NAME VALUE FROM THE WEBPAGE    
    ## This is of the format such as = <meta name="generator" content="WordPress 5.2.4" />
    meta_generator_tmp = soup.find(attrs={'name':'generator'})
    if meta_generator_tmp == None:
        META_GENERATOR = "Generator name not found."
    else:
        META_GENERATOR = str(meta_generator_tmp['content'])
    ##
    print("\n>>>> WEBSITE_CREATED_USING: ", META_GENERATOR)
    return META_GENERATOR
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def BSgetTitleTag(soup):
    ################################################################################
    ## GETTING THE TITLE TAG TEXT FROM THE WEBPAGE
    TITLE_TAG_VALUE = "No title tag value found."
    try:
        TITLE_TAG_VALUE = soup.find('title').get_text()
        TITLE_TAG_VALUE = TITLE_TAG_VALUE.strip('\n') ## Stripping newline chars
        if TITLE_TAG_VALUE == None:
            TITLE_TAG_VALUE = "No title tag value found."
    except:
        print("***** BEAUTIFUL SOUP ERROR: FAILED TO FIND TITLE HTML TAG IN WEBPAGE ***** = ", url)
    ##
    print("\n>>>> PAGE TITLE: ",TITLE_TAG_VALUE)
    return TITLE_TAG_VALUE
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def BSgetPublishedDate(soup):
    ## FINDING PUBLISHED DATE
    META_PUBLISHED_DATETIME = "Not found = first published time"
    try:
        #### Most webpages have this format in the HTML source code:
        #### <meta property="article:published_time" content="2014-03-16T23:10:22+00:00" />
        meta_published_time_tmp = soup.find(attrs={'property':'article:published_time'})
        META_PUBLISHED_DATETIME = str(meta_published_time_tmp['content'])
        META_PUBLISHED_DATETIME = META_PUBLISHED_DATETIME[:19] ## DISCARDING TIMEZONE INFO BY SUBSTRING METHOD
        print("\n>>>> META_PUBLISHED_DATETIME: ", META_PUBLISHED_DATETIME)
    except:
        print("***** BEAUTIFUL SOUP ERROR: FAILED TO FIND PUBLISHED DATE IN WEBPAGE ***** = ")
    ##
    return META_PUBLISHED_DATETIME
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def BSgetModifiedDate(soup):
    ## FINDING MODIFIED DATE
    META_MODIFIED_DATETIME = "Not found = last updated time"
    try:
        #### Most webpages have this format in the HTML source code:
        #### <meta property="article:modified_time" content="2014-03-16T23:10:22+00:00" />
        meta_modified_time_tmp = soup.find(attrs={'property':'article:modified_time'})
        META_MODIFIED_DATETIME = str(meta_modified_time_tmp['content'])
        META_MODIFIED_DATETIME = META_MODIFIED_DATETIME[:19] ## DISCARDING TIMEZONE INFO BY SUBSTRING METHOD
        print(">>>> META_MODIFIED_DATETIME: ", META_MODIFIED_DATETIME)
    except:
        print("***** BEAUTIFUL SOUP ERROR: FAILED TO FIND MODIFIED DATE IN WEBPAGE ***** = ")
    ##
    return META_MODIFIED_DATETIME
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def days_between(date1, date2):
    ## DEFINE FUNCTION TO CALCULATE DATE DIFFERENCE
    d1 = datetime.strptime(date1, "%Y-%m-%d")
    d2 = datetime.strptime(date2, "%Y-%m-%d")
    return abs((d2 - d1).days) ## RETURNS A TIMEDELTA OBJECT
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def getPublishedDate_DateDiff(META_PUBLISHED_DATETIME):
    ARRAY_PUBLISHED_DATE_AND_YEAR = [] ;
    days_diff_first_published = 0  # chosen default value
    YEARS_SINCE_FIRST_PUBLISHED = round(int(days_diff_first_published)/365, 3)
    ##
    try:
        ## CONVERTING OBTAINED DATE STRINGS INTO PYTHON DATE OBJECTS FOR CALCULATIONS
        #### a.) converting string to corresponding date format (by using strptime)
        date_post_published_tmp = datetime.strptime(META_PUBLISHED_DATETIME, "%Y-%m-%dT%H:%M:%S")
        #### b.) converting thus created date into desired format for printing (by using strftime)
        date_post_published = datetime.strftime(date_post_published_tmp, '%Y-%m-%d')
        ## GETTING TODAY
        today_tmp = datetime.now()
        date_today = datetime.strftime(today_tmp,'%Y-%m-%d')
        ##
        days_diff_first_published = days_between(date_today, date_post_published)
        YEARS_SINCE_FIRST_PUBLISHED = round(int(days_diff_first_published)/365,3)
    except:
        print ('**** PUBLISHED DATE IS NOT VALID. HENCE, NO CALCULATIONS CAN BE DONE. ****')
    ##    
    ARRAY_PUBLISHED_DATE_AND_YEAR = [days_diff_first_published , YEARS_SINCE_FIRST_PUBLISHED]
    return ARRAY_PUBLISHED_DATE_AND_YEAR
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def getModifiedDate_DateDiff(META_MODIFIED_DATETIME):
    ARRAY_MODIFIED_DATE_AND_YEAR = [] ;
    days_diff_modified = 0  # chosen default value
    YEARS_SINCE_LAST_MODIFIED = round(int(days_diff_modified)/365, 3)
    ##
    try:
        ## CONVERTING OBTAINED DATE STRINGS INTO PYTHON DATE OBJECTS FOR CALCULATIONS
        #### a.) converting string to corresponding date format (by using strptime)
        date_post_modified_tmp = datetime.strptime(META_MODIFIED_DATETIME, "%Y-%m-%dT%H:%M:%S")
        #### b.) converting thus created date into desired format for printing (by using strftime)
        date_post_modified = datetime.strftime(date_post_modified_tmp, '%Y-%m-%d')
        ## GETTING TODAY
        today_tmp = datetime.now()
        date_today = datetime.strftime(today_tmp,'%Y-%m-%d')
        ##
        days_diff_modified = days_between(date_today, date_post_modified)
        YEARS_SINCE_LAST_MODIFIED = round(int(days_diff_modified)/365,3)
    except:
        print('**** MODIFIED DATE IS NOT VALID. HENCE, NO CALCULATIONS CAN BE DONE. ****')
    ##
    ARRAY_MODIFIED_DATE_AND_YEAR = [days_diff_modified, YEARS_SINCE_LAST_MODIFIED]
    return ARRAY_MODIFIED_DATE_AND_YEAR
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def createFinalAllDateTimesArray(url, META_PUBLISHED_DATETIME, META_MODIFIED_DATETIME, ARRAY_PUBLISHED_DATE_AND_YEAR, ARRAY_MODIFIED_DATE_AND_YEAR):
    BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY = []
    BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP = []
    ##
    BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('<strong>URL: ' + url + '</strong>')
    BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('META_PUBLISHED_DATETIME: ' + META_PUBLISHED_DATETIME)
    BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('META_MODIFIED_DATETIME: ' + META_MODIFIED_DATETIME)
    BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('Post first published: ' + str(ARRAY_PUBLISHED_DATE_AND_YEAR[0]) + ' days ago' + ' = <strong>' + str(ARRAY_PUBLISHED_DATE_AND_YEAR[1]) + ' years ago</strong>' )
    BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('Post last modified: ' + str(ARRAY_MODIFIED_DATE_AND_YEAR[0]) + ' days ago' + ' = <strong>' + str(ARRAY_MODIFIED_DATE_AND_YEAR[1]) + ' years ago</strong>' )
    ##
    BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY = '<br><br>'.join(str(v) for v in BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP)
    ##
    return BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def calculateRowColor(YEARS_SINCE_FIRST_PUBLISHED):
       ####################################
        ## ASSIGNING A SUITABLE COLOR WRT WEBPAGE FIRST PUBLISHED AGE IN YEARS
        #### Colors (from recent to oldest // recent is red-hot; oldest is so cold like blue ice) =
        #### red (under 1 yr), orange (1-2.5 yrs), yellow (2.5-4 yrs), light blue (4-5.5 yrs), darkblue (older than 5.5 yrs)
        years_old = YEARS_SINCE_FIRST_PUBLISHED
        row_color = "#000000" ## default is black
        ##
        if ( 0.000 < years_old <= 0.250) :
            row_color = "deeppink"
        elif ( 0.250 < years_old <= 1.0) :
            row_color = "red"
        elif (1.0 < years_old <= 2.5) :
            row_color = "orange"
        elif (2.5 < years_old <= 4.0) :
            row_color = "yellow"
        elif (4.0 < years_old <= 6.0) :
            row_color = "skyBlue"
        elif (years_old > 6.0) :
            row_color = "blue"
        else:
            row_color = "#000000"
        ##
        print("++++ROW COLOR = ",row_color, "// years_old",years_old)
        ##
        return row_color
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def extractNLPvaribles(url):
    article = Article(url)
    NLP_FULL_ARRAY = []
    ##
    ## Downloading and parse the article
    article.download()
    article.parse()
    article.nlp()
    all_words = article.text.split()
    ##
    NLP_ARTICLE_AUTHORS = article.authors
    ##
    NLP_ARTICLE_PUBLISH_DATE_TMP = str(article.publish_date).replace(' ','T')
    NLP_ARTICLE_PUBLISH_DATE = NLP_ARTICLE_PUBLISH_DATE_TMP[:19] ## stripping off the timezone part
    ##
    NLP_ARTICLE_TOP_IMAGE = article.top_image +'<br><br><img width="300px" src="'+ article.top_image+'"></img>'
    NLP_ARTICLE_ANY_VIDEO = str(' // '.join(article.movies)) 
    
    ##
    NLP_TOP_KEYWORDS = str('<br>'.join(article.keywords))
    NLP_TOP_KEYWORDS_FOR_CSV = str(' - '.join(article.keywords))
    ##
    NLP_ARTICLE_SUMMARY_TMP = article.summary
    NLP_ARTICLE_SUMMARY = NLP_ARTICLE_SUMMARY_TMP.replace('\n', '<br><br>')
    ##
    NLP_READINGTIME_212WPM = round( len(all_words)/212, 1 )
    NLP_NUMWORDS = len(all_words)
    ##
    print(">>>> [NLP] NUMBER OF WORDS = ", NLP_NUMWORDS)
    print(">>>> [NLP] READING TIME (212 wpm) = ", NLP_READINGTIME_212WPM, " minutes")
    ##
    NLP_FULL_ARRAY = [ NLP_ARTICLE_AUTHORS, NLP_ARTICLE_PUBLISH_DATE, NLP_ARTICLE_TOP_IMAGE, NLP_ARTICLE_ANY_VIDEO, NLP_TOP_KEYWORDS, NLP_ARTICLE_SUMMARY, NLP_READINGTIME_212WPM, NLP_NUMWORDS ] ; 
    ##
    return NLP_FULL_ARRAY
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------
def extractKeywordsViaRAKE(articleText):
    ## BEGIN: KEYWORDS EXTRACTION USING RAKE (PYTHON PACKAGE)
    import RAKE
    # RAKE setup with stopword directory
    #rake_stop_dir = "./rake/MGGK-SmartStoplist.txt"
    rake_object = RAKE.Rake(rake_stop_dir)
    ##
    # Extracting keywords using RAKE on article.text
    keywords = rake_object.run(articleText)
    ##
    # PRINTING TOP KEYWORD PHRASES
    print("\n\n>>>> [RAKE] PRINTING TOP KEYWORD PHRASES (keywords, score)\n")
    RAKE_TOP_KEYWORD_PHRASES_ARRAY=[]
    for kw in keywords[:30]:
        print(kw)
        rake_string_kw = str(kw[0]) + ' // ' + str( round(kw[1],2) )
        RAKE_TOP_KEYWORD_PHRASES_ARRAY.append(rake_string_kw)
    ## CONVERTING THIS ARRAY TO A STRING OF WORDS FOR HTML OUTPUT
    RAKE_TOP_KEYWORD_PHRASES = str('<br>'.join(RAKE_TOP_KEYWORD_PHRASES_ARRAY))
    ##
    return RAKE_TOP_KEYWORD_PHRASES
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------




def doAllMagic(url,URL_COUNT):
    #url = 'https://www.mygingergarlickitchen.com/pineapple-juice/'
    url = url.strip() ## removes all leading+trailing whitespaces
    ####
    articleText = downloadArticleText(url)
    ##
    TOP20_WORDS_STRING_HTML = countOccurenceOfWords(articleText)
    ## Beautiful Soup block
    soup = BeautifulSoupGetArticleMainContent(url)
    META_DESCRIPTION = BSgetMetaDesc(soup)
    my_main_div_html = BSfindMainContentArticleDivHtml(soup)
    BSOUP_NUMWORDS = BSgetNumberOfWords(my_main_div_html)
    BSOUP_READINGTIME_212WPM = BScalculateReadingTime(BSOUP_NUMWORDS)
    all_hyperlinks = BSgetAllHyperlinks(my_main_div_html)
    ALL_IMAGES = BSgetAllImages(my_main_div_html)
    FULL_HEADINGS_ARRAY_FINAL = BSgetAllHeadings(soup)
    ALL_HYPERLINKS_ARRAY = BSgetAllHyperlinks(my_main_div_html)
    ALL_IMAGES_ARRAY = BSgetAllImages(my_main_div_html)
    META_GENERATOR = BSgetMetaGeneratorName(soup)
    TITLE_TAG_VALUE = BSgetTitleTag(soup)
    ##
    META_PUBLISHED_DATETIME = BSgetPublishedDate(soup) ;
    META_MODIFIED_DATETIME = BSgetModifiedDate(soup) ;
    ARRAY_PUBLISHED_DATE_AND_YEAR = getPublishedDate_DateDiff(META_PUBLISHED_DATETIME) ;
    ARRAY_MODIFIED_DATE_AND_YEAR = getModifiedDate_DateDiff(META_MODIFIED_DATETIME) ;
    BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY = createFinalAllDateTimesArray(url, META_PUBLISHED_DATETIME, META_MODIFIED_DATETIME, ARRAY_PUBLISHED_DATE_AND_YEAR, ARRAY_MODIFIED_DATE_AND_YEAR) ;
    YEARS_SINCE_FIRST_PUBLISHED = ARRAY_PUBLISHED_DATE_AND_YEAR[1] ;
    YEARS_SINCE_LAST_MODIFIED = ARRAY_MODIFIED_DATE_AND_YEAR[1] ; 
    row_color = calculateRowColor(YEARS_SINCE_FIRST_PUBLISHED) ;    
    ##
    RAKE_TOP_KEYWORD_PHRASES = extractKeywordsViaRAKE(articleText)
    ## NLP block
    NLP_FULL_ARRAY = extractNLPvaribles(url)
    NLP_ARTICLE_AUTHORS = NLP_FULL_ARRAY[0]
    NLP_ARTICLE_PUBLISH_DATE = NLP_FULL_ARRAY[1]
    NLP_ARTICLE_TOP_IMAGE = NLP_FULL_ARRAY[2]
    NLP_ARTICLE_ANY_VIDEO = NLP_FULL_ARRAY[3]
    NLP_TOP_KEYWORDS = NLP_FULL_ARRAY[4]
    NLP_ARTICLE_SUMMARY = NLP_FULL_ARRAY[5]
    NLP_READINGTIME_212WPM = NLP_FULL_ARRAY[6]
    NLP_NUMWORDS = NLP_FULL_ARRAY[7]
    #############
    #print(articleText)
    #print(soup)
    #print(BSOUP_NUMWORDS)
    #print(all_hyperlinks)
    #print(ALL_IMAGES)
    #print(FULL_HEADINGS_ARRAY_FINAL)
    #print(ALL_HYPERLINKS_ARRAY)
    #print(BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY)
    #print(NLP_FULL_ARRAY)
    #print(RAKE_TOP_KEYWORD_PHRASES)
    #print(NLP_FULL_ARRAY)
    #############
    ## APPENDING VALUES FOR THIS URL TO MAIN ARRAYS
    array1.append('<tr><td>'+ str(URL_COUNT) +'</td></tr>')
    array2.append('<tr><td>'+ str(URL_COUNT) +' // <a target="_blank" href="'+ url +'">' + url + '</a></td></tr>')
    array3.append('<tr><td>'+ NLP_ARTICLE_TOP_IMAGE +'</td></tr>')
    array4.append('<tr><td>'+ META_GENERATOR +'</td></tr>')
    array5.append('<tr><td>'+ TITLE_TAG_VALUE +'</td></tr>')
    array6.append('<tr><td>URL: '+ url + '<br><br>' + META_DESCRIPTION +'</td></tr>')
    array7.append('<tr><td>'+ str(NLP_ARTICLE_ANY_VIDEO) +'</td></tr>')
    array8.append('<tr><td>URL: '+ url + '<br><br>' + TOP20_WORDS_STRING_HTML + '</td></tr>')
    array9.append('<tr><td>'+ str(BSOUP_NUMWORDS) + ' words</td></tr>')
    array10.append('<tr><td>'+ str(NLP_NUMWORDS) +' words</td></tr>')
    array11.append('<tr><td>' + str(BSOUP_READINGTIME_212WPM) +' minutes</td></tr>')
    array12.append('<tr><td>'+ str(NLP_ARTICLE_AUTHORS) +'</td></tr>')
    array13.append('<tr><td>'+ str(BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY) +'</td></tr>')
    array14.append('<tr><td>'+ str(NLP_ARTICLE_PUBLISH_DATE) +'</td></tr>')
    array15.append('<tr><td>URL: '+ url + '<br><br>' + '<span style="color:blue">'+ NLP_ARTICLE_SUMMARY +'</span></td></tr>')
    array16.append('<tr><td>URL: '+ url + '<br><br>' + NLP_TOP_KEYWORDS +'</td></tr>')
    array17.append('<tr><td>URL: '+ url + '<br><br>' + RAKE_TOP_KEYWORD_PHRASES +'</td></tr>')
    array18.append('<tr><td>URL: '+ url + '<br><br>' + FULL_HEADINGS_ARRAY_FINAL +'</td></tr>')
    array19.append('<tr><td>URL: '+ url + '<br><br>' + ALL_HYPERLINKS_ARRAY +'</td></tr>')
    array20.append('<tr><td>URL: '+ url + '<br><br>' + ALL_IMAGES_ARRAY +'</td></tr>')
##------------------------------------------------------------------------------
##------------------------------------------------------------------------------


################################################################################
################################################################################
## CREATING EMPTY ARRAYS
array1 = [] ;
array2 = [] ;
array3 = [] ;
array4 = [] ;
array5 = [] ;
array6 = [] ;
array7 = [] ;
array8 = [] ;
array9 = [] ;
array10 = [] ;
array11 = [] ;
array12 = [] ;
array13 = [] ;
array14 = [] ;
array15 = [] ;
array16 = [] ;
array17 = [] ;
array18 = [] ;
array19 = [] ;
array20 = [] ;

##
array1.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">URL COUNT</th>')
array2.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">URL</th>')
array3.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">NLP_ARTICLE_TOP_IMAGE</th>')
array4.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">META_GENERATOR</th>')
array5.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">TITLE_TAG_VALUE</th>')
array6.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">META_DESCRIPTION</th>')
array7.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">NLP_ARTICLE_ANY_VIDEO</th>')
array8.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">TOP20_WORDS_STRING_HTML</th>')
array9.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">BSOUP_NUMWORDS</th>')
array10.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">NLP_NUMWORDS</th>')
array11.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">BSOUP_READINGTIME_212WPM</th>')
array12.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">NLP_ARTICLE_AUTHORS</th>')
array13.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY</th>')
array14.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">NLP_ARTICLE_PUBLISH_DATE</th>')
array15.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">NLP_ARTICLE_SUMMARY</th>')
array16.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">NLP_TOP_KEYWORDS</th>')
array17.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">RAKE_TOP_KEYWORD_PHRASES</th>')
array18.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">FULL_HEADINGS_ARRAY_FINAL</th>')
array19.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">ALL_HYPERLINKS_ARRAY</th>')
array20.append('<table class="table table-striped table-bordered"><thead class="thead-dark"><tr><th scope="col">ALL_IMAGES_ARRAY</th>')


################################################################################
################################################################################
## OPEN HTML OUTPUT FILE FOR WRITING the first line. AFter that, the file will be appended using 'a' flag.
f = open(OUTPUT_HTML_FILE,'w')
f.write(BOOTSTRAP4_HTML_HEADER)
f.write('Created on: '+ TIME_NOW)
f.write('<h1>MGGK - Keyword Analysis using NLP (Natural Language Processing)</h1>')
f.write('<div class="container-fluid"><div class="row">')
f.write('</div></div><hr>')
f.close()


#################################################################################
## CALLING THE ABOVE MAIN FUNCTION ON EACH URL LINE FROM URL LINKS TEXT FILE
#################################################################################
myfile = open(NLP_URLS_TEXT_FILE, "r")
MY_URL_COUNT=0
for line in myfile:
    ## Moving forward only when the line contains the substring 'http', meaning
    ## it's a valid url
    if ('http' in line):
        MY_URL_COUNT = MY_URL_COUNT+1
        print("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        print(">>>> URL# " + str(MY_URL_COUNT) + " // CURRENT URL READING: ",line)
        print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
        line=line.strip() ## removes all unnecessary character in line (leading and trailing)
        #mggk_find_ai_details_from_url_lines(url = line, URL_COUNT = MY_URL_COUNT)
        doAllMagic(url = line, URL_COUNT = MY_URL_COUNT)
#################################################################################
#################################################################################

## FINALLY APPENDING THE LAST VALUES TO ARRAYS
array1.append('</tr></thead><tbody></table>')
array2.append('</tr></thead><tbody></table>')
array3.append('</tr></thead><tbody></table>')
array4.append('</tr></thead><tbody></table>')
array5.append('</tr></thead><tbody></table>')
array6.append('</tr></thead><tbody></table>')
array6.append('</tr></thead><tbody></table>')
array8.append('</tr></thead><tbody></table>')
array9.append('</tr></thead><tbody></table>')
array10.append('</tr></thead><tbody></table>')
array11.append('</tr></thead><tbody></table>')
array12.append('</tr></thead><tbody></table>')
array13.append('</tr></thead><tbody></table>')
array14.append('</tr></thead><tbody></table>')
array15.append('</tr></thead><tbody></table>')
array16.append('</tr></thead><tbody></table>')
array17.append('</tr></thead><tbody></table>')
array18.append('</tr></thead><tbody></table>')
array19.append('</tr></thead><tbody></table>')
array20.append('</tr></thead><tbody></table>')
####
##################
## WRITING ALL FINALIZED ARRAYS TO THE HTML FILE
## Comment or uncomment the blocks as needed
f = open(OUTPUT_HTML_FILE,'a')
#f.write(''.join(str(v) for v in array1))
f.write(''.join(str(v) for v in array2))
f.write(''.join(str(v) for v in array3))
f.write(''.join(str(v) for v in array4))
f.write(''.join(str(v) for v in array5))
f.write(''.join(str(v) for v in array6))
f.write(''.join(str(v) for v in array7))
f.write(''.join(str(v) for v in array8))
f.write(''.join(str(v) for v in array9))
f.write(''.join(str(v) for v in array10))
f.write(''.join(str(v) for v in array11))
f.write(''.join(str(v) for v in array12))
f.write(''.join(str(v) for v in array13))
f.write(''.join(str(v) for v in array14))
f.write(''.join(str(v) for v in array15))
f.write(''.join(str(v) for v in array16))
f.write(''.join(str(v) for v in array17))
f.write(''.join(str(v) for v in array18))
f.write(''.join(str(v) for v in array19))
f.write(''.join(str(v) for v in array20))
#################################################################################
#################################################################################

###########################
## FINAL HTML OUTPUT OPERATIONS
#f.write('</tbody></table>')
f.write(BOOTSTRAP4_HTML_FOOTER)
f.close()
