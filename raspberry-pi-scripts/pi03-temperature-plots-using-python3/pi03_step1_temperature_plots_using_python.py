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
    ## THIS PROGRAM USES CSV OUTPUTS CREATED FROM PI03... PYTHON SCRIPT, AND CREATE
    ## VARIOUS PLOTS USING PYTHON pandas AND matplotlib packages.
    ## Created on: January 16, 2020
    ## Created by: Pali
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

################################################################################
################################################################################
import pandas as pd
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
from pandas import read_csv
from matplotlib import pyplot

################################################################################
## TRY TO READ THE CLI ARGUMENT. IF FAILS, RAISE EXCEPTION AND EXIT.
import sys
try:
    #CSV_FILE='20200115-pi01-data_temperature_output.csv' ;
    CSV_FILE = sys.argv[1] ## THE CSV FILE is the first argument
except:
    print("ERROR: No CSV file is provided as CLI argument. Hence, the program will stop here and exit.");
    sys.exit(1) ;
################################################################################

## SEPARATING THE CSV FILENAME AND EXTENSION PARTS
import os
myfilename, myfilename_extension = os.path.splitext(CSV_FILE)
MYPLOT_FILENAME = myfilename + '.png'
################################################################################

## READING TIMESERIES DATA FROM CSV FILE
series = read_csv(CSV_FILE, header=0, index_col=0, parse_dates=True, squeeze=True)
print(">>>> PRINTING SOME HEADER ROWS ...")
print(series.head())
print(">>>> PRINTING DESCRIPTION FOR THE DATA SERIES ...")
print(series.describe())

############## FUNCION: CHOOSE RANDOM COLOR FOR PLOT #########################
def FUNCTION_CHOOSE_RANDOM_COLOR_FOR_PLOT():
    import random
    colors = ['#EB816D', '#E07B90', '#BD82AC', '#898CB7', '#5093AC', '#2C948E', '#408F68', '#618645', '#7F7931', '#976932','#A25A44', '#0000FF'] ;
    random_color_index = random.randint( 1,len(colors) ) ;
    chosen_random_color = colors[random_color_index-1] ;
    return chosen_random_color ;
################################################################################

plt.close('all') ## IF already plot interface is open

## CREATES A FIGURE WITH 1200x800 PIXELS DIMENSIONS
#### You can use html color names to use below
chosen_random_color = FUNCTION_CHOOSE_RANDOM_COLOR_FOR_PLOT() ;
myfig = series.plot(color=chosen_random_color, alpha=1, figsize=(12, 6))
fig = myfig.get_figure() ##  We need to break the np.arrary for plots, into elements.

fig.suptitle('CSV DATA FILE USED = ' + CSV_FILE + ' // DIMENSIONS [#ROWS,#COLUMNS] = ' + str(series.shape) + '\n\n Left axis = Temperature in Degree Celsius // Right axis = Time of the day' )

fig.savefig(MYPLOT_FILENAME)
print(); print('>> SAVED, PNG FILE FOR PLOT FIGURE = ' + MYPLOT_FILENAME) ;
################################################################################
