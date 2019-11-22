################################################################################
"""
## THIS PROGRAM USES CSV OUTPUTS CREATED FROM 601... PYTHON SCRIPT, AND CREATE
## VARIOUS PLOTS USING PYTHON pandas AND matplotlib packages.
## Created on: Monday November 18, 2019
## Created by: Pali
"""
################################################################################
import pandas as pd
import numpy as np
import scipy as sp
import matplotlib as mpl
import matplotlib.pyplot as plt
################################################################################
print ('################################################################################') ;
print() ;
################################################################################
## PARSING COMMAND LINE ARGUMETNS
import sys
##
my_csv_file = sys.argv[1] ## THE CSV FILE is the first argument
## Printing CSV FILENAME
print("CSV FILENAME = ", my_csv_file) ; print();
print ('>> NUMBER OF COMMAND-LINE ARGUMENTS:', len(sys.argv), 'arguments.') ; print();
print ('>> ARGUMENT LIST:', str(sys.argv)) ; print();
print ('>> IMPORTANT NOTE: This program needs only one argument, which should be the full path to the CSV file to be analysed for plotting.') ; print();

## SEPARATING THE CSV FILENAME AND EXTENSION PARTS
import os
myfilename, myfilename_extension = os.path.splitext(my_csv_file)
MYPLOT_FILENAME = myfilename + '.png'
################################################################################

############### BEGIN : MAIN FUNCTION ##########################################
## print_all is boolean = True OR False
def FUNCTION_PRINT_ALL_INFO_FROM_CSV_VALUES(my_csv_file, print_all):
    #my_csv_file = "mggk_20191120_TMP_601_MGGK_AI_NLP_OUTPUT_FOR_FUTURE_ANALYSES.CSV"
    df = pd.read_csv(my_csv_file)

    '''
    ## Following are all column names (choose from these for referencing)
    Index(['URL_NUM', 'URL_NAME', 'NLP_READING_TIME_IN_MINS_212WPM',
           'BSOUP_NUMWORDS', 'NLP_NUMWORDS', 'META_YEARS_SINCE_FIRST_PUBLISHED',
           'META_YEARS_SINCE_LAST_MODIFIED', 'NLP_FIRST_PUBLISHED_DATETIME',
           'META_FIRST_PUBLISHED_DATE', 'META_LAST_MODIFIED_DATETIME',
           'NLP_KEYWORDS', 'TITLE_TAG_VALUE', 'META_DESCRIPTION'],
          dtype='object')
    '''
    ## Printing indexes
    print(">>>> DATAFRAME INDEXES = ", df.index) ; print() ;
    ## Printing all column names
    print(">>>> DATAFRAME COLUMN NAMES = ", df.columns) ; print() ;
    ## Sorting whole df by reading_time column, then summarizing that column
    df_sorted_by_readingTime = df.sort_values(by='NLP_READING_TIME_IN_MINS_212WPM')
    ## Create two new columns based upon the string lengths of titles and meta-descriptions:
    df['LENGTH_OF_TITLES'] = df.apply(lambda row: len(row.TITLE_TAG_VALUE), axis=1)
    df['LENGTH_OF_META_DESCRIPTIONS'] = df.apply(lambda row: len(row.META_DESCRIPTION), axis=1)
    ## Selecting columns with numeric values only, to plot later
    df_number_cols = df.loc[:, ['NLP_READING_TIME_IN_MINS_212WPM',
           'BSOUP_NUMWORDS', 'NLP_NUMWORDS', 'META_YEARS_SINCE_FIRST_PUBLISHED',
           'META_YEARS_SINCE_LAST_MODIFIED','LENGTH_OF_TITLES','LENGTH_OF_META_DESCRIPTIONS']]

    ##------------------------------------------------------------------------------
    if print_all:
        print('\n>>>> PRINTING SUMMARY VALUES for NLP_READING_TIME_IN_MINS_212WPM:')
        print(df_sorted_by_readingTime.NLP_READING_TIME_IN_MINS_212WPM.describe())

        ## Printing unique values with counts for reading_time column
        print('\n>>>> PRINTING UNIQUE VALUES WITH COUNTS:')
        print(df_sorted_by_readingTime.NLP_READING_TIME_IN_MINS_212WPM.value_counts())

        # Printing those two columns
        print( df.loc[:, ['LENGTH_OF_TITLES','LENGTH_OF_META_DESCRIPTIONS']] )

        # Printing the dataframe containing only numeric data
        print(df_number_cols)
    ##------------------------------------------------------------------------------
    ## RETURNING THE FINAL DATAFRAME VARIABLE
    return df_number_cols
############### END : MAIN FUNCTION ##########################################

## CALLING MAIN FUNCTION -------------------------------------------------------
df_number_cols = FUNCTION_PRINT_ALL_INFO_FROM_CSV_VALUES(my_csv_file, print_all=False)

##------------------------------------------------------------------------------
## Plotting natively using pandas plot method
## (Learn more: https://pandas.pydata.org/pandas-docs/stable/user_guide/visualization.html#visualization-barplot)
plt.close('all') ## IF already plot interface is open
## CREATES A FIGURE WITH 2000x1200 PIXELS DIMENSIONS
#### You can use html color names to use below
myfig = df_number_cols.hist(color='Navy', alpha=1, bins=10, figsize=(20, 12))
fig = myfig[0][0].get_figure() ##  We need to break the np.arrary for plots, into elements.
fig.suptitle('CSV DATA FILE USED = ' + my_csv_file)
fig.savefig(MYPLOT_FILENAME)
print(); print('>> SAVED, PNG FILE FOR PLOT FIGURE = ' + MYPLOT_FILENAME) ;
##------------------------------------------------------------------------------
