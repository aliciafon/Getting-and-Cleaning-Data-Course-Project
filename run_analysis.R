library(dplyr)


filename <- "getdata_dataset.zip"


## This step checks whether or not the archieve exist.
##The dataset must be downloaded and unzipped:
## Also, this is the data for the project.

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  
  download.file(fileURL, filename, method="curl")
  
}  


## This step checks to see if the folder exists


if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
  
}


## All data frames are assigned during this step.

features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt",)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")


colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')


## This step allows this R script to merge the training and the test sets into one data set. 

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)


## This step allows for the measurements on the mean and standard deviation for each measurement to be extracted.


TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))


## The activities in the data set are named with descriptive activty names. 


TidyData$code <- activities[TidyData$code, 2]


## The data set is properly labeled with descriptive variable names.


nms(TyDa)[2] = "activity"
nms(TyDa)<-gsub("Acc", "Accelerometer", nms(TyDa))
nms(TyDa)<-gsub("Gyro", "Gyroscope", nms(TyDa))
nms(TyDa)<-gsub("BodyBody", "Body", nms(TyDa))
nms(TyDa)<-gsub("Mag", "Magnitude", nms(TyDa))
nms(TyDa)<-gsub("^t", "Time", nms(TyDa))
nms(TyDa)<-gsub("^f", "Frequency", nms(TyDa))
nms(TyDa)<-gsub("tBody", "TimeBody", nms(TyDa))
nms(TyDa)<-gsub("-mean()", "Mean", nms(TyDa), ignore.case = TRUE)
nms(TyDa)<-gsub("-std()", "STD", nms(TyDa), ignore.case = TRUE)
nms(TyDa)<-gsub("-freq()", "Frequency", nms(TyDa), ignore.case = TRUE)
nms(TyDa)<-gsub("angle", "Angle", nms(TyDa))
nms(TyDa)<-gsub("gravity", "Gravity", nms(TyDa))


## A second tidy data set is produced separatly from the data set in the previous step. 
## In the newly created data set is the average of each variable for each activity and each subject.


FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
