# date: 2023-12-09
# usage: /path/to/this/program.py markdown_file_path
##############################################################
import frontmatter
import sys
import os

myfile = sys.argv[1]

with open(myfile, 'r') as f:
    post = frontmatter.load(f)

frontmatter = post.metadata
content = post.content
## printing
print('\n\n##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n') ; 

##############################################################
## print all outputs to cli
def print_all(content,frontmatter):
    print('\n>> FRONTMATTER ...\n') ; 
    for key, value in frontmatter.items():
        print_keyvalue = str(key) + ' = ' + str(value) ;  
        print(print_keyvalue)
    ##
    print('\n>> CONTENT ...\n') ; 
    print(content) ;
##############################################################
## writing content and frontmatter output files
def write_all_outputs(content,frontmatter):
    outdirY = os.environ.get('HOME_WINDOWS') + '/Desktop/Y/_tmp_00231_frontmatter_python_output/' ;
    if not os.path.exists(outdirY):
        os.makedirs(outdirY)
    ##
    myfile_basename = os.path.basename(myfile)
    output_frontmatter = outdirY + myfile_basename + '-FRONTMATTER_MD.txt' ; 
    output_content = outdirY + myfile_basename + '-CONTENT_MD.txt' ; 
    ## write content
    with open(output_content, 'w') as f:
        f.write(content)
    ## write frontmatter
    with open(output_frontmatter, 'w') as f:
        for key, value in frontmatter.items():
            print_keyvalue = str(key) + ' = ' + str(value) ;  
            f.write(print_keyvalue + '\n')
##############################################################

print_all(content,frontmatter) ; 
write_all_outputs(content,frontmatter) ;