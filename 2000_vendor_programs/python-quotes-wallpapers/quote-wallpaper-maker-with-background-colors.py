from PIL import ImageFont
from PIL import Image
from PIL import ImageDraw

import sys
import textwrap
import uuid
import random
import os

# quote font
system_font = "fonts/Quote.ttf"
# font size
system_font_size = 70
font_size_wrap_factor = 2

# image size
image_size_x = 1200 # x
image_size_y = 1200  # y

# image type
image_type = "RGBA"

# background color
#colors = [(255,0,0), (51, 0, 51), (0,0,255), (0,0,0)]
color_red = random.randint(0, 255)
color_green = random.randint(0, 255)
color_blue = random.randint(0, 255)
colors = [(color_red, color_green, color_blue)]

# Logo settings
logo = "-Mantra Coaching-"
logo_padding_left = 10
logo_padding_top = 50 
logo_padding_bottom = 100 

def wrapTextInChunks(text_size, text):
    #wrapper = textwrap.TextWrapper(width = system_font_size)
    wrapper = textwrap.TextWrapper(width = (image_size_x * font_size_wrap_factor)/system_font_size )
    text_element = wrapper.wrap(text = text)
    return text_element

def centerPixel(strlen, line_no):
    temp = []
    x = image_size_x / 2
    y = image_size_y / 2
    t = (strlen * system_font_size) / 5 #4
    temp.append(x - t)
    temp.append(y - (system_font_size * line_no))
    return temp

def createImage(text, image_name):
    system_color = random.choice(colors)
    img = Image.new(image_type, (image_size_x, image_size_y), (system_color[0], system_color[1], system_color[2]))
    draw = ImageDraw.Draw(img)
    fonts = ImageFont.truetype(system_font, system_font_size)
    text_element = wrapTextInChunks(fonts.getsize(text), text)
    line = len(text_element)/2
    ##
    for element in text_element:
        points = centerPixel(len(element), line)
        draw.text((points[0], points[1]), element, (255, 255, 255), font=fonts)
        draw = ImageDraw.Draw(img)
        line = line - 1.5
        ##
        print(points, text_element, line)
    draw.text((logo_padding_left,logo_padding_top), logo, (255,255,255), font=fonts)
    draw.text((logo_padding_left,image_size_y - logo_padding_bottom), logo, (255,255,255), font=fonts)
    img.save(image_name)

#########################################
print (80 * "*")
print ("~~~ quote_maker.py ~~~")

# read quote
#quote_text = str(input("quote: "))
quote_text = "The only real limitation on your abilities is the level of your desires. If you want it badly enough, there are no limits on what you can achieve."

# create unique name
image_name = '{name}.png'.format(name = str(uuid.uuid4()))
# create an image
createImage(quote_text, image_name)

