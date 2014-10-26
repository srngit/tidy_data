## This script analyses the UCI Har data set

## ------------Part 1----------------------------------
## Rading the 'train' data set 
subject_train <- read.table("./train/subject_train.txt")
x_train <- read.table("./train/x_train.txt")
y_train <- read.table("./train/y_train.txt")

## keeping all train data in one table
train <- cbind(subject_train,y_train,x_train)

## Rading the 'test' data set 
subject_test <- read.table("./test/subject_test.txt")
x_test <- read.table("./test/x_test.txt")
y_test <- read.table("./test/y_test.txt")

## keeping all test data in one table
test <- cbind(subject_test,y_test,x_test)

## merging the test and train data into one
exp_data <- rbind(train,test)

## setting the names(columns) of the merged data
features <- read.table("features.txt")
names(exp_data) <- c("Subject","Activity",as.character(features$V2))

## writing the merged data into a text file 
##writefile <- write.table(exp_data, file="exp_data_merged.txt",sep=" ")

## ------------Part 2----------------------------------
##Extracts only the measurements on the mean and standard deviation for each measurement. 

Extract <- c("Subject","Activity", "mean","std")
Extracted_data <- exp_data[, grepl(paste(Extract,collapse="|"),names(exp_data))]

## ------------Part 3----------------------------------
## Uses descriptive activity names to name the activities in the data set
Activity_list <- read.table("activity_labels.txt")
AL <- Activity_list$V2
n <- nrow(Activity_list)
for (i in 1:n) {
Extracted_data$Activity <- replace(Extracted_data$Activity,Extracted_data$Activity==i, as.character(AL[i]))
}

## ------------Part 4----------------------------------
## Appropriately labels the data set with descriptive variable names
names(Extracted_data)

## ------------Part 5----------------------------------
## creates a second, independent tidy data set with the average of each variable... 
## ...for each activity and each subject.

## melt and dcast functions are used to create a a tidy data from the previously created extracted data.
library(reshape2)
measured_cols <- names(Extracted_data)[3:81]
tidy_data <- melt(Extracted_data, id=c("Subject","Activity"), measure.vars=measured_cols)
dcast_data <- dcast(tidy_data,Subject ~ Activity, mean)
writefile <- write.table(dcast_data, file="Final_tidy_data.txt",sep=" ",row.name=FALSE)

