library(dplyr)

# read data
X_train <- read.table("C:/Users/natal/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
Y_train <- read.table("C:/Users/natal/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt", quote="\"", comment.char="")
subtrain <- read.table("C:/Users/natal/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")

X_test <- read.table("C:/Users/natal/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
Y_test <- read.table("C:/Users/natal/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt", quote="\"", comment.char="")
subtest <- read.table("C:/Users/natal/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")

variable_name <- read.table("C:/Users/natal/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt", quote="\"", comment.char="")

activity_labels <- read.table("C:/Users/natal/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")


## 1. Merges the training and the test sets to create one data set.

x_total <- rbind(X_train, X_test)
y_total <- rbind(Y_train, Y_test)
subtotal <- rbind(subtrain, subtest)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

variables <- variable_name[grep("mean\\(\\)|std\\(\\)",variable_name[,2]),]
x_total <- x_total[,variables[,1]]


## 3. Uses descriptive activity names to name the activities in the data set

colnames(y_total) <- "activity"
y_total$activitylabel <- factor(y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y_total[,-1]


## 4. Appropriately labels the data set with descriptive variable names. 

colnames(x_total) <- variable_name[variables[,1],2]


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

colnames(subtotal) <- "subject"
total <- cbind(x_total, activitylabel, subtotal)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "C:/Users/natal/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

