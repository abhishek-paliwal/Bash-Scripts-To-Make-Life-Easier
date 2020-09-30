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
    ## THIS PYTHON SCRIPT PARSES AN EXTERNAL WORD LIST FILE PRESENT IN CWD (=wordlist.txt).
    ## EACH WORD IS PRESENT IN ITS OWN LINE. MEANING ONE WORD PER LINE.
    ## IT THEN READS EACH LINE AND HIGHLIGHTS THE VOWELS.
    ## THEN FINALLY OUTPUTS AN HTML FILE IN CWD WITH THESE HIGHTLIGHED VOWELS.
    #######################################
    ## MADE ON: SEP 30 2020
    ## BY: PALI
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

## Which words file and output file to use
input_words_file = "wordlist.txt" ;
output_html_file = '_tmp_output_001_littleA_vowels_highlighted.html'
####
vowels = ['a','e','i','o','u']
####

## MAKING A BOOTSTRAP 4 HTML FILE
f = open(output_html_file, "w")
f.write('''
        <!doctype html>
        <html lang="en">
        <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
            integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

        <title>MY WORD LIST</title>
    </head>
    <body>
    <div class="row" style="font-size: 60px; font-weight: 700;">
\n''') ;

################################
with open(input_words_file) as wf:
    for line in wf:
        f.write('<div class="col-sm-6 col-md-4 col-lg-3" >\n')
        ##----------------------------------------------
        if line != "" :
            print('>> READING CURRENT LINE: ' + line )
            word = line.strip() ;
            word = word.lower() ;

            CharInWord = list(word) ;
            #print(CharInWord)

            ## CREATING AN EMPTY LIST TO STORE THE NEWLY CREATED HIGHTLIGHED CHARACTERS
            newWord = [];
            for char in CharInWord:
                if char in vowels:
                    newChar = '<span style="color: #00FF00;">' + char + '</span>' ;
                else:
                    newChar = char ; ## NO CHANGE, KEEP THE OLD CHARACTER AS SUCH.
                ##    
                ## APPEND TO THE LIST
                newWord = newWord + list(newChar) ; 
            ####
            #print(newWord)
            for element in newWord:
               f.write(element)
        ##----------------------------------------------
        f.write('\n</div>\n')
############################
f.write('''\n
    </div>
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
            integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"
            crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"
            integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q"
            crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"
            integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl"
            crossorigin="anonymous"></script>
    </body>
    </html>
''')

f.close()

############################
## PRINTING SUMMARY
print('##################################################################################')
print('>> SUMMARY:')
print('##################################################################################')
print('>> INPUT WORDS LIST FILE: ' + input_words_file )
print('>> OUTPUT HTML FILE CREATED: ' + output_html_file )

