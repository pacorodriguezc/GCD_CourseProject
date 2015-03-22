library("dplyr")

setwd("~/Development/R/GettingAndCleanningData/UCI HAR Dataset/")

subjectTest <- read.table("./test/subject_test.txt")
xTest <- read.table("./test/X_test.txt")
yTest <- read.table("./test/y_test.txt")
subjectTrain <- read.table("./train/subject_train.txt")
xTrain <- read.table("./train/X_train.txt")
yTrain <- read.table("./train/y_train.txt")
activities <- read.table("./activity_labels.txt")
subjectMerged <- rbind(subjectTest, subjectTrain)

# Merges the training and the test sets to create one data set.
xMerged <- rbind(xTest, xTrain)
yMerged <- rbind(yTest, yTrain)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("./features.txt")
featVect <- grepl("std()", features[,2]) | grepl("mean()", features[,2])
labels <- activities[yMerged[1:nrow(yMerged),],2]


oneDataSet <- xMerged[,featVect]
oneDataSet <- cbind(subjectMerged, labels, oneDataSet)

# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
names(oneDataSet) <- c("subject", "activities", as.character(features[featVect,2]))

# creates a second, independent tidy data set with the average of each variable for each activity and each subject.
by_sa <- oneDataSet %>% group_by(subject, activities)
result <- by_sa %>% summarise_each(funs(mean))

write.table(result, "./result.txt", row.names = FALSE)
