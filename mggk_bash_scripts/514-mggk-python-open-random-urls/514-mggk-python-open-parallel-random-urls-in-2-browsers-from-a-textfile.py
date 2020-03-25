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
    ## THIS PYTHON SCRIPT OPENS PARALLEL RANDOM URLS FOR MGGK AND WP.MGGK.COM WEBSITES
    ## IN TWO DIFFERENT BROSWER WINDOWS.
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

##################################################################################
##################################################################################
import os ;
import time ;
from random import randint ;

with open('514-mggk-urls.txt') as f:
    content = f.readlines()
# you may also want to remove whitespace characters like `\n` at the end of each line
content = [x.strip() for x in content]



prefix1= 'https://www.mygingergarlickitchen.com'
prefix2= 'https://www.wp.mygingergarlickitchen.com'

for x in range(10):
    line_num = randint(1,178)
    my_command1 = 'open ' + prefix1 + content[line_num]
    my_command2 = 'open -a Safari ' + prefix2 + content[line_num]
    os.system(my_command1)
    os.system(my_command2)
    time.sleep(2)
