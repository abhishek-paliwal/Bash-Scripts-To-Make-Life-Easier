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
