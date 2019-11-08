################################################################################
THIS_PROGRAM_DETAILS = """
################################################################################
THIS_SCRIPT_NAME: 601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls.py
################################################################################
REQUIREMENTS_FILE  = 601-MGGK-REQUIREMENT-ALL-URLS-FOR-NLP.txt
(Note: This file should be present in the 'Desktop/Y/' directory)
################################################################################
USAGE: python3 THIS_SCRIPT_NAME
################################################################################
################################################################################
THIS SCRIPT USES NATURAL LANGUAGE PROCESSING (NLP + AI), Newspaper3k, and BeautifulSoup 4
OVER AN EXTERNAL TEXT FILE CONTAINING URLS FOR KEYWORDS ANALYSIS, AND PRODUCES
A DETAILED HTML FILE WITH ALL THE EXTRACTED DATA FOR EACH URL PRESENT IN
THE REQUIREMENTS_FILE.
################################################################################
THIS SCRIPT ALSO PRODUCES SOME CSV FILES FOR LATER ANALYSES (OR FOR PLOTTING).
################################################################################
CREATED ON: November 5, 2019
CREATED BY: Pali
################################################################################

"""

################################################################################
print(THIS_PROGRAM_DETAILS)
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
home = expanduser("~")

## IF THIS SCRIPT IS RUNNING ON THE VPS SERVER, THEN CHECK FOR THE USERNAME 'ubuntu' IN HOME DIRECTORY,
#### AND SET DIRECTORY PATHS APPROPRIATELY. ELSE, SET OTHER PATHS FOR EXECUTION LOCALLY.
if ('ubuntu' not in home):
    dirpath = '/GitHub/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/600-mggk-artificial-intelligence-nlp-programs/601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls'
    rake_stop_dir = home + dirpath + '/601-MGGK-PYTHON-RAKE-SmartStoplist.txt'
    working_directory = '/Desktop/Y/'
else:
    dirpath = dirpath = home + '/scripts-made-by-pali/600-mggk-ai-nlp-scripts'
    rake_stop_dir = dirpath + '/601-MGGK-PYTHON-RAKE-SmartStoplist.txt'
    working_directory = dirpath

################################################################################
## DO NOT EDIT ANYTHING BELOW. THE FOLLOWING CODE WILL WORK UNIVERSALLY.
################################################################################
## PTINTING IMPORTANT PATHS
print('') ## empty line
print('>>>> HOME = ',home)
print('>>>> CURRENT WORKING DIRECTORY = ',dirpath)
print('>>>> RAKE STOP WORDS DIRECTORY = ',rake_stop_dir)
print('') ## empty line
################################################################################
prefix_dateformat="%Y%m%d"
prefix_today = datetime.strftime(datetime.now(), prefix_dateformat)

NLP_URLS_TEXT_FILE = home + working_directory + '601-MGGK-REQUIREMENT-ALL-URLS-FOR-NLP.txt'
OUTPUT_HTML_FILE = home + working_directory + str(prefix_today) + '_TMP_601_MGGK_AI_NLP_HTML_OUTPUT.HTML'
OUTPUT_CSV_FILE = home + working_directory + str(prefix_today) +'_TMP_601_MGGK_AI_NLP_OUTPUT_FOR_FUTURE_ANALYSES.CSV'
#######################################

################################################################################
################################################################################
dateformat="%Y-%m-%d %H:%M"
TIME_NOW = datetime.strftime(datetime.now(), dateformat)

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

BOOTSTRAP4_HTML_FOOTER = """   </div> <!-- END: main containter div -->
    <!-- Optional Bootstrap JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src='https://code.jquery.com/jquery-3.3.1.slim.min.js'></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js'></script>
    <script src='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js'></script>
  </body>
</html>"""

################################################################################

################################################################################
#### SETTING THE URL FOR TESTING PURPOSES
#url = 'https://www.mygingergarlickitchen.com/diwali-flatbread-recipes/'
#url=url.strip() ## removes all unnecessary character in line (leading and trailing)

