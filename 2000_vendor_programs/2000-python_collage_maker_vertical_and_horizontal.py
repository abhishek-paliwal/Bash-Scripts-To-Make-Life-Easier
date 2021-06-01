from PIL import Image
import os
import sys 

## GETTING VARIABLES FROM CLI ARGUMENTS
DIR_INPUT = sys.argv[1]
DIR_INPUT_BASENAME = os.path.basename(DIR_INPUT)
DIR_OUTPUT = sys.argv[2]
print('>> CURRENT INPUT DIRECTORY => ' + str(DIR_INPUT))
print('>> CURRENT OUTPUT DIRECTORY => ' + str(DIR_OUTPUT))

## LISTING ALL IMAGES
all_images = os.listdir(DIR_INPUT) ;
## CREATING PIL IMAGE OBJECTS OF ALL IMAGES FOUND
all_images_as_pil_objects = [Image.open(DIR_INPUT + '/' + x) for x in all_images]
##

##################
## FUNCTION TO PRINT ELEMENTS OF A LIST LINE BY LINE
def PRINT_LIST_ELEMENTS_LINE_BY_LINE(my_list, list_desc):
    print(); print('     >> PRINTING ALL ELEMENTS => ' + list_desc)
    for z in my_list:
        print(z)

##
PRINT_LIST_ELEMENTS_LINE_BY_LINE(all_images, list_desc='All images in chosen directory ...')
PRINT_LIST_ELEMENTS_LINE_BY_LINE(all_images_as_pil_objects, list_desc='All PIL image objects ...')
##################

##################################################################################
def resize_and_make_horizontal_collage(im_list, resample=Image.BICUBIC):
    min_height = min(im.height for im in im_list)
    im_list_resize = [im.resize((int(im.width * min_height / im.height), min_height),resample=resample)
                      for im in im_list]
    total_width = sum(im.width for im in im_list_resize)
    dst = Image.new('RGB', (total_width, min_height))
    pos_x = 0
    for im in im_list_resize:
        dst.paste(im, (pos_x, 0))
        pos_x += im.width
    ##
    final_image_name = 'collage-horizontal-for-DIR-' + DIR_INPUT_BASENAME + \
        '-' + str(total_width) + 'x' + str(min_height) + '.jpg'
    print('>> Making horizontal collage => ' + final_image_name)
    dst.save(DIR_OUTPUT + '/' + final_image_name)

def resize_and_make_vertical_collage(im_list, resample=Image.BICUBIC):
    min_width = min(im.width for im in im_list)
    im_list_resize = [im.resize((min_width, int(im.height * min_width / im.width)),resample=resample)
                      for im in im_list]
    total_height = sum(im.height for im in im_list_resize)
    dst = Image.new('RGB', (min_width, total_height))
    pos_y = 0
    for im in im_list_resize:
        dst.paste(im, (0, pos_y))
        pos_y += im.height
    ##
    final_image_name = 'collage-vertical-for-DIR-' + DIR_INPUT_BASENAME + \
        '-' + str(min_width) + 'x' + str(total_height) + '.jpg'
    print('>> Making vertical collage  => ' + final_image_name)
    dst.save(DIR_OUTPUT + '/' + final_image_name)


#========================================
print()
resize_and_make_horizontal_collage(all_images_as_pil_objects)
resize_and_make_vertical_collage(all_images_as_pil_objects)
print('##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++') ;
#========================================
##################################################################################

