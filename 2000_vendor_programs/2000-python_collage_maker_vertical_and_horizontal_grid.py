##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USAGE FOR PYTHON
## Print this help as >> this_script_name --help
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
import sys
####
def usage():
    print('## USAGE: ' + sys.argv[0])
    HELP_TEXT = """
    ################################################################################
    ## THIS SCRIPT MAKES COLLAGES WITH VARIOUS NUMBER OF IMAGES PER ROW.
    ## IT ALSO CREATES VERTICAL AND HORIZONTAL COLLAGES FROM ALL IMAGES FROM SUBDIRECTORIES.
    #### NOTE: THIS SCRIPT SHOULD BE RUN FROM A DIRECTORY WHERE MANY FOLDERS ARE PRESENT, EACH
    #### CONTAINING SOME IMAGES.
    ################################################################################
    ## USAGE: python3 THIS_SCRIPT_NAME ARG1 ARG2 
    #### (where, ARG1 = images_input_directory // ARG2 = collage_output_directory)
    ################################################################################
    ## MADE BY: PALI
    ## MADE ON: Thursday June 02, 2021
    ################################################################################
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

from PIL import Image
import os

## GETTING VARIABLES FROM CLI ARGUMENTS
DIR_INPUT = sys.argv[1]
DIR_INPUT_BASENAME = os.path.basename(DIR_INPUT)
DIR_OUTPUT = sys.argv[2]
print('>> CURRENT INPUT DIRECTORY => ' + str(DIR_INPUT))
print('>> CURRENT OUTPUT DIRECTORY => ' + str(DIR_OUTPUT))

## LISTING ALL IMAGES
#all_images = os.listdir(DIR_INPUT) ;
all_images = [file for file in os.listdir(DIR_INPUT) if file.endswith(('jpeg', 'png', 'jpg'))]
all_images.sort() ## sorting the list (this is very important step for collage)

## CREATING PIL IMAGE OBJECTS OF ALL IMAGES FOUND
all_images_as_pil_objects = [Image.open(DIR_INPUT + '/' + x) for x in all_images]
##

## ASSIGN THE LIST OF IMAGES TO USE IN MAKING THE FINAL COLLAGE
list_length = len(all_images_as_pil_objects)
max_images_in_single_row = 2  # change this number if desired
total_rows = list_length // max_images_in_single_row
image_padding = 5

##################################################################################
## FUNCTION DEFINITIONS
##################################################################################
## FUNCTION TO PRINT ELEMENTS OF A LIST LINE BY LINE
def PRINT_LIST_ELEMENTS_LINE_BY_LINE(my_list, list_desc):
    print()
    print('     >> PRINTING ALL ELEMENTS IN LIST => ' + list_desc)
    i=1
    for z in my_list:
        print('Element ' + str(i) + ' => ' + str(z) )
        i=i+1

## CREATING A LIST OF LISTS BY DIVIDING A GIVEN LIST INTO DESIRED NUMBER OF PARTS
def split_list(alist, wanted_parts=1):
    length = len(alist) + 1
    return [alist[i*length // wanted_parts: (i+1)*length // wanted_parts]
            for i in range(wanted_parts)]

## JOINING IMAGES HORIZONTALLY
def get_concat_h_multi_resize(im_list, resample=Image.BICUBIC):
    min_height = min(im.height for im in im_list)
    im_list_resize = [im.resize((int(im.width * min_height / im.height), min_height), resample=resample)
                      for im in im_list]
    total_width = sum(im.width for im in im_list_resize)
    dst = Image.new('RGB', (total_width, min_height), (255, 255, 255) )
    pos_x = 0
    for im in im_list_resize:
        dst.paste(im, (pos_x, 0))
        pos_x += im.width + (image_padding*2)
    return dst

## JOINING IMAGES VERTICALLY
def get_concat_v_multi_resize(im_list, resample=Image.BICUBIC):
    min_width = min(im.width for im in im_list)
    im_list_resize = [im.resize((min_width, int(im.height * min_width / im.width)), resample=resample)
                      for im in im_list]
    total_height = sum(im.height for im in im_list_resize)
    dst = Image.new('RGB', (min_width, total_height), (255, 255, 255) )
    pos_y = 0
    for im in im_list_resize:
        dst.paste(im, (0, pos_y))
        pos_y += im.height + image_padding
    return dst

## JOINING HORIZONTAL AND VERTICAL COLLAGES IN ROWS
def get_concat_tile_resize(im_list_2d, name_suffix, resample=Image.BICUBIC):
    im_list_v = [get_concat_h_multi_resize(
        im_list_h, resample=resample) for im_list_h in im_list_2d]
    #return get_concat_v_multi_resize(im_list_v, resample=resample)
    dst = get_concat_v_multi_resize(im_list_v, resample=resample)
    final_image_name = 'grid-collage-for-DIR-' + DIR_INPUT_BASENAME + name_suffix + '.jpg'
    print('>> Making final even and odd rows collage => ' + final_image_name)
    dst.save(DIR_OUTPUT + '/' + final_image_name)

## SPLIT THE LIST DIFFERENTLY DEPENDING UPON EVEN AND ODD NUMBER OF IMAGES
#### For eg, if => max_images_in_single_row = 2, then:
#### // if total images = even = 8, split rows will be [2,2,2,2]
#### // if total images = odd =  7, split rows will be [2,2,2,1], etc.
####
def CREATE_2D_IMAGES_LIST(max_images_per_row):
    max_images_in_single_row = max_images_per_row
    total_rows = list_length // max_images_in_single_row
    ##
    print()
    if list_length % max_images_in_single_row == 0:
        print('>>>> List Length = EVEN Number = ' + str(list_length))
        final_2d_list = split_list(
            all_images_as_pil_objects, wanted_parts=total_rows)
    else:
        print('>>>> List Length = ODD Number = ' + str(list_length))
        final_2d_list = split_list(
            all_images_as_pil_objects, wanted_parts=total_rows+1)
    return final_2d_list
##################################################################################
##################################################################################

##################
PRINT_LIST_ELEMENTS_LINE_BY_LINE(all_images, list_desc='All images in chosen directory ...')
#PRINT_LIST_ELEMENTS_LINE_BY_LINE(all_images_as_pil_objects, list_desc='All PIL image objects ...')
##################

#========================================
## CALLING THE MAIN COLLAGE MAKING FUNCTION VIA ANOTHER FUNCTION
#========================================
#############
def MAKE_COLLAGE_WITH_CHOSEN_NUMBER_OF_IMAGES_PER_ROW(max_images_per_row):
    print(); 
    final_2d_list = CREATE_2D_IMAGES_LIST(max_images_per_row)
    ##
    PRINT_LIST_ELEMENTS_LINE_BY_LINE(final_2d_list, list_desc='All rows in 2D LIST of images ...')
    ##
    if ( list_length == 1 and max_images_per_row == 1 ) :
        get_concat_tile_resize(final_2d_list, name_suffix='-' + str(max_images_per_row) + 'x-images-per-row')
    elif ( list_length == 2 and max_images_per_row == 1 ) :
        get_concat_tile_resize(final_2d_list, name_suffix='-' + str(max_images_per_row) + 'x-images-per-row')
    elif ( list_length >= 3 and max_images_per_row == 2 ) :
        get_concat_tile_resize(final_2d_list, name_suffix='-' + str(max_images_per_row) + 'x-images-per-row')
    else:
        get_concat_tile_resize(final_2d_list, name_suffix='-' + str(max_images_per_row) + 'x-images-per-row-NOT2TAKE')    
#############


## Make these collage with desired rows (add more numbers as desired in the following list)
#### Eg.; 1 = single row collage, list_length = single column collage
#### If there are more than 6 images, then we will only make collages till 7-images per row.
list_length_max = 7 ;
if list_length > list_length_max:
    max_images_per_row_list = range(1, list_length_max+1)
else:
    max_images_per_row_list = range(1,list_length+1)
####
for x in max_images_per_row_list:
    MAKE_COLLAGE_WITH_CHOSEN_NUMBER_OF_IMAGES_PER_ROW(max_images_per_row = x)
#========================================

print('##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')
##################################################################################
