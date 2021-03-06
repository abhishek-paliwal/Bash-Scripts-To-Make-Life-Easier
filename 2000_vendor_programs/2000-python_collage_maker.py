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
    Collage maker - tool to create picture collages
    Author: Delimitry
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
import argparse
import os
import random
from PIL import Image

print("\n>>>> USAGE (use JPG for output as it gives reasonalbe file size): p3 python_collage_maker.py -f FOLDER_PATH -w 6000 -i 1050 -o collage_output.jpg") 
print("\n>>>> NOTE: Make sure that no images have height less than that specified in '-i init_height' argument.") 
print("################################################################################")

def make_collage(images, filename, width, init_height):
    """
    Make a collage image with a width equal to `width` from `images` and save to `filename`.
    """
    if not images:
        print('No images for collage found!')
        return False

    margin_size = 2
    # run until a suitable arrangement of images is found
    while True:
        # copy images to images_list
        images_list = images[:]
        coefs_lines = []
        images_line = []
        x = 0
        while images_list:
            # get first image and resize to `init_height`
            img_path = images_list.pop(0)
            img = Image.open(img_path)
            img.thumbnail((width, init_height))
            # when `x` will go beyond the `width`, start the next line
            if x > width:
                coefs_lines.append((float(x) / width, images_line))
                images_line = []
                x = 0
            x += img.size[0] + margin_size
            images_line.append(img_path)
            ##------------------------------------------------------------------------------
            #print('>> begin: PRINTING COEFF LINES ...')
            #print(coefs_lines)
            #print('>> end: PRINTING COEFF LINES ...')
            ##------------------------------------------------------------------------------

        # finally add the last line with images
        coefs_lines.append((float(x) / width, images_line))

        # compact the lines, by reducing the `init_height`, if any with one or less images
        if len(coefs_lines) <= 1:
            break
        if any(map(lambda c: len(c[1]) <= 1, coefs_lines)):
            # reduce `init_height`
            init_height -= 10
            #print(' INIT HEIGHT NEW => ' + str(init_height) )
        else:
            break

    # get output height
    out_height = 0
    for coef, imgs_line in coefs_lines:
        if imgs_line:
            out_height += int(init_height / coef) + margin_size
    if not out_height:
        print('Height of collage could not be 0!')
        return False

    collage_image = Image.new('RGB', (width, int(out_height)), (35, 35, 35))
    # put images to the collage
    y = 0
    for coef, imgs_line in coefs_lines:
        if imgs_line:
            x = 0
            for img_path in imgs_line:
                img = Image.open(img_path)
                # if need to enlarge an image - use `resize`, otherwise use `thumbnail`, it's faster
                k = (init_height / coef) / img.size[1] ;
                if k > 1:
                    img = img.resize((int(img.size[0] * k), int(img.size[1] * k)), Image.ANTIALIAS)
                else:
                    img.thumbnail((int(width / coef), int(init_height / coef)), Image.ANTIALIAS)
                    ##------------------------------------------------------------------------------
                    print( 'INITIAL HEIGHT => ' + str(init_height) + ' // COEFF => ' + str(coef) + ' K => ' + str(k) + ' // Image Size => ' + str(img.size) + ' // Image => ' + str(img_path))
                    ##------------------------------------------------------------------------------
                ##    
                if collage_image:
                    collage_image.paste(img, (int(x), int(y)))
                    print(' X => ' + str(x) + ' Y => ' + str(y))
                x += img.size[0] + margin_size
            y += int(init_height / coef) + margin_size
            ##------------------------------------------------------------------------------
            print('Images => ' + str(images))
            print('Output => ' + str(filename))
            print('Width => ' + str(width))
            print('Init Height => ' + str(init_height))
            print(">>>>>> " + str(coef) + ' ====> ' + str(imgs_line))
            ##------------------------------------------------------------------------------
    collage_image.save(filename)
    return True


def main():
    # prepare argument parser
    parse = argparse.ArgumentParser(description='Photo collage maker')
    parse.add_argument('-f', '--folder', dest='folder', help='folder with images (*.jpg, *.jpeg, *.png)', default='.')
    parse.add_argument('-o', '--output', dest='output', help='output collage image filename', default='collage.png')
    parse.add_argument('-w', '--width', dest='width', type=int, help='resulting collage image width')
    parse.add_argument('-i', '--init_height', dest='init_height', type=int, help='initial height for resize the images')
    parse.add_argument('-s', '--shuffle', action='store_true', dest='shuffle', help='enable images shuffle')

    args = parse.parse_args()
    if not args.width or not args.init_height:
        parse.print_help()
        exit(1)

    # get images
    files = [os.path.join(args.folder, fn) for fn in os.listdir(args.folder)]
    images = [fn for fn in files if os.path.splitext(fn)[1].lower() in ('.jpg', '.jpeg', '.png')]
    if not images:
        print('No images for making collage! Please select other directory with images!')
        exit(1)

    # shuffle images if needed
    if args.shuffle:
        random.shuffle(images)

    print('Making collage ...')
    res = make_collage(images, args.output, args.width, args.init_height)
    if not res:
        print('Failed to create collage!')
        exit(1)
    print('Collage is ready!')


if __name__ == '__main__':
    main()