################################################################################
## BEGIN: ALL FUNCTION DEFINITIONS
################################################################################
## DEFINING THE MAIN FUNCTION WHICH WILL WORK UPON EACH URL LINE IN AN EXTERNAL TEXT FILE
def mggk_find_ai_details_from_url_lines(url,URL_COUNT):
    #########################################################
    ## BEGIN: GETTING SOME PRIMARY DETAILS USING NEWSPAPER3K
    #########################################################
    article = Article(url)

    try:
        print("//-----------------------------------------------------------------//")
        ## Downloading the article
        article.download()
        ## Parsing the article
        article.parse()
        article.nlp()
        #print(article.html)
        #print(article.text)
        #print(">>>> ARTICLE FULL TEXT [via NLP] = ", article.text)
    except:
        print('***** NLP ERROR: FAILED TO DOWNLOAD *****', article.url)
        pass
    #########################################################
    ## END: GETTING SOME PRIMARY DETAILS USING NEWSPAPER3K
    #########################################################

    ######################################
    ######################################
    ## COUNT THE NUMBER OF OCCURENCES OF EACH WORD IN FULL TEXT
    all_words = article.text.split()
    word_with_counts = {}
    for word in all_words:
        count = word_with_counts.get(word, 0)
        count += 1
        word_with_counts[word] = count
    #print(word_with_counts)

    ## SORTING THE COUNT
    word_with_counts_list = sorted(word_with_counts, key=word_with_counts.get, reverse=True)
    ## SHOW TOP 40 WORDS
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
    #######################################
    ######################################

    #########################################################
    ## BEGIN: GETTING SOME MORE DETAILS USING BeautifulSoup
    #########################################################
    ## FIRS YOU NEED TO SET HEADER PARAMETERS TO AVOID ANY HTTP 403, 406, ETC ERRORS
    ## MAKE THIS ERROR DEFAULT IN EVERYTHING YOU DO WITH BEAUTIFUL SOUP
    hdr = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A'}
    #url = 'https://www.mygingergarlickitchen.com/diwali-flatbread-recipes/'
    #url=url.strip() ## removes all unnecessary character in line (leading and trailing)
    req = urllib.request.Request(url,headers=hdr)
    content = urllib.request.urlopen(req).read()
    soup = BeautifulSoup(content, 'html.parser' )

    ############# EXTRACTING THE META DESCRIPTON FROM THE WEBPAGE #############
    #### Description is Case-Sensitive. So, we need to look for both 'Description' and 'description'.
    META_DESCRIPTION = "No meta description found." ## INITIALIZING
    try:
        meta_desc = soup.find(attrs={'name':'description'})
        if meta_desc == None:
            meta_desc = soup.find(attrs={'name':'Description'})
        ## PRINTING THE META CONTENT DESCRIPTION
        META_DESCRIPTION = meta_desc['content']
        print(">>>> META_DESCRIPTION: \n", META_DESCRIPTION)
    except:
        print("***** BEAUTIFUL SOUP ERROR: FAILED TO FIND META DESCRIPTION TAG IN WEBPAGE ***** = ", url)

    ## INITIALIZING SOME VALUES, ELSE BS4 GIVES ERRORS IF NO SUCH TAG IS FOUND ON WEBPAGE
    num_words = 0 ;
    BSOUP_NUMWORDS = 0
    h1_array = []
    h2_array = []
    h3_array = []
    h4_array = []
    h5_array = []
    h6_array = []
    all_hyerlinks = []
    YEARS_SINCE_FIRST_PUBLISHED = 0
    YEARS_SINCE_LAST_MODIFIED = 0

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
        my_main_div_text = my_main_div_html.get_text()
        #print(">>>> ALL EXTRACTED TEXT [BEAUTIFUL SOUP]: ", my_main_div_text)
        num_words = len(my_main_div_text.split())
        print(">>>> NUMBER OF WORDS [BEAUTIFUL SOUP]: ", num_words)
        BSOUP_NUMWORDS = num_words
        all_hyerlinks = my_main_div_html.find_all("a")
        ALL_IMAGES = my_main_div_html.find_all('img')

    except:
        print("***** BEAUTIFUL SOUP ERROR: FAILED TO FIND ARTICLE HTML TAG IN WEBPAGE ***** = ", url)

    print("//////////////////////////////////////////////////////////////////")
    ########## FINDING HEADINGS: H1,H2,H3,H4,H5,H6
    h1_array = soup.find_all("h1")
    h2_array = soup.find_all("h2")
    h3_array = soup.find_all("h3")
    h4_array = soup.find_all("h4")
    h5_array = soup.find_all("h5")
    h6_array = soup.find_all("h6")

    ## PRINTING ALL HEADINGS
    FULL_HEADINGS_ARRAY = []

    FULL_HEADINGS_ARRAY.append("<h1>H1 headings</h1>")
    for h1 in h1_array:
        print(h1)
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h1.get_text())

    FULL_HEADINGS_ARRAY.append("<br><br><h2>H2 headings</h2>")
    for h2 in h2_array:
        print(h2)
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h2.get_text())

    FULL_HEADINGS_ARRAY.append("<br><br><h2>H3 headings</h3>")
    for h3 in h3_array:
        print(h3)
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h3.get_text())

    FULL_HEADINGS_ARRAY.append("<br><br><h4>H4 headings</h4>")
    for h4 in h4_array:
        print(h4)
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h4.get_text())

    FULL_HEADINGS_ARRAY.append("<br><br><h5>H5 headings</h5>")
    for h5 in h5_array:
        print(h5)
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h5.get_text())

    FULL_HEADINGS_ARRAY.append("<br><br><h6>H6 headings</h6>")
    for h6 in h6_array:
        print(h6)
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h6.get_text())

    FULL_HEADINGS_ARRAY_FINAL = ''.join(str(v) for v in FULL_HEADINGS_ARRAY)
    print("\n>>>> ALL HEADINGS IN WEBPAGE: \n", FULL_HEADINGS_ARRAY_FINAL)

    ############# FINDING ALL HYPERLINKS ON WEBPAGE #######################
    ALL_HYPERLINKS_ARRAY_TMP = []
    print("\n>>>> ALL HYPERLINKS IN ARTICLE BLOCK: \n")
    for hlink in all_hyerlinks:
        hlink_href= str(hlink.get('href')) ## convert NoneType to String
        if ("http" in hlink_href):
            anchor_text_for_link = hlink.get_text() ## get the anchor text for this hyperlink
            print(hlink_href)
            hlink_href_substr = str(hlink_href[0:70]) ## extracting substring till 100 characters
            ALL_HYPERLINKS_ARRAY_TMP.append('<br>&rarr; LINK: <a target="_blank" href="'+ hlink_href + '">' + hlink_href_substr + '...</a>' + '<br>ANCHOR-TEXT: <strong>' + anchor_text_for_link + '</strong>')

    ALL_HYPERLINKS_ARRAY_TMP = sorted(ALL_HYPERLINKS_ARRAY_TMP) ## sorting the list
    ALL_HYPERLINKS_ARRAY = '<br>'.join(str(v) for v in ALL_HYPERLINKS_ARRAY_TMP)
    #######################################################################

    ############# FINDING ALL IMAGES URLS + THEIR ALT_TAGS ON WEBPAGE ##########
    ALL_IMAGES_ARRAY_TMP = []
    print("\n>>>> ALL IMAGES IN ARTICLE BLOCK: \n")
    for myimg in ALL_IMAGES:
        #print(myimg)
        IMAGE_URL = str(myimg.get('src'))
        IMAGE_URL_SUBSTR = IMAGE_URL[0:100]
        IMAGE_ALT_TAG = str(myimg.get('alt'))
        print(IMAGE_URL)
        print(IMAGE_ALT_TAG)
        print('')
        ALL_IMAGES_ARRAY_TMP.append('<br>&rarr; IMAGE_URL: <a target="_blank" href="' + IMAGE_URL + '">' + IMAGE_URL_SUBSTR + '</a>')
        ALL_IMAGES_ARRAY_TMP.append('IMAGE_ALT_TAG: <strong>' + IMAGE_ALT_TAG + '</strong>')

    ALL_IMAGES_ARRAY = '<br>'.join(str(v) for v in ALL_IMAGES_ARRAY_TMP)
    ############################################################################

    ################################################################################
    ## FINDING THE META GENERATOR NAME VALUE FROM THE WEBPAGE
    #### This is of the format such as = <meta name="generator" content="WordPress 5.2.4" />
    meta_generator_tmp = soup.find(attrs={'name':'generator'})
    if meta_generator_tmp == None:
        META_GENERATOR = "Generator name not found."
    else:
        META_GENERATOR = str(meta_generator_tmp['content'])

    print("\n>>>> WEBSITE_CREATED_USING: ", META_GENERATOR)
    ################################################################################

    ################################################################################
    ## GETTING THE TITLE TAG TEXT FROM THE WEBPAGE
    TITLE_TAG_VALUE = "No title tag value found."
    try:
        TITLE_TAG_VALUE = soup.find('title').get_text()
        if title_value_tmp == None:
            TITLE_TAG_VALUE = "No title tag value found."
    except:
        print("***** BEAUTIFUL SOUP ERROR: FAILED TO FIND TITLE HTML TAG IN WEBPAGE ***** = ", url)

    print("\n>>>> PAGE TITLE: ",TITLE_TAG_VALUE)
    ################################################################################

    ################################################################################
    ## BEGIN: FINDING PUBLISHED AND UPDATED/MODIFIED TIMES FOR WEBPAGE USING BEAUTIFUL SOUP
    ################################################################################
    print('\n///////////////////////////////////////////////////////////////////////\n')

    META_PUBLISHED_DATETIME = "Not found = first published time"
    META_MODIFIED_DATETIME = "Not found = last updated time"
    BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY = []
    row_color = "#000000" ## default is black

    try:
        #### Most webpages have this format in the HTML source code:
        #### <meta property="article:published_time" content="2014-03-16T23:10:22+00:00" />
        #### <meta property="article:modified_time" content="2014-03-16T23:10:22+00:00" />
        meta_published_time_tmp = soup.find(attrs={'property':'article:published_time'})
        META_PUBLISHED_DATETIME = str(meta_published_time_tmp['content'])
        META_PUBLISHED_DATETIME = META_PUBLISHED_DATETIME[:19] ## DISCARDING TIMEZONE INFO BY SUBSTRING METHOD
        print("\n>>>> META_PUBLISHED_DATETIME: ", META_PUBLISHED_DATETIME)

        meta_modified_time_tmp = soup.find(attrs={'property':'article:modified_time'})
        META_MODIFIED_DATETIME = str(meta_modified_time_tmp['content'])
        META_MODIFIED_DATETIME = META_MODIFIED_DATETIME[:19] ## DISCARDING TIMEZONE INFO BY SUBSTRING METHOD
        print(">>>> META_MODIFIED_DATETIME: ", META_MODIFIED_DATETIME)

        ## CONVERTING OBTAINED DATE STRINGS INTO PYTHON DATE OBJECTS FOR CALCULATIONS
        #### a.) converting string to corresponding date format (by using strptime)
        date_post_published_tmp = datetime.strptime(META_PUBLISHED_DATETIME, "%Y-%m-%dT%H:%M:%S")
        date_post_modified_tmp = datetime.strptime(META_MODIFIED_DATETIME, "%Y-%m-%dT%H:%M:%S")
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
        print(">>>> POST LAST MODIFIED: ", days_diff_modified, " days ago", " = ", round(days_diff_modified/365,3), " years ago" )

        YEARS_SINCE_FIRST_PUBLISHED = round(int(days_diff_first_published)/365,3)
        YEARS_SINCE_LAST_MODIFIED = round(int(days_diff_modified)/365,3)

        BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP = []

        BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('<strong>URL: <br>' + url + '</strong>')
        BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('META_PUBLISHED_DATETIME: <br>' + META_PUBLISHED_DATETIME)
        BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('META_MODIFIED_DATETIME: <br>' + META_MODIFIED_DATETIME)
        BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('<hr><h4 style="color: black;">Post first published: <br>' + str(days_diff_first_published) + ' days ago<br>' + ' = ' + str(YEARS_SINCE_FIRST_PUBLISHED) + ' years ago</h4>' )
        BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP.append('<h4 style="color: black;">Post last modified: <br>' + str(days_diff_modified) + ' days ago<br>' + ' = ' + str(YEARS_SINCE_LAST_MODIFIED) + ' years ago</h4>' )

        BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY = '<br><br>'.join(str(v) for v in BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY_TMP)

        print(">>>>>>")
        print(BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY)

        ####################################
        ## ASSIGNING A SUITABLE COLOR WRT WEBPAGE FIRST PUBLISHED AGE IN YEARS
        #### Colors (from recent to oldest // recent is red-hot; oldest is so cold like blue ice) =
        #### red (under 1 yr), orange (1-2.5 yrs), yellow (2.5-4 yrs), light blue (4-5.5 yrs), darkblue (older than 5.5 yrs)
        years_old = YEARS_SINCE_FIRST_PUBLISHED

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

        print("++++ROW COLOR = ",row_color, "// years_old",years_old)

    except:
        print("***** BEAUTIFUL SOUP ERROR: FAILED TO FIND PUBLISHED + MODIFIED DATES IN WEBPAGE ***** = ", url)

    ################################################################################
    ## END: FINDING PUBLISHED AND UPDATED/MODIFIED TIMES FOR WEBPAGE USING BEAUTIFUL SOUP
    ################################################################################


    #########################################################
    ## END: GETTING SOME MORE DETAILS USING BeautifulSoup
    #########################################################

    #########################################################
    ## BEGIN: PRINTING COMBINED OUTPUTS (NLP + Beautiful Soup)
    #########################################################
    print("\n#######################################################################")
    print(">>>>>>>>>>>>>>> PRINTING MAIN OUTPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<") ;
    print("#######################################################################\n")

    print(">>>> [NLP] ARTICLE URL = ", url)
    print(">>>> [NLP] ARTICLE AUTHORS = ", article.authors)
    print(">>>> [NLP] ARTICLE PUBLISH DATE = ", article.publish_date)
    print(">>>> [NLP] ARTICLE TOP IMAGE = ", article.top_image)
    print(">>>> [NLP] ARTICLE VIDEOS FOUND = ", article.movies)
    ####
    ## article.nlp() OUTPUTS
    print("\n>>>> [NLP] TOP KEYWORDS = ", article.keywords)
    print()
    print(">>>> [NLP] ARTICLE SUMMARY =\n\n", article.summary)

    NLP_ARTICLE_AUTHORS = article.authors

    NLP_ARTICLE_PUBLISH_DATE = str(article.publish_date).replace(' ','T')
    NLP_ARTICLE_PUBLISH_DATE = NLP_ARTICLE_PUBLISH_DATE[:19] ## stripping off the timezone part

    NLP_ARTICLE_TOP_IMAGE = article.top_image +'<br><br><img width="300px" src="'+ article.top_image+'"></img>'
    NLP_ARTICLE_ANY_VIDEO = article.movies

    NLP_TOP_KEYWORDS = str('<br>'.join(article.keywords))
    NLP_TOP_KEYWORDS_FOR_CSV = str(' - '.join(article.keywords))

    NLP_ARTICLE_SUMMARY_TMP = article.summary
    NLP_ARTICLE_SUMMARY = NLP_ARTICLE_SUMMARY_TMP.replace('\n', '<br><br>')

    print("\n#######################################################################")

    NLP_READINGTIME_212WPM = round( len(all_words)/212, 1 )
    NLP_NUMWORDS = len(all_words)
    print(">>>> [NLP] NUMBER OF WORDS = ", NLP_NUMWORDS)
    print(">>>> [NLP] READING TIME (212 wpm) = ", NLP_READINGTIME_212WPM, " minutes")
    print(">>>> [BEAUTIFUL SOUP] NUMBER OF WORDS = ", BSOUP_NUMWORDS)
    #########################################################
    ## END: PRINTING MAIN OUTPUTS
    #########################################################

    ################################################################################
    ## BEGIN: KEYWORDS EXTRACTION USING RAKE (PYTHON PACKAGE)
    ################################################################################
    import RAKE
    # RAKE setup with stopword directory
    #rake_stop_dir = "./rake/MGGK-SmartStoplist.txt"
    rake_object = RAKE.Rake(rake_stop_dir)

    # Extracting keywords using RAKE on article.text
    keywords = rake_object.run(article.text)

    # PRINTING TOP KEYWORD PHRASES
    print("\n\n>>>> [RAKE] PRINTING TOP KEYWORD PHRASES (keywords, score)\n")
    RAKE_TOP_KEYWORD_PHRASES_ARRAY=[]
    for kw in keywords[:30]:
        print(kw)
        rake_string_kw = str(kw[0]) + ' // ' + str( round(kw[1],2) )
        RAKE_TOP_KEYWORD_PHRASES_ARRAY.append(rake_string_kw)
    ## CONVERTING THIS ARRAY TO A STRING OF WORDS FOR HTML OUTPUT
    RAKE_TOP_KEYWORD_PHRASES = str('<br>'.join(RAKE_TOP_KEYWORD_PHRASES_ARRAY))
    ################################################################################
    ## END: KEYWORDS EXTRACTION USING RAKE (PYTHON PACKAGE)
    ################################################################################

    ################################################################################
    ## BEGIN: KEYWORDS EXTRACTION USING GENSIM (PYTHON PACKAGE)
    ################################################################################
    import gensim
    from gensim.summarization import summarize
    from gensim.summarization import keywords

    GENSIM_ARTICLE_SUMMARY_100 = "" # initializing
    GENSIM_ARTICLE_SUMMARY_20PC = "" # initializing
    try:
        print("\n\n>>>> GENSIM SUMMARY (100 words)\n")
        GENSIM_ARTICLE_SUMMARY_100_TMP = summarize(article.text, word_count=100)
        GENSIM_ARTICLE_SUMMARY_100 = GENSIM_ARTICLE_SUMMARY_100_TMP.replace('\n', '<br><br>')
        print(GENSIM_ARTICLE_SUMMARY_100)

        print("\n\n>>>> GENSIM SUMMARY (20% of original article length)\n")
        GENSIM_ARTICLE_SUMMARY_20PC_TMP = summarize(article.text, ratio=0.2) # show 20% of the original text
        GENSIM_ARTICLE_SUMMARY_20PC = GENSIM_ARTICLE_SUMMARY_20PC_TMP.replace('\n', '<br><br>')
        print("\n\n",GENSIM_ARTICLE_SUMMARY_20PC)
    except:
        print("**** PRINT WARNING = Gensim summary can not be extracted. Maybe because the page content is only one sentence long. ****")

    print("\n\n>>>> GENSIM KEYWORDS = ALL \n")
    GENSIM_KEYWORDS_ALL_TMP = keywords(article.text,split=False)
    GENSIM_KEYWORDS_ALL = GENSIM_KEYWORDS_ALL_TMP.replace('\n', '<br>')
    print(GENSIM_KEYWORDS_ALL)

    ## INITIAL IDEA BELOW WAS TO TAKE 25 KEYWORDS, BUT IT DOES NOT KEEP WELL WITH
    #### THE CASE WHEN THERE ARE LESS THAN 25 KEYWORDS IN TOTAL. SO NOW, WE WILL
    #### CONSIDER ALL KEYWORDS
    print("\n\n>>>> GENSIM KEYWORDS = Top Keywords with scores \n")
    GENSIM_KEYWORDS_TOP25_WITH_SCORES_TMP = keywords(article.text,split=False,scores=True)
    ## WORKING WITH THIS GENSIM KEYWORDS TUPLE (BREAKING IT DOWN LINE BY LINE)
    GENSIM_TOP_KEYWORD_ARRAY=[]
    for gkword in GENSIM_KEYWORDS_TOP25_WITH_SCORES_TMP:
        print(gkword)
        GENSIM_string_kw = str(gkword[0]) + ' // ' + str( round(gkword[1],3) )
        GENSIM_TOP_KEYWORD_ARRAY.append(GENSIM_string_kw)
    ## CONVERTING THIS ARRAY TO A STRING OF WORDS FOR HTML OUTPUT
    GENSIM_KEYWORDS_TOP25_WITH_SCORES = str('<br>'.join(GENSIM_TOP_KEYWORD_ARRAY))

    ################################################################################
    ## END: KEYWORDS EXTRACTION USING GENSIM (PYTHON PACKAGE)
    ################################################################################

    ################################################################################
    ## BEGIN: COLLECTING ALL VARIABLES AND WRITING TO OUTPUT HTML FILE
    ################################################################################
    colored_bullet_chars = '<hr style="height: 5px; background-color: ' + row_color + '">';

    f.write('<tr>')
    f.write('<th scope="row"><h2>'+ str(URL_COUNT) +'</h2></th>')
    f.write('<td>'+colored_bullet_chars+'<a target="_blank" href="'+ url +'">' + url + '</a></td>')
    f.write('<td>'+colored_bullet_chars+ NLP_ARTICLE_TOP_IMAGE +'</td>')
    f.write('<td>'+colored_bullet_chars+ META_GENERATOR +'</td>')
    f.write('<td>'+colored_bullet_chars+ TITLE_TAG_VALUE +'</td>')
    f.write('<td>'+colored_bullet_chars+ META_DESCRIPTION +'</td>')
    f.write('<td>'+colored_bullet_chars+ str(NLP_ARTICLE_ANY_VIDEO) +'</td>')
    f.write('<td>'+colored_bullet_chars+ TOP20_WORDS_STRING_HTML + '</td>')
    f.write('<td>'+colored_bullet_chars+ str(BSOUP_NUMWORDS) + '</td>')
    f.write('<td>'+colored_bullet_chars+'<h2>'+ str(NLP_NUMWORDS) +' words</h2></td>')
    f.write('<td>'+colored_bullet_chars+'<h2>'+ str(NLP_READINGTIME_212WPM) +' minutes</h2></td>')
    f.write('<td>'+colored_bullet_chars+ str(NLP_ARTICLE_AUTHORS) +'</td>')
    f.write('<td>'+colored_bullet_chars+ str(BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY) +'</td>')
    f.write('<td>'+colored_bullet_chars+ str(NLP_ARTICLE_PUBLISH_DATE) +'</td>')
    f.write('<td>'+colored_bullet_chars+'<span style="color:blue">'+ NLP_ARTICLE_SUMMARY +'</span></td>')
    f.write('<td>'+colored_bullet_chars+ GENSIM_ARTICLE_SUMMARY_100 +'</td>')
    f.write('<td>'+colored_bullet_chars+'<span style="color:blue">'+ GENSIM_ARTICLE_SUMMARY_20PC +'</span></td>')
    f.write('<td>'+colored_bullet_chars+ NLP_TOP_KEYWORDS +'</td>')
    f.write('<td>'+colored_bullet_chars+'<span style="color:blue">'+ GENSIM_KEYWORDS_ALL +'</span></td>')
    f.write('<td>'+colored_bullet_chars+ RAKE_TOP_KEYWORD_PHRASES +'</td>')
    f.write('<td>'+colored_bullet_chars+ GENSIM_KEYWORDS_TOP25_WITH_SCORES +'</td>')
    f.write('<td>'+colored_bullet_chars+ FULL_HEADINGS_ARRAY_FINAL +'</td>')
    f.write('<td>'+colored_bullet_chars+ ALL_HYPERLINKS_ARRAY +'</td>')
    f.write('<td>'+colored_bullet_chars+ ALL_IMAGES_ARRAY +'</td>')
    f.write('</tr>')

    ############################################################################
    ## APPENDING data for charting and plotting to CSV files
    ############################################################################
    import csv
    ## OUTPUT CSV FILE 1
    with open(OUTPUT_CSV_FILE, 'a', newline='') as csvfile1:
        fieldnames1 = ['URL_NUM',
        'URL_NAME',
        'NLP_READING_TIME_IN_MINS_212WPM',
        'BSOUP_NUMWORDS',
        'NLP_NUMWORDS',
        'META_YEARS_SINCE_FIRST_PUBLISHED',
        'META_YEARS_SINCE_LAST_MODIFIED',
        'NLP_FIRST_PUBLISHED_DATETIME',
        'META_FIRST_PUBLISHED_DATE',
        'META_LAST_MODIFIED_DATETIME',
        'NLP_KEYWORDS']

        writer = csv.DictWriter(csvfile1, fieldnames=fieldnames1)

        writer.writerow({'URL_NUM':'url'+str(URL_COUNT) ,
        'URL_NAME':str(url),
        'NLP_READING_TIME_IN_MINS_212WPM':str(NLP_READINGTIME_212WPM) ,
        'BSOUP_NUMWORDS':str(BSOUP_NUMWORDS) ,
        'NLP_NUMWORDS':str(NLP_NUMWORDS) ,
        'META_YEARS_SINCE_FIRST_PUBLISHED':str(YEARS_SINCE_FIRST_PUBLISHED) ,
        'META_YEARS_SINCE_LAST_MODIFIED':str(YEARS_SINCE_LAST_MODIFIED) ,
        'NLP_FIRST_PUBLISHED_DATETIME':str(NLP_ARTICLE_PUBLISH_DATE),
        'META_FIRST_PUBLISHED_DATE':str(META_PUBLISHED_DATETIME),
        'META_LAST_MODIFIED_DATETIME':str(META_MODIFIED_DATETIME),
        'NLP_KEYWORDS':NLP_TOP_KEYWORDS_FOR_CSV })

