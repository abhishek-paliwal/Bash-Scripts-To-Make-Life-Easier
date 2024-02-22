###################################################################################
## THIS PROGRAM PARSES THE VISIBLE PART OF ANY WEBPAGE GIVEN AS A CLI ARGUMENT
## DATE: 2024-02-22
## BY: PALI
###################################################################################

import requests
from bs4 import BeautifulSoup
from bs4.element import Comment
import sys  # Import sys module

# Function to check if an element is visible
def tag_visible(element):
    if element.parent.name in ['style', 'script', 'head', 'title', 'meta', '[document]']:
        return False
    if isinstance(element, Comment):
        return False
    return True

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
}

# Function to fetch and parse a webpage, then print visible text
def text_from_html(url):
    #response = requests.get(url)
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.content, 'html.parser')
    texts = soup.find_all(string=True)
    visible_texts = filter(tag_visible, texts)  
    return u"\n".join(t.strip() for t in visible_texts if t.strip())

# Check if a URL is provided as a command-line argument
if len(sys.argv) > 1:
    url = sys.argv[1]  # Read the URL from the first command-line argument
    # Fetch and print visible text from the webpage
    visible_text = text_from_html(url)
    print(visible_text)
else:
    print("Please provide a URL as a command-line argument.")
