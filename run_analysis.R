## Author: Ricardo Gutiérrez (https://github.com/kyeeh/Getting-and-Cleaning-Data)
## Run Analysis script

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Getting and Cleaning Dara Project
# Created at: 09/11/2014

# Libraries & workspace
library("reshape2")
setwd("~/Documents/Coursera/dss/workspace/Getting-and-Cleaning-Data")

# Start with file uploading
activities <- read.table("UCI\ HAR\ Dataset/activity_labels.txt")
colnames(activities) <- c("id","activity")

# Features loading and Column Names set
features <- read.table("UCI\ HAR\ Dataset/features.txt")
colnames(features) <- c("id","features")

# Testing data loading and Column Names set
testing_set <- read.table("UCI\ HAR\ Dataset/test/X_test.txt")
colnames(testing_set) <- features$features
testing_labels <- read.table("UCI\ HAR\ Dataset/test/Y_test.txt")
colnames(testing_labels) <- c("activity_id")
subject_test <- read.table("UCI\ HAR\ Dataset/test/subject_test.txt")
colnames(subject_test) <- c("subject")
testing <- cbind(subject_test,testing_labels,testing_set)

# Training data loading and Column Names set
training_set <- read.table("UCI\ HAR\ Dataset/train/X_train.txt")
colnames(training_set) <- features$features
training_labels <- read.table("UCI\ HAR\ Dataset/train/Y_train.txt")
colnames(training_labels) <- c("activity_id")
subject_train <- read.table("UCI\ HAR\ Dataset/train/subject_train.txt")
colnames(subject_train) <- c("subject")
training <- cbind(subject_train,training_labels,training_set)

# Cleaning Memory
remove(training_labels,training_set,testing_labels,testing_set,features,subject_train,subject_test)

# merging data frames
df <- rbind(testing,training)
remove(testing,training)

# Using descriptive activity names in Dataset
df <- merge(activities,df,by.x="id",by.y="activity_id",all=TRUE)
df <- subset(df,select=-c(1))

# Selecting Mean and Standart Deviation for each measurement
df <- df[,c(1,2,grep("mean[[:punct:]]|std[[:punct:]]",names(df)))]

# Reshaping output
mdata <- melt(df,id=c("subject","activity"))
output <- dcast(mdata, subject + activity ~ variable, mean)

# Writing Output file
write.table(output,"output.txt",row.name=FALSE,sep="\t")