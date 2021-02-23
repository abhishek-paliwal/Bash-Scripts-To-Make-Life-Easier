import os
import random
import time
from PIL import ImageFont
from PIL import Image
from PIL import ImageDraw

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
    prefix = "input/"
    options = os.listdir(prefix)
    return prefix + random.choice(options)


def select_font():
    prefix = "fonts/"
    options = os.listdir(prefix)
    return prefix + random.choice(options)


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
def write_image(text, output_filename, background_img):
    # setup
    text = wrap_text(text, WRAP_TEXT_AT)
    img = Image.new("RGBA", (IMAGE_WIDTH, IMAGE_HEIGHT), (255, 255, 255))

    # GETTING AND PASTING background IMAGE
    back = Image.open(background_img, 'r')
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
    draw = ImageDraw.Draw(img)

    ## BEGIN: PRINTING SOMETHINGS TO CLI ##
    print(text)
    ## END: : PRINTING SOMETHINGS TO CLI ##

    # output
    img.save(output_filename)
    return output_filename
##################################################################################

# text
text = "This is a test. This is a test. This is a test. This is a test. safd sadfsa fdsa fdsaf dsafd safdsa dfsa fdsaf dsaf ssf."
output_filename = "output/{}.png".format(int(time.time()))

# config
IMAGE_WIDTH = 1200
IMAGE_HEIGHT = 1200
FONT = select_font()
FONT_SIZE = 60
WRAP_TEXT_AT = 30
IF = ImageFont.truetype(FONT, FONT_SIZE)
COLOR = (255, 255, 255)
SPACING = 5
LOGO_IMAGE = "logo.png"
LOGO_WIDTH = 200
LOGO_PADDING_TOP = 50
LOGO_PADDING_LEFT = 50

write_image(text, output_filename, background_img=select_background_image())
