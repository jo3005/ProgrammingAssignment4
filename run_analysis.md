---
title: "Coursera_CleaningData_Assignment4"
author: "Joanna Sikorska"
date: "12 October 2018"
output: html_document
---
This code was written to fulfill the requirements of Assignment 4 of the Coursera Getting and Cleaning Data Course.
The code assumes that the dataset has been downloaded and has been unzipped, and the root directory of this download has been placed in a directory called Data, which itself is located in the Working Directory.

The data for this assignment was downloaded from on 11-Oct-2018:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The code required to perform the necessary tasks has been included into one function called run_analysis.R
This function takes no arguments and returns a dataframe with 50 columns and 180 rows.

The original dataset comprised of data from Fitbit activity monitors from 30 subjects performing one of six activitites, that was then processed into 561 derived attributes. The original dataset of 561 attributes for the 30 subjects was originally split into separate training and test sets (based on subject).  

run_analysis.R performs the following tasks:

1. Reads the data from files stored in a directory called data that is contained in the Working Directory.  
2. Merges the training and test sets into one dataset.
3. Extracts only the 48 attributes relating to mean and standard deviations.
4. Splits the combined dataset into groups based on the activity performed and the subject number.  This results in a total of 180 groups.
5. Determines the average for each group to give a 'mean of Mean' or 'mean of Standard Deviation'.
6. Formats the data so it can be read in tabular form (stored as a dataframe) with the activity and subject as the first two columns.
7. Outputs the data.

The output therefore consists of 50 columns and 180 rows.  

Columns 1-2 correspond to activity (activity description) and subject (subject number).

The columns 3-50 correspond to the mean and standard deviation variables from were in the original dataset.  Some minor modifications were made to the column names (namely removing brackets and replacing a '-' with an underscore '_' character.)  This was to improve text parsing.

The row values correspond to the mean values of each of these columns for the six activity conditions of:
The rows correspond to the following 6 activity levels:

LAYING
SITTING
STANDING
WALKING
WALKING_DOWNSTAIRS
WALKING_UPSTAIRS

All column names (including the list of derived signal features) are provided in the codebook.csv file.


```{r}
library(data.table)
library(dplyr)

```
Loads required libraries that will be used later on.


```{r}
 wd<-getwd()
```
Loads the working directory into memory so the file paths can be built from this.


``` {r}
    # Get location of files with respect to wd
    
    trainlocn<-paste(wd, "/Data/UCI HAR Dataset/train","/X_train.txt",sep="")
    trainlablocn<-paste(wd, "/Data/UCI HAR Dataset/train","/y_train.txt",sep="")
    testlocn<-paste(wd,"/Data/UCI HAR Dataset/test","/X_test.txt",sep="")
    testlablocn<-paste(wd,"/Data/UCI HAR Dataset/test","/y_test.txt",sep="")
    features_locn<-paste(wd,"/Data/UCI HAR Dataset","/features.txt",sep="")
    activitylabloc<-paste(wd,"/Data/UCI HAR Dataset","/activity_labels.txt",sep="")
    subjecttestlocn<-paste(wd,"/Data/UCI HAR Dataset/test","/subject_test.txt",sep="")
    subjecttrainlocn<-paste(wd, "/Data/UCI HAR Dataset/train","/subject_train.txt",sep="")
    
```
Loads file locations into memory of all files that will be required:
    - location of file containing training dataset (X_train.txt)
    - location of file containing labels for activities associated with training dataset (y_train.txt)
    - location of file containing test dataset (X_test.txt) It is assumed that these are in the same order as in the data file.
    - location of file containing labels for activities associated with test dataset (y_test.txt) It is assumed that these are in the same order as in the data file.
    - location of file containing column names (what each data column represents) (features.txt)
    - location of file that maps the activity names to the activity numbers stored in the y_train.txt and y_test.txt files
    - location of file containing subject numbers for records in test dataset (subject_test.txt).  It is assumed that these are in the same order as in the data file.
    - location of file containing subject numbers for records in training dataset (subject_train.txt). It is assumed that these are in the same order as in the data file.
    

