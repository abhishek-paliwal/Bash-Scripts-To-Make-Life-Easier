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
    ## THIS SCRIPT MAKES QUOTES WALLPAPERS WITH BACKGROUND IMAGES AND RANDOM BACKGROUND COLORS.
    ## IT USES PYTHON PILLOW (PIL) LIBRARY TO CREATE SUCH QUOTE WALLPAPER IMAGES.
    ################################################################################
    ## USAGE: python3 THIS_SCRIPT_NAME 
    ################################################################################
    ## MADE BY: PALI
    ## MADE ON: Thursday FEB 02, 2021
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

import os
import random
import time
from PIL import ImageFont
from PIL import Image
from PIL import ImageDraw

##################################################################################
# CHANGE THE FOLLOWING CONFIGURATION IF YOU HAVE TO
FONTS_DIR = str(os.environ['REPO_SCRIPTS']) + \
    "/2000_vendor_programs/2001-python-quotes-wallpapers/fonts"
INPUT_DIR_BACKGROUNDS = str(
    os.environ['REPO_SCRIPTS']) + "/2000_vendor_programs/2001-python-quotes-wallpapers/input"
OUTPUT_DIR = str(os.environ['DIR_Y'])
##
IMAGE_WIDTH = 1200
IMAGE_HEIGHT = 1200
FONT_SIZE = 60
WRAP_TEXT_AT = 30
COLOR = (255, 255, 255)
SPACING = 10 ## SET LINE SPACING
LOGO_IMAGE = str(os.environ['REPO_SCRIPTS']) + \
    "/2000_vendor_programs/2001-python-quotes-wallpapers/logo.png"
LOGO_WIDTH = 200
LOGO_PADDING_LEFT = 50
LOGO_PADDING_TOP = 50
LOGO_PADDING_BOTTOM = 100
##
FOOTER_TEXT = "www.EXAMPLE.com // Ph: 000 000 000"


##################################################################################
## MAIN FUNCTION DEFINITIONS
##################################################################################

def resize_image_by_width(my_image, desired_width):
    basewidth = desired_width
    img = Image.open(my_image)
    wpercent = (basewidth / float(img.size[0]))
    hsize = int((float(img.size[1]) * float(wpercent)))
    img = img.resize((basewidth, hsize), Image.ANTIALIAS)
    return img
    #img.save('resized_image.jpg')


def resize_image_by_height(my_image, desired_height):
    baseheight = desired_height
    img = Image.open(my_image)
    hpercent = (baseheight / float(img.size[1]))
    wsize = int((float(img.size[0]) * float(hpercent)))
    img = img.resize((wsize, baseheight), Image.ANTIALIAS)
    return img
    #img.save('resized_image.jpg')


def select_background_image():
    options = os.listdir(INPUT_DIR_BACKGROUNDS)
    return INPUT_DIR_BACKGROUNDS + "/" + random.choice(options)


def select_font():
    options = os.listdir(FONTS_DIR)
    return FONTS_DIR + "/" + random.choice(options)


def wrap_text(text, w):
    new_text = ""
    new_sentence = ""
    for word in text.split(" "):
        delim = " " if new_sentence != "" else ""
        new_sentence = new_sentence + delim + word
        if len(new_sentence) > w:
            new_text += "\n" + new_sentence
            new_sentence = ""
    new_text += "\n" + new_sentence
    return new_text

def insert_footer(draw):
    font_footer = ImageFont.truetype(FONT, int(FONT_SIZE*2/3))
    draw.multiline_text(align="center", xy=(
        LOGO_PADDING_LEFT, IMAGE_HEIGHT-LOGO_PADDING_BOTTOM), text=FOOTER_TEXT, fill=COLOR, font=font_footer, spacing=SPACING)

def paste_logo(img):
    logo_image = resize_image_by_width(LOGO_IMAGE, LOGO_WIDTH)
    img.paste(logo_image, (LOGO_PADDING_LEFT,
                           LOGO_PADDING_TOP), mask=logo_image)

