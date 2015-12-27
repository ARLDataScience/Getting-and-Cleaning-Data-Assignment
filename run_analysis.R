#Script for assignment to merge the training and tests sets to create one titled run_analysis.R 
#Need to setwd() to your data directory.  The one in this script is for my working directory.
	setwd("C:/Users/Alison/Documents/Data Science")
#Next load libraries: dplyr, tidyr, reshape, reshape2
library(dplyr)
library(tidyr)
#1 - Merge the data sets to create a single set
XtrainData <- read.table("./train/X_train.txt")
dim(XtrainData)
#
XtestData <- read.table("./test/X_test.txt")
dim(XtestData)
#
joinXData <- rbind(XtrainData, XtestData)
dim(joinXData)
#
ytrainData <- read.table("./train/y_train.txt")
dim(ytrainData)
#
ytestData <- read.table("./test/y_test.txt")
dim(ytestData)
#
joinYData <- rbind(ytrainData, ytestData)
dim(joinYData)
#30 subjects participating in activities 
subjecttrain <- read.table("./train/subject_train.txt")
dim(subjecttrain)
#
subjecttest <- read.table("./test/subject_test.txt")
dim(subjecttest)
#
joinsubject <- rbind(subjecttrain, subjecttest)
dim(joinsubject)
#
names(joinsubject) <- "Subject" 
#2 - Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table("./features.txt")
dim(features)
meanORstd <- grep("mean\\(\\)|std\\(\\)", features[, 2])
length(meanORstd)
#
joinXData <- joinXData[, meanORstd]
dim(joinXData)
#understanding the variable names
names(joinXData) <- gsub("\\(\\)", "", features[meanORstd, 2])
names(joinXData) <- gsub("^t", "time", names(joinXData))
names(joinXData) <- gsub("^f", "frequency", names(joinXData))
names(joinXData) <- gsub("Mag", "Magnitude", names(joinXData))
#3 - Place descriptive activity names to name the activities in the data set
activity_labels <- read.table("./activity_labels.txt")
activitylabel <- activity_labels[joinYData[, 1], 2]
joinYData[, 1] <- activitylabel # replace numerical representation with descriptive names
names(joinYData) <- "Activity" # adding column heading
#4 – Appropriately label the data set with descriptive variable names
complete_dataset <- cbind(joinsubject, joinYData, joinXData)
dim(complete_dataset)
#5 - Create an independent tidy data set with the average of each variable for each activity and each subject
library(reshape)
library(reshape2)
# 
complete_dataset_melt <- melt(complete_dataset, id = c("Subject", "Activity"))
dim(complete_dataset_melt)
tidy_data <- dcast(complete_dataset_melt, Subject + Activity ~ variable, mean)
dim(tidy_data)
#
write.table(tidy_data, file = "./Getting & Cleanning Data Assignment Tidy Data.txt")
