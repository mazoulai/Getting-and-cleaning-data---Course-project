## Read Test Files (data set, subject, activities)
test.set <- read.table("test/X_test.txt")
test.subject <- read.table("test/subject_test.txt", col.names = "subject")
test.activity <- read.table("test/y_test.txt", col.names = "activity")

## Combine Test files in one table
test <- cbind(test.subject,test.activity,test.set)

## Read Training files (data set, subject, activities)
training.set <- read.table("train/X_train.txt")
training.subject <- read.table("train/subject_train.txt", col.names = "subject")
training.activity <- read.table("train/y_train.txt", col.names = "activity")

## Combine Training files in one table
training <- cbind(training.subject,training.activity,training.set)

## Merge training and tests set
data.set <- rbind(test,training)

## Label the data set with descriptive, valid, and unique variable names
features <- read.table("features.txt", stringsAsFactors = FALSE)
valid_column_names <- make.names(names=features[,2], unique=TRUE, allow_ = TRUE)
names(data.set)[-c(1,2)] <- valid_column_names

## Select only standard deviation and mean measurements
library(dplyr)
data.set <- select(data.set, matches("subject"), matches("activity"),
                 contains(".mean.."), contains( ".std.."))

## Use descriptive names to name the activities
data.set$activity<-as.factor(data.set$activity)
levels(data.set$activity) <- c("Walking","Walking_Upstairs", "Walking_Downstairs",
                              "Sitting", "Standing", "Laying")

## Create a second data set with the averages of each variable for each activity and each subject:
library(reshape2)
        ## Create a new variable with both the subject and the activity. 
        ## Create a new data set with this new variable instead of the 2 separate  
        ## subject and activity variables
        subject.and.activity <- paste(data.set$subject,data.set$activity, sep=",")
        data.set2 <-cbind(subject.and.activity,data.set[,-c(1,2)])

        ## Melt the new dataset (wit ID being "subject.and.activity") and calculate the average 
        ## of each variable for a given "subject.and.activity"
        data.melt<-melt(data.set2,id="subject.and.activity")
        final.set <- dcast(data.melt, subject.and.activity ~ variable, mean)

## Write final data set into text file:
write.table(final.set,"final_set.txt",row.name=FALSE)