def insert_main_text(text,font,img,draw):
    ## INSERTING MAIN TEXT
    img_w, img_h = img.size
    x = img_w / 2
    y = img_h / 2
    textsize = draw.multiline_textsize(text, font=IF, spacing=SPACING)
    text_w, text_h = textsize
    x -= text_w / 2
    y -= text_h / 2
    draw.multiline_text(align="center", xy=(x, y), text=text,
                        fill=COLOR, font=font, spacing=SPACING)

def generate_random_rgb_color():
    # Random Background color
    color_red = random.randint(0, 255)
    color_green = random.randint(0, 255)
    color_blue = random.randint(0, 255)
    colors = [(color_red, color_green, color_blue)]
    ## NOTE: You can enter your static brands color below instead of random colors from above.
    ## colors = [(255,0,0), (51, 0, 51), (0,0,255), (0,0,0)]
    return colors


##################################################################################
##################################################################################
def make_wallpaper_with_background_image(text, output_filename, background_img):
    ## INTITIAL SETUP
    colors = generate_random_rgb_color()
    system_color = random.choice(colors)
    img = Image.new("RGBA", (IMAGE_WIDTH, IMAGE_HEIGHT),
                    (system_color[0], system_color[1], system_color[2]))
    font = ImageFont.truetype(FONT, FONT_SIZE)
    text = wrap_text(text, WRAP_TEXT_AT)
    ## MAKE THE CANVAS EDITABLE
    draw = ImageDraw.Draw(img)

    # GETTING AND PASTING background IMAGE
    #back = Image.open(background_img, 'r')
    back = resize_image_by_width(background_img, IMAGE_WIDTH)
    img_w, img_h = back.size
    bg_w, bg_h = img.size
    offset = ( int((bg_w - img_w) / 2), int((bg_h - img_h) / 2) )
    img.paste(back, offset)
    
    ## PASTE LOGO
    paste_logo(img)

    ## INSERTING MAIN TEXT
    insert_main_text(text, font, img, draw)

    ## INSERTING FOOTER
    insert_footer(draw)

    ## FINAL PAINT
    draw = ImageDraw.Draw(img)

    ## OUTPUT
    print(text + " => " + output_filename)
    img.save(output_filename)
    return output_filename

##################################################################################
##################################################################################

def make_wallpaper_with_background_color(text, output_filename):
    ## INTITIAL SETUP
    colors = generate_random_rgb_color()
    system_color = random.choice(colors)
    img = Image.new("RGBA", (IMAGE_WIDTH, IMAGE_HEIGHT), (system_color[0], system_color[1], system_color[2]))
    font = ImageFont.truetype(FONT, FONT_SIZE)
    text = wrap_text(text, WRAP_TEXT_AT)
    ## MAKE THE CANVAS EDITABLE
    draw = ImageDraw.Draw(img)

    ## PASTE LOGO
    paste_logo(img)

    ## INSERTING MAIN TEXT
    insert_main_text(text, font, img, draw)

    ## INSERTING FOOTER
    insert_footer(draw)

    ## FINAL PAINT
    draw = ImageDraw.Draw(img)

    ## OUTPUT
    print(text + " => " + output_filename)
    img.save(output_filename)
    return output_filename
##################################################################################

##################################################################################
##################################################################################
#### CALLING THE MAIN FUNCTION TO PRINT OUT THE WALLPAPER QUOTE
for x in range(3): ## making 3 copies of each
    FONT = select_font()
    IF = ImageFont.truetype(FONT, FONT_SIZE)
    ## GETTING THE TEXT VALUE FOR THE QUOTE
    text = "The only real limitation on your abilities is the level of your desires. If you want it badly enough, there are no limits on what you can achieve."
    output_filename_image = OUTPUT_DIR + \
        "/{}_image.png".format(int(time.time()))
    output_filename_color = OUTPUT_DIR + \
        "/{}_color.png".format(int(time.time()))
    ##
    make_wallpaper_with_background_image(
        text, output_filename_image, background_img=select_background_image())
    make_wallpaper_with_background_color(text, output_filename_color)
##################################################################################
##################################################################################
