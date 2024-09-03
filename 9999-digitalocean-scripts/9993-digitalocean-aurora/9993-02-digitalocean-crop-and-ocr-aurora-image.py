################################################################################
## THIS PYTHON PROGRAM CROPS THE AURORA IMAGE AT CHOSEN COORDINATES,
## THEN DOES THE OCR TO THE CROPPED IMAGE.
## DATE: 2024-09-02
## BY: PALI 
## USAGE: /path/to/python3 this_program.py arg1 arg2 [where, arg1 = input image / arg2 = cropped image]
################################################################################

from PIL import Image
import pytesseract
import cv2
import sys

####
image_path = sys.argv[1] ;
image_path_cropped = sys.argv[2] ;
output_txtfile = sys.argv[3] ;

####
def crop_and_ocr(image_path, x1, y1, x2, y2):
  """Crops an image and performs OCR on the cropped region.

  Args:
    image_path: The path to the image file.
    x1: The x-coordinate of the top-left corner of the cropped region.
    y1: The y-coordinate of the top-left corner of the cropped region.
    x2: The x-coordinate of the bottom-right corner of the cropped region.
    y2: The y-coordinate of the bottom-right corner of the cropped region.

  Returns:
    The extracted text from the cropped image.
  """

  # Open the image
  image = Image.open(image_path)

  # Crop the image
  cropped_image = image.crop((x1, y1, x2, y2))

  # Save the cropped image as a PNG file
  cropped_image.save(image_path_cropped, format="PNG")

  # Optional: Preprocess the image (e.g., grayscale, thresholding)
  # For better OCR results, especially on noisy images
  # gray = cv2.cvtColor(np.array(cropped_image), cv2.COLOR_BGR2GRAY)
  # thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)[1]
  # cropped_image = Image.fromarray(thresh)

  # Perform OCR
  text = pytesseract.image_to_string(cropped_image)

  return text
####

x1, y1 = 0, 980
x2, y2 = 742, 1143

#x1, y1 = 0, 0
#x2, y2 = 742, 1329

extracted_text = crop_and_ocr(image_path, x1, y1, x2, y2)
print(extracted_text)

## write results to an external text file
with open(output_txtfile, "w") as f:
    extracted_text = extracted_text.replace("\n", " ") ; 
    extracted_text = "".join(extracted_text.splitlines()) ; 
    f.write(extracted_text) ; 
