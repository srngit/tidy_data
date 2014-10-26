###	run_analsys.R
####	How the Script works

This README.md explains how the script works.

This script analyses the UCI Har data set - containing the results of the tests conducted on the 'Subjects' 
i.e. the pesons on whom the experiments have been conducyed 

There are 30 Subjects who have been randomly divided into two groups - namely 'train' and 'test'.   
There are total 561 features on which experimental results are observed on each Subject while they were each of the 6 Activities. 

###	Part 1
The First part of the script reads the "train" data set using the read.table function
There are three tables in the data avaiable for "train" data set.

1. subject_train: contaning the list of 21 Subjects who have been randomly grouped under 'train', with 7352 observations.    
2. x_train 	: containing 7352 observations(results) on 561 varaibles (features)  
3. y_train 	: containing the list of all the Activities with 7352 observations matching the number of observations in x_train  

The following code reads the data in the above three data sets. 

``` 
subject_train <- read.table("./train/subject_train.txt")
x_train <- read.table("./train/x_train.txt")
y_train <- read.table("./train/y_train.txt")

```
The data is merged using a cbind function, to keep all train data in one table

```
train <- cbind(subject_train,y_train,x_train)

```

Similarly, the following 'test' data set related files are read and merged into a single data set. 

1. Subject_test	: contaning the list of 9 Subjects who have been randomly grouped under 'train', with 2947 observations    
2. x_test 	: containing 2947 observations(results) on 561 varaibles (features)  
3. y_test 	: containing the list of all the Activities with 7352 observations matching the number of observations in x_train  

The following code reads the data in the above three data sets.

```
subject_test <- read.table("./test/subject_test.txt")
x_test <- read.table("./test/x_test.txt")
y_test <- read.table("./test/y_test.txt")

```
The data is merged using a cbind() function, to keep all train data in one table

```
test <- cbind(subject_test,y_test,x_test)

```

The two data sets are merged, using the following code 

```
exp_data <- rbind(train,test)

```

The merged data set does not have column names. The folowing code sets the names. 

```
features <- read.table("features.txt")
names(exp_data) <- c("Subject","Activity",as.character(features$V2))

```


###	Part 2 

This part extracts only the measurements on the mean and standard deviation. The following code reduces the 561 variables to 78 relavant variables that have mean and median 

```
Extract <- c("Subject","Activity", "mean","std")
Extracted_data <- exp_data[, grepl(paste(Extract,collapse="|"),names(exp_data))]

```

### 	Part 3

This part relpaces the Activity codes with Activity names. This is obtained by using the replace() function

```
Activity_list <- read.table("activity_labels.txt")
AL <- Activity_list$V2
n <- nrow(Activity_list)
for (i in 1:n) {
Extracted_data$Activity <- replace(Extracted_data$Activity,Extracted_data$Activity==i, as.character(AL[i]))
}

```

### 	Part 4

Since the column names have been already set in Part 1, there is no need to repeat this step.
 

###	Part 5 

This part creates a second, independent tidy data set with the average of each variable for each activity and each subject, using 
melt() and dcast() functions.

The following code creates a tidy data set and writes into a file named - Final_tidy_data.txt.  

```
library(reshape2)
measured_cols <- names(Extracted_data)[3:81]
tidy_data <- melt(Extracted_data, id=c("Subject","Activity"), measure.vars=measured_cols)
dcast_data <- dcast(tidy_data,Subject ~ Activity, mean)
writefile <- write.table(dcast_data, file="Final_tidy_data.txt",sep=" ",row.name=FALSE)

``` 
The file contains 30 observations, each pertaining to one Subject, and each variable (column) giving 
the average of the results on all 79 features(having mean and average) while the Subject was performing a particular Activity. 
There are 6 columns pertaining to 6 Activities.     