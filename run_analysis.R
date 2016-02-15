library(reshape2)

filename <- "getdata_dataset.zip"

if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, filename)
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}
# Setting directory to file with the data in my drive.
setwd("F:/Courses I am Studying (or soon)/MOOCS/Coursera/Hopkins Data Science Track/Getting Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

# Load activity labels + features
activityLabels <- read.table("activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

# Search for mean and standard deviation measurements
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

# Load datasets for train and test
train <- read.table("train/X_train.txt")[featuresWanted]
trainActivities <- read.table("train/Y_train.txt")
trainSubjects <- read.table("train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("test/X_test.txt")[featuresWanted]
testActivities <- read.table("test/Y_test.txt")
testSubjects <- read.table("test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)


# merge datasets and add labels
compltData <- rbind(train, test)
colnames(compltData) <- c("subject", "activity", featuresWanted.names)

# turn activities & subjects into factors
compltData$activity <- factor(compltData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
compltData$subject <- as.factor(compltData$subject)

compltData.melted <- melt(compltData, id = c("subject", "activity"))
compltData.mean <- dcast(compltData.melted, subject + activity ~ variable, mean)

summary(compltData.melted)
vars <- names(compltData)
cat(names1, file = "", sep = c("\n"), append = FALSE)
write.table(compltData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