################################################################################
################################################################################

################################################################################
## END: ALL FUNCTION DEFINITIONS
################################################################################



################################################################################
################################################################################
## OPEN HTML OUTPUT FILE FOR WRITING the first line. AFter that, the file will be appended using 'a' flag.
f = open(OUTPUT_HTML_FILE,'w')
f.write(BOOTSTRAP4_HTML_HEADER)
#f.write('<html><head>' )
#f.write('<style>td {vertical-align: baseline; font-family: sans-serif; padding: 5px; }</style>' )
#f.write('</head><body>')
f.write('Created on: '+ TIME_NOW)
f.write('<h1>Keyword Analysis using NLP (Natural Language Processing)</h1>')
f.write('<h2>Output for MGGK using Google Search Top URLs</h2>')


###### WRITING COLOR KEY BLOCK TO HTML PAGE ####
color_age_dict = {"Post is less than 3 monts old [Latest]":"deeppink" ,"0.250 < Post age in years <= 1":"red" , "1 < Post age in years <= 2.5":"orange", "2.5 < Post age in years <= 4":"yellow", "4 < Post age in years <= 6":"skyBlue", "Post age in years > 6 [Oldest]":"blue"  }

f.write('<div class="container-fluid"><div class="row">')

for c_key in color_age_dict:
    c_value = color_age_dict[c_key]
    f.write('<div class="col-2" style="color: white; background: ' + c_value + ' ;"> ' + c_key + '</div>')

