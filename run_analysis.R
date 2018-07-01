remove(list=ls())

setwd("C:/1JH/cleanData/week four/Course Project")


# 1.Merge the training and the test sets to create one data set.
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

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]

#  Extract mean and standard deviation of each measurements
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), features)
finalData <- fullData[, c(1, 2, featureIndex+2)]
colnames(finalData) <- c("subject", "activity", features[featureIndex])

# 3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
finalData$activity <- factor(finalData$activity, levels = activity_labels[,1], labels = activity_labels[,2])

# 4.Appropriately labels the data set with descriptive variable names.
names(finalData) <- gsub("\\()", "", names(finalData))
names(finalData) <- gsub("^t", "time", names(finalData))
names(finalData) <- gsub("^f", "frequence", names(finalData))
names(finalData) <- gsub("-mean", "Mean", names(finalData))
names(finalData) <- gsub("-std", "Std", names(finalData))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyData<-aggregate(. ~ subject + activity, finalData, mean)
tidyData<-tidyData[order(tidyData$subject,tidyData$activity),]

write.table(tidyData, "./tidayData.txt", row.names = FALSE)