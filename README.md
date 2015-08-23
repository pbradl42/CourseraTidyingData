# CourseraTidyingData
Repository for 'Getting and Cleaning Data' coursera course

## Run_Analysis.R
Script for tidying dataset provided as UCI HAR Dataset from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

### Running run_analysis
run_analysis assumes working directory is the unzipped file.  You can chage 'directory' in third line of file if it is a different location.

### Description
The script takes the following steps:
* Using function 'collectFiles', script reads files in subdirectories and makes dataframes. The 'y_*.txt' file is give the variable name 'ActivityID', and the 'subject_*.txt' file the variable name 'SubjectID'   which are passed through tbl_df before being returned.

* Function collectFiles is called for both 'test' and 'train' sets, and results combined. Data set origin is stored in new variable 'set'.

* Variable names are applied from 'features.txt'. 

* Activity names applied from 'activity_labels.txt' into new column 'Activity'.

* From the original dataset, only the columns containing means and standard deviations are extracted (NOTE: this does NOT include meanFreq columns, which are different).

* The dataframe is 'melted' so that each 'mean' and 'std' variable is contained in a single row, with the value of that variable in the 'values' column.

* The dataframe is grouped by variable, Activity and subject, and summarized with mean().

* The result is a table in which each row represents the mean measure on that variable for that subject in that activity

## Codebook for output table
run_analysis.R creates 'tidyUCI.txt', a file with the following data:
* Variable - the mean or std variable contained in the original set, representing the mean of the activity recorded in the original experiment. Each variable begins with 't' representing 'time' or 'f' representing 'frequency', what was measured, and the X, Y, or Z direction. 
* Activity - English text description of the activity. One of 7 activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
* SubjectIDa - a unique identifier for one of the 30 subjects participating in the UCI study. Numbers 1-30
* Mean - the mean of the measurements taken of that variable for that subject doing that activity.