```{r}
    # Read files into memory
    
    trainset<-read.table(trainlocn,header=FALSE,stringsAsFactors = FALSE)
    trainlabels<-read.table(trainlablocn,header=FALSE,stringsAsFactors = FALSE)
    testset<-read.table(testlocn,header=FALSE,stringsAsFactors = FALSE)
    testlabels<-read.table(testlablocn,header=FALSE,stringsAsFactors = FALSE)
    featuresdf<-read.delim(features_locn,header=FALSE,stringsAsFactors = FALSE)
    activity_labels<-read.table(activitylabloc,header=FALSE,stringsAsFactors = FALSE)
    subject_testlabels<-read.table(subjecttestlocn,header=FALSE,stringsAsFactors = FALSE)
    subject_trainlabels<-read.table(subjecttrainlocn,header=FALSE,stringsAsFactors = FALSE)
```
Loads all files into memory.


```{r}
#merge the datasets
    merged_data<-rbind(trainset,testset)
    activities<-rbind(trainlabels,testlabels)
    subjects<-rbind(subject_trainlabels,subject_testlabels)
    
```

Merges the training and test files dataset.  
Merges the training and test activity files.
Merges the training and test subject files.

```{r}
#Extract dataset column idenfiers from the Features textfile and remove brackets
    featurenames<-lapply(strsplit(featuresdf$V1," "),function (x) {x[2]})
    featurenames<-lapply(featurenames,function (x){gsub("[(,)]","",x) })
    featurenames<-lapply(featurenames,function (x){gsub("[-]","_",x) })

    colnames(merged_data)<-featurenames
```
Extracts the useful parts of the names of the feature vectors from the input data, which also includes a feature number.  This involves:
    - splitting the textfield into two parts and disgarding the first part (the number)
    - removing brackets in the names
    - replacing minus ('-') with an underscore ('_')
Then these feature names are applied to the columns of the merged dataset.

```{r}
#Determine which columns relate to mean or standard deviation
    col_list<-which(lapply(as.list(colnames(merged_data)),function (x) {grep("_std_",x)||grep("_mean_",x)}) == TRUE)
    
#Filter out only the columns that relate to mean or standard deviation
    merged_data<-merged_data[,col_list]    

```
Determines which columns relate to mean or standard deviation by identifying which column names contain the text '_std_' or '_mean_'.  'Mean' on its own was not sufficient as other parameters contained the word used in a different context.
Filter the previously combined dataset to only keep columns relating to Mean or Std Deviation.

```{r}

#Add columns to identify the activity and subject
    merged_data$subjects<-subjects[[1]]
    merged_data$activity <- activities[[1]]

```    
Add columns to the dataset to identify the activity and subject but keep these in numerical form.  This is so the data on these factors can be retained through the averaging process.



```{r}
#Split the data frame based on the factorised activities, and factorised subjects.  
    split_data<-split(merged_data,list(as.factor(merged_data$activity),as.factor(merged_data$subjects)))
    
```
The dataset in the dataframe is split based on type of activity and subject.

```{r}
    splitresults<-simplify2array(lapply(split_data,function (x){apply(x,2,"mean")}))
```
Means are calculated for each feature at every activity level and then reformatted into a matrix.

```{r}
 ## Transpose and build the output array
    splitresults<-data.frame(aperm(splitresults))
    
```
The array is then reformated as a dataframe as per the instructions.

```{r}
# Replace activity number with text label
    splitresults$activity<-as.factor(inner_join(x=data.frame(V1=splitresults$activity),activity_labels,by="V1")$V2)
```
The numbers used to designate activity are replaced with text labels.

```{r}
#Reorder dataframe so the factors are in the first two columns
    rtn<-cbind(cbind(activity=as.character(splitresults$activity),subject=splitresults$subjects),splitresults[,1:48])    
```    
The array/dataframe is rearranged so that the activity and subject are the first two columns of the outputted table.

This resulting tabular data stored as a dataframe is returned from the function.


