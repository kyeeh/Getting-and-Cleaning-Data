# Getting and Cleaning Dara Project

# Start with file uploading
activities <- read.table("data/UCI\ HAR\ Dataset/activity_labels.txt")
colnames(activities) <- c("id","activity")

# Features loading and Column Names set
features <- read.table("data/UCI\ HAR\ Dataset/features.txt")
colnames(features) <- c("id","features")

# Testing data loading and Column Names set
testing_set <- read.table("data/UCI\ HAR\ Dataset/test/X_test.txt")
colnames(testing_set) <- features$features
testing_labels <- read.table("data/UCI\ HAR\ Dataset/test/Y_test.txt")
colnames(testing_labels) <- c("activity_id")
subject_test <- read.table("data/UCI\ HAR\ Dataset/test/subject_test.txt")
colnames(subject_test) <- c("subject")
testing <- cbind(subject_test,testing_labels,testing_set)

# Training data loading and Column Names set
training_set <- read.table("data/UCI\ HAR\ Dataset/train/X_train.txt")
colnames(training_set) <- features$features
training_labels <- read.table("data/UCI\ HAR\ Dataset/train/Y_train.txt")
colnames(training_labels) <- c("activity_id")
subject_train <- read.table("data/UCI\ HAR\ Dataset/train/subject_train.txt")
colnames(subject_train) <- c("subject")
training <- cbind(subject_train,training_labels,training_set)

# Cleaning Memory
remove(training_labels,training_set,testing_labels,testing_set,features,subject_train,subject_test)

# merging data frames
df <- rbind(testing,training)
# remove(testing,training)

# Using descriptive activity names in Dataset
df <- merge(activities,df,by.x="id",by.y="activity_id",all=TRUE)
df <- subset(df,select=-c(1))

# Selecting Mean and Standart Deviation for each measurement
df1 <- df[,c(3,2,grep("mean[[:punct:]]|std[[:punct:]]",names(df)))]

# Preparing Output file
mdata <- melt(df,id=c("subject","activity"))
df2 <- cast(mdata, subject ~ activity ~ variable, mean)
write.table(df2,"data/UCI\ HAR\ Dataset/output.txt",row.name=FALSE)