f.write('</div></div><hr>')
f.close()

## APPENDING THE HTML FILE BEGINS
#### Make sure to use the column header names to have underscores so that they
#### are long enough to have a good enough column width. Else, the default bootstrap4
#### column widths are very narrow.
####
f = open(OUTPUT_HTML_FILE,'a')
f.write('<table class="table table-striped table-bordered">')
f.write('<thead class="thead-dark"><tr>')
f.write('<th scope="col">URL COUNT</th>')
f.write('<th scope="col">URL LINK</th>')
f.write('<th scope="col">NLP ARTICLE TOP IMAGE</th>')
f.write('<th scope="col">BSOUP_META_GENERATOR</th>')
f.write('<th scope="col">BSOUP_TITLE_TAG_VALUE</th>')
f.write('<th scope="col">BSOUP_META_DESCRIPTION</th>')
f.write('<th scope="col">NLP ARTICLE VIDEOS FOUND</th>')
f.write('<th scope="col">TOP_20_WORDS<br>(num appearances, word)</th>')
f.write('<th scope="col">BSOUP NUMWORDS</th>')
f.write('<th scope="col">NLP NUMWORDS</th>')
f.write('<th scope="col">NLP READINGTIME AT 212 WPM</th>')
f.write('<th scope="col">NLP ARTICLE AUTHORS</th>')
f.write('<th scope="col">BSOUP_ALL_DATE_TIMES_FROM_WEBPAGE_ARRAY</th>')
f.write('<th scope="col">NLP_ARTICLE_PUBLISH_DATE</th>')
f.write('<th scope="col">NLP_ARTICLE_SUMMARY</th>')
f.write('<th scope="col">GENSIM ARTICLE_SUMMARY_100_WORDS</th>')
f.write('<th scope="col">GENSIM ARTICLE_SUMMARY_20_PERCENT_OF_ARTICLE_LENGTH</th>')
f.write('<th scope="col">NLP_TOP_KEYWORDS</th>')
f.write('<th scope="col">GENSIM_KEYWORDS_ALL</th>')
f.write('<th scope="col">RAKE_TOP_KEYWORD_PHRASES</th>')
f.write('<th scope="col">GENSIM ALL_KEYWORDS_WITH_SCORES</th>')
f.write('<th scope="col">BSOUP ALL_HEADINGS_IN_WHOLE_WEBPAGE</th>')
f.write('<th scope="col">BSOUP FOUND_HYPERLINKS_IN_ARTICLE_BLOCK</th>')
f.write('<th scope="col">BSOUP ALL_IMAGES_ARRAY</th>')
f.write('</tr></thead><tbody>')

