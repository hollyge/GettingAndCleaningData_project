---
title: "README.md"
author: "Ge_Xiaojia"
date: "21 September, 2014"
output: README.md
---

This is an R Markdown document: README explains how the scripts of run_analysis.R work and how they are connected.

Data is read, cleaned, and transformed step by step according to the following instruction:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

To explain this in detail:

# Merges the training and the test sets to create one data set.

step1: Training data set are read from 3 files in "UCI HAR Dataset/train" depository:  "X_train.txt", "subject_train.txt",  "y_train.txt" 
data for all the measurement for 561 features (variables) are from "X_train.txt"        
data about subjects who performed the training are from "subject_train.txt" 
data about the activites code are from "y_train.txt" 

step2: These 3 datas are combined together by cbind() command, which leads to complete training data set.

step3: Complete test data set was obtained by the same way from the "UCI HAR Dataset/test" depository.

step4: traing data set and test data set are merged by rbind() command, which is saved in "TrainTestData" data frame.

The scripts for this part as following:
```{r}
var561TrainPath<-"./Rdata/UCI HAR Dataset/train/X_train.txt"
var561TrainData<-read.table(var561TrainPath,sep="", header=F)

SubjectTrainPath<-"./Rdata/UCI HAR Dataset/train/subject_train.txt"
SubjectTrain<-read.table(SubjectTrainPath, sep="", header=F)
var561TrainData<-cbind(SubjectTrain$V1,var561TrainData)

activityTrainPath<-"./Rdata/UCI HAR Dataset/train/y_train.txt"
activityTrainData<-read.table(activityTrainPath, sep="", header=F)
var561TrainData<-cbind(activityTrainData$V1, var561TrainData)

var561TestPath<-"./Rdata/UCI HAR Dataset/test/X_test.txt"
var561TestData<-read.table(var561TestPath,sep="", header=F)

SubjectTestPath<-"./Rdata/UCI HAR Dataset/test/subject_test.txt"
SubjectTest<-read.table(SubjectTestPath, sep="", header=F)
var561TestData<-cbind(SubjectTest$V1,var561TestData)

activityTestPath<-"./Rdata/UCI HAR Dataset/test/y_test.txt"
activityTestData<-read.table(activityTestPath, sep="", header=F)
var561TestData<-cbind(activityTestData$V1, var561TestData)

colnames(var561TrainData)[1:2]<-c("Activity","Subject")
colnames(var561TestData)[1:2]<-c("Activity","Subject")
TrainTestData<-rbind(var561TrainData,var561TestData)

```


# Extracts only the measurements on the mean and standard deviation for each measurement. 

step1: The whole list for feature names are read from "features.txt" in "UCI HAR Dataset" depository.

step2: Using partial match function grep() to filter the feature names containing "mean" or "std".

step3: Using the indext extracted in step2 to subset the measurements only for mean or std, together with Activity and Subject information (1st and 2nd columns).

The scripts for this part as following:
```{r}
var561headerPath<-"./Rdata/UCI HAR Dataset/features.txt"
var561header<-read.table(var561headerPath, sep="",header=F)

MeanStdIndex<-grep("mean|std", var561header$V2)
MeanStdTrainTestData<-TrainTestData[,c(1:2,MeanStdIndex+2)]
```

# Uses descriptive activity names to name the activities in the data set.

step1: descriptive activity names are read from " activity_labels.txt" in "UCI HAR Dataset" depository. 

step2: use activitiy names to replace the number code in the "Activity" columne of the data set.

The scripts for this part as following:
```{r}
activityNamePath<-"./Rdata/UCI HAR Dataset/activity_labels.txt"
activityName<-read.table(activityNamePath, sep="", header=F)
activityName$V2<-as.character(activityName$V2)

MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==1] <- activityName$V2[1]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==2] <- activityName$V2[2]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==3] <- activityName$V2[3]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==4] <- activityName$V2[4]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==5] <- activityName$V2[5]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==6] <- activityName$V2[6]
```


# Appropriately labels the data set with descriptive variable names. 

feature (variable) names only for "mean" and "std" are added into data set as column names.

the scripts for this part as following:
```{r}
MeanStdHeader<-as.character(var561header$V2[MeanStdIndex])
colnames(MeanStdTrainTestData)[3:81]<-MeanStdHeader
```

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

use data.table to subset the data set by "Subject" first, then "Activity", then calculate mean for each feature (variable). Before this, convert the data set as data.table and save in "MeanStdTrainTestDataDT". The data for average is saved in a new data set named "MeanByGroup".

the scripts fro this part as following:
```{r}
MeanStdTrainTestDataDT<-data.table(MeanStdTrainTestData)
MeanByGroup<-MeanStdTrainTestDataDT[,lapply(.SD,mean),by=list(Subject, Activity)] 
```

