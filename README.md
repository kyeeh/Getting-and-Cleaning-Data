Project for Getting and Cleaning Data
=====================================
Author: Ricardo Gutiérrez (https://github.com/kyeeh/Getting-and-Cleaning-Data)


Parameters for the project
--------------------------

> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
> 
> One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
> 
> http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
> 
> Here are the data for the project: 
> 
> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
> 
> You should create one R script called run_analysis.R that does the following. 
> 
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. Uses descriptive activity names to name the activities in the data set.
> 4. Appropriately labels the data set with descriptive activity names.
> 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
> 
> Good luck!


Steps to reproduce this project
-------------------------------

1. Open the R script `run_analysis.r` using a text editor.
2. Set your workspce with `setwd` function using your working directory as parameter (i.e., the folder where these the R script file is saved).
3. Run the R script `run_analysis.r`.


Outputs produced
----------------
Tidy dataset file `output.txt` (tab-delimited text)

Analysis Descripiton
--------------------

* Call libraries and set workspace.   
```
library("reshape2")  
setwd("~/Documents/Coursera/dss/workspace/Getting-and-Cleaning-Data")
```

* Read Input files for subjects, activities and features, in the process descriptive names are defined for columns if apply.    
```
activities <- read.table("UCI\ HAR\ Dataset/activity_labels.txt")
colnames(activities) <- c("id","activity")
```
* Features loading and Column Names set.  
```
features <- read.table("UCI\ HAR\ Dataset/features.txt")
colnames(features) <- c("id","features")
```
* Testing data loading and Column Names set.  
```
testing_set <- read.table("UCI\ HAR\ Dataset/test/X_test.txt")
colnames(testing_set) <- features$features
testing_labels <- read.table("UCI\ HAR\ Dataset/test/Y_test.txt")
colnames(testing_labels) <- c("activity_id")
subject_test <- read.table("UCI\ HAR\ Dataset/test/subject_test.txt")
colnames(subject_test) <- c("subject")
testing <- cbind(subject_test,testing_labels,testing_set)
```
* Training data loading and Column Names set.  
```
training_set <- read.table("UCI\ HAR\ Dataset/train/X_train.txt")
colnames(training_set) <- features$features
training_labels <- read.table("UCI\ HAR\ Dataset/train/Y_train.txt")
colnames(training_labels) <- c("activity_id")
subject_train <- read.table("UCI\ HAR\ Dataset/train/subject_train.txt")
colnames(subject_train) <- c("subject")
training <- cbind(subject_train,training_labels,training_set)
```

* Cleaning Memory.  
```
remove(training_labels,training_set,testing_labels,testing_set,features,subject_train,subject_test)
```

* Merging input data frames.  
```
df <- rbind(testing,training)
remove(testing,training)
```
* Set descriptive activity names in Dataset.  
```
df <- merge(activities,df,by.x="id",by.y="activity_id",all=TRUE)
df <- subset(df,select=-c(1))
```

* Selecting Mean and Standart Deviation for each measurement.  
```
df <- df[,c(1,2,grep("mean[[:punct:]]|std[[:punct:]]",names(df)))]
```

* Reshaping output.  
```
mdata <- melt(df,id=c("subject","activity"))
output <- dcast(mdata, subject + activity ~ variable, mean)
```

* Writing Output file.  
```
write.table(output,"output.txt",row.name=FALSE,sep="\t")
```