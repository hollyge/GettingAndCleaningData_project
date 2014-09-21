---
title: "CodeBook.md"
author: "Ge_Xiaojia"
date: "21 September, 2014"
output: CodeBook.md
---

This is an R Markdown document: CodeBook for decribing the variables, the data and the transformations that I performed to clean up the data using run_analysis.R.

1. Read all measurements of 561 features from X_train. These measurements are saved in  "var561TrianData".

```{r}
var561TrainPath<-"./Rdata/UCI HAR Dataset/train/X_train.txt"
var561TrainData<-read.table(var561TrainPath,sep="", header=F)
```

2. Read Subject information from subject_train.txt. This information is saved in "SubjectTrain". Add data from "SubjectTrain" into "var561TrainData" by cbind() command.

```{r}
SubjectTrainPath<-"./Rdata/UCI HAR Dataset/train/subject_train.txt"
SubjectTrain<-read.table(SubjectTrainPath, sep="", header=F)
var561TrainData<-cbind(SubjectTrain$V1,var561TrainData)
```

3. Read Activity information from y_train.txt. This information is saved in "activityTrainData". Add the data from "activityTrainData" into "var561TrainData" by cbind() command.

```{r}
activityTrainPath<-"./Rdata/UCI HAR Dataset/train/y_train.txt"
activityTrainData<-read.table(activityTrainPath, sep="", header=F)
var561TrainData<-cbind(activityTrainData$V1, var561TrainData)
```

4. Read all measurements of 561 variables from X_test. These measurements are saved in "var561TestData".

```{r}
var561TestPath<-"./Rdata/UCI HAR Dataset/test/X_test.txt"
var561TestData<-read.table(var561TestPath,sep="", header=F)
```

5. Read Subject information from subject_test.txt. This information is saved in "SubjectTest". Add data from "SubjectTest" into "var561TestData" by cbind() command.

```{r}
SubjectTestPath<-"./Rdata/UCI HAR Dataset/test/subject_test.txt"
SubjectTest<-read.table(SubjectTestPath, sep="", header=F)
var561TestData<-cbind(SubjectTest$V1,var561TestData)
```

6. Read Activity information from y_test.txt. This information is saved in "activityTestData". Add data from "activityTestData" into "var561TestData" by cbind() command.

```{r}
activityTestPath<-"./Rdata/UCI HAR Dataset/test/y_test.txt"
activityTestData<-read.table(activityTestPath, sep="", header=F)
var561TestData<-cbind(activityTestData$V1, var561TestData)
```

7. Combine train data and test data by merging data from "var561TrainData" and "var561TestData" using rbind() command into "TrainTestData". Before merging, change 
the the 1st and 2nd column names for both data frames, which results in exact same column names for both data frames.

```{r}
colnames(var561TrainData)[1:2]<-c("Activity","Subject")
colnames(var561TestData)[1:2]<-c("Activity","Subject")
TrainTestData<-rbind(var561TrainData,var561TestData)
```

8. Read the list of all feature names from features.txt. This information is saved in "var561header".

```{r}
var561headerPath<-"./Rdata/UCI HAR Dataset/features.txt"
var561header<-read.table(var561headerPath, sep="",header=F)
```

9. Filter the feature names with "mean" or "std" and save the index for these features as "MeanStdIndex". Use this indext to extract the measurements only for mean and standard deviation from "TrainTestData". Save the extracted data in "MeanStdTrainTestData".

```{r}
MeanStdIndex<-grep("mean|std", var561header$V2)
MeanStdTrainTestData<-TrainTestData[,c(1:2,MeanStdIndex+2)]
```


10. Read the decriptive activity names from activity_labels.txt. The information is saved in "activityName". Convert the class into character. 
```{r}
activityNamePath<-"./Rdata/UCI HAR Dataset/activity_labels.txt"
activityName<-read.table(activityNamePath, sep="", header=F)
activityName$V2<-as.character(activityName$V2)
```

11. Uses the secriptive activity names saved in "activityName"" to name the activities in "MeanStdTrainTestData".

```{r}
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==1] <- activityName$V2[1]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==2] <- activityName$V2[2]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==3] <- activityName$V2[3]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==4] <- activityName$V2[4]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==5] <- activityName$V2[5]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==6] <- activityName$V2[6]
```

12. Convert the class of extracted feature names (which contains "mean" or "std") as character and save this information in "MeanStdHeader". Ues these extracted feature names to label the column name of "MeanStdTrainTestData" (except the 1st and 2nd column names), for the purpose of labeling the data set with descriptive feature names.  

```{r}
MeanStdHeader<-as.character(var561header$V2[MeanStdIndex])
colnames(MeanStdTrainTestData)[3:81]<-MeanStdHeader
```

13. Save the data from "MeanStdTrainTestData" into data table "MeanStdTrainTestDataDT".  Creates an independent tidy data set named "MeanByGroup", with the average of each variable for each activity and each subject.

```{r}
MeanStdTrainTestDataDT<-data.table(MeanStdTrainTestData)
MeanByGroup<-MeanStdTrainTestDataDT[,lapply(.SD,mean),by=list(Subject, Activity)]
```

