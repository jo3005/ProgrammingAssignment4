# ProgrammingAssignment4
Assignment 4 of the Coursera Getting and Cleaning Data Course

This code was written to fulfill the requirements of Assignment 4 of the Coursera Getting and Cleaning Data Course.
The code assumes that the dataset has been downloaded and has been unzipped, and the root directory of this download has been placed in a directory called Data, which itself is located in the Working Directory.

The data for this assignment was downloaded from on 11-Oct-2018:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The code required to perform the necessary tasks has been included into one function called run_analysis.R
This function takes no arguments and returns a dataframe with 48 columns and 6 rows.

The 48 columns correspond to the mean and standard deviation variables from were in the original dataset.  Some minor modifications were made to the column names (namely removing brackets and replacing a '-' with an underscore '_' character.)  This was to improve text parsing.

The row values correspond to the mean values of each of these columns for the six activity conditions of:

LAYING
SITTING
STANDING
WALKING
WALKING_DOWNSTAIRS
WALKING_UPSTAIRS

Final column names are provided in the columnNames.csv file.
