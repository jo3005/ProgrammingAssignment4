run_analysis <- function () {
    
    library(data.table)
    library(dplyr)
    
    
    # Set the working directory to be a folder containing a Data/UCI Har Dataset subdirectory.
    
    # Get Working directory
    wd<-getwd()
    
    # Get location of files with respect to wd
    trainlocn<-paste(wd, "/Data/UCI HAR Dataset/train","/X_train.txt",sep="")
    trainlablocn<-paste(wd, "/Data/UCI HAR Dataset/train","/y_train.txt",sep="")
    testlocn<-paste(wd,"/Data/UCI HAR Dataset/test","/X_test.txt",sep="")
    testlablocn<-paste(wd,"/Data/UCI HAR Dataset/test","/y_test.txt",sep="")
    features_locn<-paste(wd,"/Data/UCI HAR Dataset","/features.txt",sep="")
    activitylabloc<-paste(wd,"/Data/UCI HAR Dataset","/activity_labels.txt",sep="")
    
    
    # Read files into memory
    trainset<-read.table(trainlocn,header=FALSE,stringsAsFactors = FALSE)
    trainlabels<-read.table(trainlablocn,header=FALSE,stringsAsFactors = FALSE)
    testset<-read.table(testlocn,header=FALSE,stringsAsFactors = FALSE)
    testlabels<-read.table(testlablocn,header=FALSE,stringsAsFactors = FALSE)
    featuresdf<-read.delim(features_locn,header=FALSE,stringsAsFactors = FALSE)
    activity_labels<-read.table(activitylabloc,header=FALSE,stringsAsFactors = FALSE)

    
    
    #merge the datasets
    merged_data<-rbind(trainset,testset)
    activities<-inner_join(rbind(trainlabels,testlabels),activity_labels,by="V1")   
    
    
    #Extract dataset column idenfiers from the Features textfile and remove brackets
    featurenames<-lapply(strsplit(featuresdf$V1," "),function (x) {x[2]})
    featurenames<-lapply(featurenames,function (x){gsub("[(,)]","",x) })
    featurenames<-lapply(featurenames,function (x){gsub("[-]","_",x) })

    colnames(merged_data)<-featurenames
    
    #Determine which columns relate to mean or standard deviation
    col_list<-which(lapply(as.list(colnames(merged_data)),function (x) {grep("_std_",x)||grep("_mean_",x)}) == TRUE)
    
    #Filter out only the columns that relate to mean or standard deviation
    merged_data<-merged_data[,col_list]
    
    #Split the data frame based on the activities 
    split_data<-split(merged_data,activities$V2)
    
    splitresults<-simplify2array(lapply(split_data,function (x){apply(x,2,"mean")}))
    
    ## Transpose the array
    rtn<-data.frame(aperm(splitresults))
}
