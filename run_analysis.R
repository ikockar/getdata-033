#The purpose of this project is to demonstrate your ability to collect, work with, 
#and clean a data set. The goal is to prepare tidy data that can be used for later 
#analysis. You will be graded by your peers on a series of yes/no questions related 
#to the project. You will be required to submit: 1) a tidy data set as described below, 2)
#a link to a Github repository with your script for performing the analysis, and 3)
#a code book that describes the variables, the data, and any transformations or work
#that you performed to clean up the data called CodeBook.md. You should also include 
#a README.md in the repo with your scripts. This repo explains how all of the scripts 
#work and how they are connected. 

#One of the most exciting areas in all of data science right now is wearable computing - 
#see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing 
#to develop the most advanced algorithms to attract new users. The data linked to from 
#the course website represent data collected from the accelerometers from the Samsung 
#Galaxy S smartphone. A full description is available at the site where the data was obtained:
    
#    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#Here are the data for the project:
    
#    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


#You should create one R script called run_analysis.R that does the following. 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for each activity and each subject.

# set path to directory with datasets
setwd("./UCI HAR Dataset")

#read activity labels
activity_labels <- read.table("activity_labels.txt")

#read features labels
features <- read.table("features.txt")

#read data files from test directory
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

#read data files from train directory
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

#Merge datasets
x_merge <- rbind(X_train, X_test)
y_merge <- rbind(y_train, y_test)
subject_merge <- rbind(subject_train, subject_test)

#Subset mean and std
extract <- grep("mean\\(\\)|std\\(\\)", features$V2)
x_merge_subset <- x_merge[,extract]

#new names for columns
names(activity_labels) <- c('activity_id', 'activity_name')
y_merge[,1] = activity_labels[y_merge[,1],2]
names(y_merge)="Activity"
names(subject_merge)="Subject"
names(x_merge_subset)=gsub("\\(|\\)", "", (features[extract, 2]))

#merge all
combined_data <- cbind(subject_merge,y_merge,x_merge_subset)

#calculating average
avg_data <- aggregate(.~Subject+Activity,combined_data,mean)

#write data into file
write.table(avg_data,file="./tidy_avg_data.txt")