## INITIALIZING THE CSV FILES FOR WRITING, AND WRITING THE HEADER ROW
#### OUTPUT CSV FILE 1
with open(OUTPUT_CSV_FILE, 'w', newline='') as csvfile1:
    fieldnames1 = ['URL_NUM',
    'URL_NAME',
    'NLP_READING_TIME_IN_MINS_212WPM',
    'BSOUP_NUMWORDS',
    'NLP_NUMWORDS',
    'META_YEARS_SINCE_FIRST_PUBLISHED',
    'META_YEARS_SINCE_LAST_MODIFIED',
    'NLP_FIRST_PUBLISHED_DATETIME',
    'META_FIRST_PUBLISHED_DATE',
    'META_LAST_MODIFIED_DATETIME',
    'NLP_KEYWORDS']

    writer = csv.DictWriter(csvfile1, fieldnames=fieldnames1)

    writer.writerow({ 'URL_NUM':'URL_NUM' ,
    'URL_NAME':'URL_NAME',
    'NLP_READING_TIME_IN_MINS_212WPM':'NLP_READING_TIME_IN_MINS_212WPM',
    'BSOUP_NUMWORDS':'BSOUP_NUMWORDS' ,
    'NLP_NUMWORDS':'NLP_NUMWORDS',
    'META_YEARS_SINCE_FIRST_PUBLISHED':'META_YEARS_SINCE_FIRST_PUBLISHED' ,
    'META_YEARS_SINCE_LAST_MODIFIED':'META_YEARS_SINCE_LAST_MODIFIED' ,
    'NLP_FIRST_PUBLISHED_DATETIME':'NLP_FIRST_PUBLISHED_DATETIME',
    'META_FIRST_PUBLISHED_DATE':'META_FIRST_PUBLISHED_DATE',
    'META_LAST_MODIFIED_DATETIME':'META_LAST_MODIFIED_DATETIME',
    'NLP_KEYWORDS':'NLP_KEYWORDS' })

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
        mggk_find_ai_details_from_url_lines(url = line, URL_COUNT = MY_URL_COUNT)

## FINAL HTML OUTPUT OPERATIONS
f.write('</tbody></table>')
f.write(BOOTSTRAP4_HTML_FOOTER)
f.close()
################################################################################
################################################################################
