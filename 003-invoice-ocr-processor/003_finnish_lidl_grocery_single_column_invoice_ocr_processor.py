################################################################################
# This Python program extracts text from a specified single column
# in all images' invoices (eg. lidl) present in current directory, 
# preprocesses them using thresholding for 
# enhanced OCR, and saves the thresholded image and OCR text with support 
# for the Finnish language.
#############################################
## Important Note: Make sure to crop the invoice(s) so that only the items and prices are visible.
#############################################
# Usage: python3 THIS_PROGRAM_PATH ARG_1 // ARG_1 = INVOICE_image_path 
####
# Date: 2023-11-23
# By: Pali 
################################################################################

import sys
import os
import cv2
import pytesseract

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def preprocess_image(image, save_thresholded_path=None):
    """
    Preprocess an image for OCR by applying thresholding to enhance text visibility.

    Args:
    - image (numpy.ndarray): Input image as a NumPy array.
    - save_thresholded_path (str): Optional path to save the thresholded image. If None, the image is not saved.

    Returns:
    - thresh (numpy.ndarray): Thresholded image.
    """
    # Convert the image to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Apply thresholding to enhance text
    _, thresh = cv2.threshold(gray, 150, 255, cv2.THRESH_BINARY_INV)

    # Save the thresholded image if a path is provided
    if save_thresholded_path:
        cv2.imwrite(save_thresholded_path, thresh)

    return thresh

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def extract_text_from_single_column(image, language='fin', save_thresholded_path=None):
    """
    Extract text from a single column of an invoice image using OCR.

    Args:
    - image (numpy.ndarray): Input image as a NumPy array.
    - language (str): Language for OCR (default is Finnish).
    - save_thresholded_path (str): Optional path to save the thresholded image. If None, the image is not saved.

    Returns:
    - text (str): Extracted text from the image.
    """
    # Preprocess the image
    preprocessed_image = preprocess_image(image, save_thresholded_path)

    # Use Tesseract to extract text from the entire image with specified language
    text = pytesseract.image_to_string(preprocessed_image, lang=language, config='--psm 6')

    return text

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if __name__ == "__main__":
    # Get the current working directory
    current_directory = os.getcwd()

    # List all files in the current directory
    image_files = [f for f in os.listdir(current_directory) if os.path.isfile(os.path.join(current_directory, f))]

    for image_filename in image_files:
        # Check if the file is an image (you may want to refine this check based on your specific image file types)
        if image_filename.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp')):
            # Generate the full path for the image
            image_path = os.path.join(current_directory, image_filename)

            # Load the image
            image = cv2.imread(image_path)

            # Generate the path for saving the thresholded image
            save_thresholded_path = os.path.join(current_directory, f"_thresholded_{image_filename}")

            # Extract text from the single column with Finnish language and save the thresholded image
            column_text_finnish = extract_text_from_single_column(image, language='fin', save_thresholded_path=save_thresholded_path)

            # Print the extracted text
            print(f"Column Text (Finnish) for {image_filename}:")
            print(column_text_finnish)

            # Generate the path for saving the text file
            text_file_path = os.path.join(current_directory, f"FIN_OCR_{image_filename}.txt")

            # Write the extracted text to the text file
            with open(text_file_path, 'w', encoding='utf-8') as text_file:
                text_file.write(column_text_finnish)

            print(f"Extracted text saved to: {text_file_path}")
