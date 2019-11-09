**Created on:** Saturday November 9, 2019

--------------------------------------------

# STEPS + TUTORIAL ABOUT HOW TO RUN SCRIPTS IN THIS 601-MGGK-... FOLDER:

---------------

### A.) WHEN RUNNING FOR INDIVIDUAL WEBSITE URLS FOR KEYWORD ANALYSIS FOR VARIOUS GOOGLE SERP POSITIONS

1. Go to $HOME/Desktop/Y/ directory.
2. Make sure that there's a plain text file present, named as: 601-MGGK-REQUIREMENT-ALL-URLS-FOR-NLP.txt, containing a simple list of all the urls you want to analyse the keywords for, one url per line.
3. Finally, simply run this on command prompt => `python3 601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls.py`

---------------

### B.) WHEN RUNNING FOR WHOLE WEBSITES URLS USING THEIR SITEMAPS (WHEN SUBFOLDERS ARE PRESENT, SUCH AS XX-SITENAME-COM)

1. Create a sub directory in Present working directory, naming it as XX-SITENAME-COM
2. Then place the 9999_Tempory_sitemap extractor python script in that directory
3. Finally, open that python script in text editor, and replace the relevant site specific 'sitemaps' variable in that extractor script at appropriate place.
4. Go to the parent directory, and run this on command prompt => `bash 601-step1-run-this-bash-script-if-website-subfolders-are-present-for-AI-NLP-mggk.sh`
5. That's it. Done. Add as many website as you like to scout the details for.

-----------------

### Current subfolder structure of this directory:
```
.
├── 601-01-CONCEPRO-COM
│   └── 9999_mggk_TEMPLATE_SCRIPT-get_all_urls_from_ALL_sitemap_urls.py
├── 601-02-COOKWITHMANALI-COM
│   └── 9999_mggk_TEMPLATE_SCRIPT-get_all_urls_from_ALL_sitemap_urls.py
├── 601-03-MYGINGERGARLICKITCHEN-COM
│   └── 9999_mggk_TEMPLATE_SCRIPT-get_all_urls_from_ALL_sitemap_urls.py
├── 601-04-VEGRECIPESOFINDIA-COM
│   └── 9999_mggk_TEMPLATE_SCRIPT-get_all_urls_from_ALL_sitemap_urls.py
├── 601-05-WP-MYGINGERGARLICKITCHEN-COM
│   └── 9999_mggk_TEMPLATE_SCRIPT-get_all_urls_from_ALL_sitemap_urls.py
├── 601-MGGK-PYTHON-RAKE-SmartStoplist.txt
├── 601-MGGK-REQUIREMENT-ALL-URLS-FOR-NLP.txt
├── 601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls.py
├── 601-step1-run-this-bash-script-if-website-subfolders-are-present-for-AI-NLP-mggk.sh
└── __README_FIRST.md
```

-------------------
