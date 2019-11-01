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
## DEFINING SOME VARIABLES
################################################################################
from os.path import expanduser
home = expanduser("~")
dirpath = '/GitHub/Bash-Scripts-To-Make-Life-Easier/mggk_bash_scripts/600-mggk-artificial-intelligence-nlp-programs/601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls'
rake_stop_dir = home + dirpath + '/601-MGGK-PYTHON-RAKE-SmartStoplist.txt'
NLP_URLS_TEXT_FILE = home + '/Desktop/Y/601-MGGK-REQUIREMENT-ALL-URLS-FOR-NLP.txt'
OUTPUT_HTML_FILE = home + '/Desktop/Y/_TMP_601_MGGK_AI_NLP_HTML_OUTPUT.HTML'

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
  <div class='container'><!-- BEGIN: main containter div -->"""

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
## BEGIN: FUNCTION DEFINITIONS
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
        #print(article.html)
        #print(article.text)
        #print(">>>> ARTICLE FULL TEXT [via NLP] = ", article.text)
    except:
        print('***** NLP ERROR: FAILED TO DOWNLOAD *****', article.url)
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

    FULL_HEADINGS_ARRAY.append("<h2>H2 headings</h2>")
    for h2 in h2_array:
        print(h2)
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h2.get_text())

    FULL_HEADINGS_ARRAY.append("<h2>H3 headings</h3>")
    for h3 in h3_array:
        print(h3)
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h3.get_text())

    FULL_HEADINGS_ARRAY.append("<h4>H4 headings</h4>")
    for h4 in h4_array:
        print(h4)
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h4.get_text())

    FULL_HEADINGS_ARRAY.append("<h5>H5 headings</h5>")
    for h5 in h5_array:
        print(h5)
        FULL_HEADINGS_ARRAY.append("<br>&bull; " + h5.get_text())

    FULL_HEADINGS_ARRAY.append("<h6>H6 headings</h6>")
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
            print(hlink_href)
            ALL_HYPERLINKS_ARRAY_TMP.append('&bull; '+str(hlink_href))

    ALL_HYPERLINKS_ARRAY_TMP = sorted(ALL_HYPERLINKS_ARRAY_TMP) ## sorting the list
    ALL_HYPERLINKS_ARRAY = '<br>'.join(str(v) for v in ALL_HYPERLINKS_ARRAY_TMP)

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
    article.nlp()
    print("\n>>>> [NLP] TOP KEYWORDS = ", article.keywords)
    print()
    print(">>>> [NLP] ARTICLE SUMMARY =\n\n", article.summary)

    NLP_ARTICLE_AUTHORS = article.authors
    NLP_ARTICLE_PUBLISH_DATE = article.publish_date
    NLP_ARTICLE_TOP_IMAGE = article.top_image +'<br><br><img width="300px" src="'+ article.top_image+'"></img>'
    NLP_ARTICLE_ANY_VIDEO = article.movies
    NLP_TOP_KEYWORDS = str('<br>'.join(article.keywords))
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

    print("\n\n>>>> GENSIM SUMMARY (100 words)\n")
    GENSIM_ARTICLE_SUMMARY_100_TMP = summarize(article.text, word_count=100)
    GENSIM_ARTICLE_SUMMARY_100 = GENSIM_ARTICLE_SUMMARY_100_TMP.replace('\n', '<br><br>')
    print(GENSIM_ARTICLE_SUMMARY_100)

    print("\n\n>>>> GENSIM SUMMARY (20% of original article length)\n")
    GENSIM_ARTICLE_SUMMARY_20PC_TMP = summarize(article.text, ratio=0.2) # show 20% of the original text
    GENSIM_ARTICLE_SUMMARY_20PC = GENSIM_ARTICLE_SUMMARY_20PC_TMP.replace('\n', '<br><br>')
    print("\n\n",GENSIM_ARTICLE_SUMMARY_20PC)

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
    f.write('<tr>')
    f.write('<td><h2>'+ str(URL_COUNT) +'</h2></td>')
    f.write('<td><a href="'+ url +'">' + url + '</a></td>')
    f.write('<td>'+ NLP_ARTICLE_TOP_IMAGE +'</td>')
    f.write('<td>'+ META_DESCRIPTION +'</td>')
    f.write('<td>'+ str(NLP_ARTICLE_ANY_VIDEO) +'</td>')
    f.write('<td>' + TOP20_WORDS_STRING_HTML + '</td>')
    f.write('<td>'+ str(BSOUP_NUMWORDS) + '</td>')
    f.write('<td><h2>'+ str(NLP_NUMWORDS) +' words</h2></td>')
    f.write('<td><h2>'+ str(NLP_READINGTIME_212WPM) +' minutes</h2></td>')
    f.write('<td>'+ str(NLP_ARTICLE_AUTHORS) +'</td>')
    f.write('<td>'+ str(NLP_ARTICLE_PUBLISH_DATE) +'</td>')
    f.write('<td>'+ NLP_ARTICLE_SUMMARY +'</td>')
    f.write('<td>'+ GENSIM_ARTICLE_SUMMARY_100 +'</td>')
    f.write('<td><span style="color:blue">'+ GENSIM_ARTICLE_SUMMARY_20PC +'</span></td>')
    f.write('<td>'+ NLP_TOP_KEYWORDS +'</td>')
    f.write('<td><span style="color:blue">'+ GENSIM_KEYWORDS_ALL +'</span></td>')
    f.write('<td>'+ RAKE_TOP_KEYWORD_PHRASES +'</td>')
    f.write('<td>'+ GENSIM_KEYWORDS_TOP25_WITH_SCORES +'</td>')
    f.write('<td>'+ FULL_HEADINGS_ARRAY_FINAL +'</td>')
    f.write('<td>'+ ALL_HYPERLINKS_ARRAY +'</td>')
    f.write('</tr>')

################################################################################
## END: FUNCTION DEFINITIONS
################################################################################

################################################################################
################################################################################
## OPEN HTML OUTPUT FILE FOR WRITING the first line. AFter that, the file will be appended using 'a' flag.
f = open(OUTPUT_HTML_FILE,'w')
f.write(BOOTSTRAP4_HTML_HEADER)
#f.write('<html><head>' )
#f.write('<style>td {vertical-align: baseline; font-family: sans-serif; padding: 5px; }</style>' )
#f.write('</head><body>')
f.write('Created: '+ TIME_NOW)
f.write('<h1>Keyword Analysis using NLP (Natural Language Processing)</h1>')
f.write('<h2>Output for MGGK using Google Search Top URLs</h2>')
f.close()
## APPENDING THE HTML FILE BEGINS
f = open(OUTPUT_HTML_FILE,'a')
f.write('<table class="table-striped table-bordered">')
f.write('<thead class="thead-dark"><tr>')
f.write('<th scope="col">URL COUNT</th>')
f.write('<th scope="col">URL LINK</th>')
f.write('<th scope="col">NLP ARTICLE TOP IMAGE</th>')
f.write('<th scope="col">BSOUP META DESCRIPTION</th>')
f.write('<th scope="col">NLP ARTICLE FOUND VIDEOS</th>')
f.write('<th scope="col">TOP 20 WORDS<br>(num appearances, word)</th>')
f.write('<th scope="col">BSOUP NUMWORDS</th>')
f.write('<th scope="col">NLP NUMWORDS</th>')
f.write('<th scope="col">NLP READINGTIME AT 212 WPM</th>')
f.write('<th scope="col">NLP ARTICLE AUTHORS</th>')
f.write('<th scope="col">NLP ARTICLE PUBLISH DATE</th>')
f.write('<th scope="col">NLP ARTICLE SUMMARY</th>')
f.write('<th scope="col">GENSIM ARTICLE SUMMARY 100 WORDS</th>')
f.write('<th scope="col">GENSIM ARTICLE SUMMARY 20 PERCENT OF ARTICLE LENGTH</th>')
f.write('<th scope="col">NLP TOP KEYWORDS</th>')
f.write('<th scope="col">GENSIM KEYWORDS ALL</th>')
f.write('<th scope="col">RAKE TOP KEYWORD PHRASES</th>')
f.write('<th scope="col">GENSIM KEYWORDS TOP25 WITH SCORES</th>')
f.write('<th scope="col">BSOUP ALL HEADINGS IN WHOLE WEBPAGE</th>')
f.write('<th scope="col">BSOUP FOUND HYPERLINKS IN ARTICLE BLOCK</th>')
f.write('</tr></thead>')

## Calling the above function on each url line from url links text FILE
myfile = open(NLP_URLS_TEXT_FILE, "r")
MY_URL_COUNT=0
for line in myfile:
    MY_URL_COUNT = MY_URL_COUNT+1
    print("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    print(">>>> CURRENT URL READING: ",line)
    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
    line=line.strip() ## removes all unnecessary character in line (leading and trailing)
    mggk_find_ai_details_from_url_lines(url = line, URL_COUNT = MY_URL_COUNT)

## FINAL HTML OUTPUT OPERATIONS
f.write('</table>')
f.write(BOOTSTRAP4_HTML_FOOTER)
#f.write('</body></html>')
f.close()
################################################################################
################################################################################
