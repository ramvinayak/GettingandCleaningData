library(reshape2)
library(plyr)

#extract the activity and features required 

activityLabels <- read.table("activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
featuresList <- read.table("features.txt")
featuresList[,2] <- as.character(featuresList[,2])


#extract the mean and standard deviation 

requiredFeatures <- grep(".*mean.*|.*std.*", featuresList[,2])
requiredFeatures.names <- featuresList[requiredFeatures,2]
requiredFeatures.names = gsub('-mean', 'Mean', requiredFeatures.names)
requiredFeatures.names = gsub('-std', 'Std', requiredFeatures.names)
requiredFeatures.names <- gsub('[-()]', '', requiredFeatures.names)

# Load the train datasets

setwd("./train")
trainData <- read.table("X_train.txt")[requiredFeatures]
trainActivities <- read.table("Y_train.txt")
trainSubjects <- read.table("subject_train.txt")
trainData <- cbind(trainSubjects, trainActivities, trainData)

# Load the test datasets

setwd("../test")
testData <- read.table("X_test.txt")[requiredFeatures]
testActivities <- read.table("Y_test.txt")
testSubjects <- read.table("subject_test.txt")
testData <- cbind(testSubjects, testActivities, testData)

# Merge test and train data sets 

mergeData <- rbind(trainData, testData)
colnames(mergeData) <- c("subject", "activity", requiredFeatures.names)


#creating the tidy dataset
setwd("../")
tidyData <- ddply(mergeData, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(tidyData, "tidy.txt", row.name=FALSE)
