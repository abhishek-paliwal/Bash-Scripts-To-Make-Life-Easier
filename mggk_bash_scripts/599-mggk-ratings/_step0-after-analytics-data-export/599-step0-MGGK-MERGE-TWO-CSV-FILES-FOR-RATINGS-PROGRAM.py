## THIS SCRIPT MERGES TWO CSV FILES WITH A SINGLE COMMON COLUMN, NAMED AS 'URL'
##------------------------------------------------------------------------------
import pandas as pd
CSVFILE1="google_analytics_exported_90_days_pageviews.csv" ;
CSVFILE2="all_current_mggk_urls_sorted.csv" ; 
CSVFILE_TO_EXPORT="_RESULT_599_MGGK_RATING_REQUIREMENT_FILE_CSV_FROM_GOOGLE_SHEETS.csv";

## IMPORTING THE CSV FILES AS DATAFRAMES
f1 = pd.read_csv(CSVFILE1, header = 0)
f2 = pd.read_csv(CSVFILE2, header = 0)

## MERGING THE DATA FROM TWO FILES
f = f1.merge(f2, how='right', on='URL')
## REMOVING ALL DUPLICATE ROWS
f_new = f.drop_duplicates()
f_new = f_new.fillna(0) # replacing blank values with zero
f_new = f_new.astype({"UNIQUE_PAGEVIEWS_IN_LAST_90_DAYS": int}) #converting column to integer values
f_new = f_new.sort_values(by=['UNIQUE_PAGEVIEWS_IN_LAST_90_DAYS'], ascending=False) #sorting
## EXPORTING TO CSV FILE
f_new.to_csv(CSVFILE_TO_EXPORT, index=False)