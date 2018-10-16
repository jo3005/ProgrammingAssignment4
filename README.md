# ProgrammingAssignment4
Assignment 4 of the Coursera Getting and Cleaning Data Course

This code was written to fulfill the requirements of Assignment 4 of the Coursera Getting and Cleaning Data Course.
The code assumes that the dataset has been downloaded and has been unzipped, and the root directory of this download has been placed in a directory called Data, which itself is located in the Working Directory.

The data for this assignment was downloaded from on 11-Oct-2018:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The code required to perform the necessary tasks has been included into one function called run_analysis.R
The function run_analysis.R extracts the data, merges the test and training files together, extracts only signal features (columns) relating to mean or standard deviation statistics, groups the data based on activity and subject, and then averages the data for each group and subject.

This function takes no arguments and returns a dataframe with 50 columns and 180 rows.

Details of the column contents are provided in the codebook.csv.
Details of how the program functions are provided in the markdown file, run_analysis.md

