# 1. Merges the training and the test sets to create one data set.
# read train data
var561TrainPath<-"./Rdata/UCI HAR Dataset/train/X_train.txt"
var561TrainData<-read.table(var561TrainPath,sep="", header=F)

SubjectTrainPath<-"./Rdata/UCI HAR Dataset/train/subject_train.txt"
SubjectTrain<-read.table(SubjectTrainPath, sep="", header=F)
var561TrainData<-cbind(SubjectTrain$V1,var561TrainData)

activityTrainPath<-"./Rdata/UCI HAR Dataset/train/y_train.txt"
activityTrainData<-read.table(activityTrainPath, sep="", header=F)
var561TrainData<-cbind(activityTrainData$V1, var561TrainData)

# read test data
var561TestPath<-"./Rdata/UCI HAR Dataset/test/X_test.txt"
var561TestData<-read.table(var561TestPath,sep="", header=F)

SubjectTestPath<-"./Rdata/UCI HAR Dataset/test/subject_test.txt"
SubjectTest<-read.table(SubjectTestPath, sep="", header=F)
var561TestData<-cbind(SubjectTest$V1,var561TestData)

activityTestPath<-"./Rdata/UCI HAR Dataset/test/y_test.txt"
activityTestData<-read.table(activityTestPath, sep="", header=F)
var561TestData<-cbind(activityTestData$V1, var561TestData)

# Merge Train data and Test data
colnames(var561TrainData)[1:2]<-c("Activity","Subject")
colnames(var561TestData)[1:2]<-c("Activity","Subject")
TrainTestData<-rbind(var561TrainData,var561TestData)


# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
var561headerPath<-"./Rdata/UCI HAR Dataset/features.txt"
var561header<-read.table(var561headerPath, sep="",header=F)

MeanStdIndex<-grep("mean|std", var561header$V2)
MeanStdTrainTestData<-TrainTestData[,c(1:2,MeanStdIndex+2)]


# 3. Uses descriptive activity names to name the activities in the data set
activityNamePath<-"./Rdata/UCI HAR Dataset/activity_labels.txt"
activityName<-read.table(activityNamePath, sep="", header=F)
activityName$V2<-as.character(activityName$V2)

MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==1] <- activityName$V2[1]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==2] <- activityName$V2[2]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==3] <- activityName$V2[3]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==4] <- activityName$V2[4]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==5] <- activityName$V2[5]
MeanStdTrainTestData$Activity[MeanStdTrainTestData$Activity==6] <- activityName$V2[6]

# 4.Appropriately labels the data set with descriptive variable names. 
MeanStdHeader<-as.character(var561header$V2[MeanStdIndex])
colnames(MeanStdTrainTestData)[3:81]<-MeanStdHeader


# 5.From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.

MeanStdTrainTestDataDT<-data.table(MeanStdTrainTestData)
MeanByGroup<-MeanStdTrainTestDataDT[,lapply(.SD,mean),by=list(Subject, Activity)] 





