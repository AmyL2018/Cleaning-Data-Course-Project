---
title: "Getting and Cleaning Data Course Project"

output: 
  html_document:
    keep_md: true
    self_contained: true
---
>The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

>One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

>http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

>Here are the data for the project:

>https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

>This project should create one R script called run_analysis.R that does the following:

>    1.Merges the training and the test sets to create one data set.
>    2.Extracts only the measurements on the mean and standard deviation for each measurement.
>    3.Uses descriptive activity names to name the activities in the data set
>    4.Appropriately labels the data set with descriptive variable names.
>    5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

>    Requirements have been fulfilled as described in this file


```r
remove(list=ls())

setwd("C:/Users/liuyi/Documents/1JH/cleanData/week four/Course Project")
```

** 1.Merge the training and the test sets to create one data set.**


```r
if(!file.exists("./data")) dir.create("./data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/projectData_getCleanData.zip")

listZip <- unzip("./data/projectData_getCleanData.zip", exdir = "./data")
train_x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
test_x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

trainData <- cbind(train_subject, train_y, train_x)
testData <- cbind(test_subject, test_y, test_x)
fullData <- rbind(trainData, testData)
```

** 2. Extract only the measurements on the mean and standard deviation for each measurement.** 


```r
features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
```

**  Extract mean and standard deviation of each measurements**


```r
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), features)
finalData <- fullData[, c(1, 2, featureIndex+2)]
colnames(finalData) <- c("subject", "activity", features[featureIndex])
```

** 3. Uses descriptive activity names to name the activities in the data set**


```r
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
finalData$activity <- factor(finalData$activity, levels = activity_labels[,1], labels = activity_labels[,2])
```

** 4.Appropriately labels the data set with descriptive variable names.**


```r
names(finalData) <- gsub("\\()", "", names(finalData))
names(finalData) <- gsub("^t", "time", names(finalData))
names(finalData) <- gsub("^f", "frequence", names(finalData))
names(finalData) <- gsub("-mean", "Mean", names(finalData))
names(finalData) <- gsub("-std", "Std", names(finalData))
```

** 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.**


```r
tidyData<-aggregate(. ~ subject + activity, finalData, mean)
tidyData<-tidyData[order(tidyData$subject,tidyData$activity),]

write.table(tidyData, "./tidayData.txt", row.names = FALSE)
```

