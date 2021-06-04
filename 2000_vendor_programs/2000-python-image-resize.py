import PIL
import os
import os.path
import sys
from PIL import Image

currentDirectory = os.getcwd()
print(">> CURRENT WORKING DIRECTORY => " + currentDirectory)

SUBDIRS = [name for name in os.listdir(currentDirectory)
        if os.path.isdir(os.path.join(currentDirectory, name))]

print("Printing all sub-directories found:")
print(SUBDIRS)

##################################################################################
## FUNCTION DEFINITIONS
##################################################################################
## PRINTING IMAGE SIZES in CURRENT WORKING DIRECTORY
def print_image_dimensions_in_current_working_dir():
    print("##------------------------------------------------")
    print(">> PRINTING IMAGE DIMENSIONS =>")
    print(">> IN CURRENT WORKING DIRECTORY => " + currentDirectory)
    images = [file for file in os.listdir(
        currentDirectory) if file.endswith(('jpeg', 'png', 'jpg'))]
    for image in images:
        img = Image.open(image)
        print(str(img.size[0]) + ' x ' + str(img.size[1]) + ' => ' + image)
####
## PRINTING IMAGE SIZES IN SUB DIRECTORIES IN CURRENT WORKING DIR
def print_image_dimensions_in_subdirs():
    print("##------------------------------------------------")
    print(">> PRINTING IMAGE DIMENSIONS =>")
    for dir in SUBDIRS:
        print()
        print(">> IN THIS DIR => " + dir)
        images = [file for file in os.listdir(
            dir) if file.endswith(('jpeg', 'png', 'jpg'))]
        for image in images:
            img = Image.open(dir + '/' + image)
            print(str(img.size[0]) + ' x ' + str(img.size[1]) + ' => ' + image)
####
## RESIZING IMAGES IN ALL SUBDIRECTORIES
def resizing_images_in_subdirs(my_width, my_height):
    print("========================================") ;
    print(">> RESIZING IMAGES INTO MAX DIMENSIONS OF => " + str(my_width) + " X " + str(my_height) ) ;
    print(">> NOTE: RESIZED IMAGES WILL NOT BE MADE LARGER IF ALREADY WITHIN THE ABOVE GIVEN DIMENSIONS.")
    for dir in SUBDIRS:
        images = [file for file in os.listdir(dir) if file.endswith(('jpeg', 'png', 'jpg'))]
        ##
        for image in images:
            img = Image.open(dir + '/' + image)
            img.thumbnail((my_width, my_height))
            final_image_name = dir + "_resized_DIR_" + image
            img.save(final_image_name, optimize=True, quality=90)
            print('>> Resized image saved => ' + final_image_name)
####
## RESIZING IMAGES IN CURRENT WORKING DIRECTORY
def resizing_images_in_current_working_dir(my_width, my_height):
    print("========================================") ;
    print(">> RESIZING IMAGES INTO MAX DIMENSIONS OF => " + str(my_width) + " X " + str(my_height) ) ;
    print(">> NOTE: RESIZED IMAGES WILL NOT BE MADE LARGER IF ALREADY WITHIN THE ABOVE GIVEN DIMENSIONS.")
    images = [file for file in os.listdir(currentDirectory) if file.endswith(('jpeg', 'png', 'jpg'))]
    ##
    for image in images:
        img = Image.open(currentDirectory + '/' + image)
        img.thumbnail((my_width, my_height))
        final_image_name =  "_resized_DIR_" + image
        file_path = os.path.join( currentDirectory, final_image_name  ) 
        print("====> " + currentDirectory + " XXXX " + final_image_name)
        img.save(file_path, optimize=True, quality=90)
        print('>> Resized image saved => ' + file_path)
####
##################################################################################
##################################################################################

## CALLING FUNCTIONS
print_image_dimensions_in_current_working_dir()
print_image_dimensions_in_subdirs()
resizing_images_in_subdirs(1280,12000)
resizing_images_in_current_working_dir(1280,12000)
print_image_dimensions_in_current_working_dir()
