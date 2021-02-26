import os
import random
import time
from PIL import ImageFont
from PIL import Image
from PIL import ImageDraw

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

##################################################################################
def make_wallpaper_with_background_image(text, output_filename, background_img):
    # setup
    text = wrap_text(text, WRAP_TEXT_AT)
    img = Image.new("RGBA", (IMAGE_WIDTH, IMAGE_HEIGHT), (255, 255, 255))

    # GETTING AND PASTING background IMAGE
    #back = Image.open(background_img, 'r')
    back = resize_image_by_width(background_img, IMAGE_WIDTH)
    img_w, img_h = back.size
    bg_w, bg_h = img.size
    offset = ( int((bg_w - img_w) / 2), int((bg_h - img_h) / 2) )
    img.paste(back, offset)
    
    ## BEGIN: GETTING AND PASING LOGO IMAGE ##
    logo_image = resize_image_by_width(LOGO_IMAGE, LOGO_WIDTH)
    img.paste(logo_image, (LOGO_PADDING_LEFT, LOGO_PADDING_TOP), mask=logo_image)
    ## END: GETTING AND PASING LOGO IMAGE ##

    # text
    font = ImageFont.truetype(FONT, FONT_SIZE)
    draw = ImageDraw.Draw(img)
    img_w, img_h = img.size
    x = img_w / 2
    y = img_h / 2
    textsize = draw.multiline_textsize(text, font=IF, spacing=SPACING)
    text_w, text_h = textsize
    x -= text_w / 2
    y -= text_h / 2
    draw.multiline_text(align="center", xy=(x, y), text=text, fill=COLOR, font=font, spacing=SPACING)
    ## FOOTER TEXT
    draw.multiline_text(align="center", xy=(
        LOGO_PADDING_LEFT, IMAGE_HEIGHT-LOGO_PADDING_BOTTOM), text=FOOTER_TEXT, fill=COLOR, font=font, spacing=SPACING)
    ## FINAL PAINT
    draw = ImageDraw.Draw(img)

    # output
    print(text + " => " + output_filename)
    img.save(output_filename)
    return output_filename
##################################################################################

#### CALLING THE MAIN FUNCTION TO PRINT OUT THE WALLPAPER QUOTE
for x in range(2):
    FONT = select_font()
    IF = ImageFont.truetype(FONT, FONT_SIZE)
    ## GETTING THE TEXT VALUE FOR THE QUOTE
    text = "The only real limitation on your abilities is the level of your desires. If you want it badly enough, there are no limits on what you can achieve."
    output_filename = OUTPUT_DIR + "/{}_image.png".format(int(time.time()))
    ##
    make_wallpaper_with_background_image(text, output_filename, background_img=select_background_image())


##################################################################################
##################################################################################
##################################################################################
##################################################################################

##------------------------------------------------------------------------------
def make_wallpaper_with_background_color(text, output_filename):
    # setup
    text = wrap_text(text, WRAP_TEXT_AT)

    # Random Background color
    color_red = random.randint(0, 255)
    color_green = random.randint(0, 255)
    color_blue = random.randint(0, 255)
    colors = [(color_red, color_green, color_blue)]
    ## NOTE: You can enter your static brands color below instead of random colors from above.
    ## colors = [(255,0,0), (51, 0, 51), (0,0,255), (0,0,0)]
    ##
    system_color = random.choice(colors)
    img = Image.new("RGBA", (IMAGE_WIDTH, IMAGE_HEIGHT), (system_color[0], system_color[1], system_color[2]))

    ## BEGIN: GETTING AND PASING LOGO IMAGE ##
    logo_image = resize_image_by_width(LOGO_IMAGE, LOGO_WIDTH)
    img.paste(logo_image, (LOGO_PADDING_LEFT, LOGO_PADDING_TOP), mask=logo_image)
    ## END: GETTING AND PASING LOGO IMAGE ##

    # text
    font = ImageFont.truetype(FONT, FONT_SIZE)
    draw = ImageDraw.Draw(img)
    img_w, img_h = img.size
    x = img_w / 2
    y = img_h / 2
    textsize = draw.multiline_textsize(text, font=IF, spacing=SPACING)
    text_w, text_h = textsize
    x -= text_w / 2
    y -= text_h / 2
    draw.multiline_text(align="center", xy=(x, y), text=text,
                        fill=COLOR, font=font, spacing=SPACING)
    ## FOOTER TEXT
    draw.multiline_text(align="center", xy=(
        LOGO_PADDING_LEFT, IMAGE_HEIGHT-LOGO_PADDING_BOTTOM), text=FOOTER_TEXT, fill=COLOR, font=font, spacing=SPACING)
    ## FINAL PAINT
    draw = ImageDraw.Draw(img)
    
    # output
    print(text + " => " + output_filename)
    img.save(output_filename)
    return output_filename
##------------------------------------------------------------------------------
##################################################################################

#### CALLING THE MAIN FUNCTION TO PRINT OUT THE WALLPAPER QUOTE
for x in range(2):
    FONT = select_font()
    IF = ImageFont.truetype(FONT, FONT_SIZE)
    ## GETTING THE TEXT VALUE FOR THE QUOTE
    text = "The only real limitation on your abilities is the level of your desires. If you want it badly enough, there are no limits on what you can achieve."
    output_filename = OUTPUT_DIR + "/{}_color.png".format(int(time.time()))
    ##
    make_wallpaper_with_background_color(text, output_filename)
