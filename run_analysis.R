###This is the run_analysis R script for the peer assignment.
###This peer assignment is part of the 'getting and cleaning data' course 
### see Coursera.
###Before running this code it should be checked that the UCI HAR Dataset folder
### is in the same working directory as this run_analysis.R file is stored.


###The assignment:
###You should create one R script called run_analysis.R that does the following. 
###1. Merges the training and the test sets to create one data set.

#Read the x,y and subject component of the Train part of the data
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
sTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

#Read the x,y and subject component of the Test part of the data
xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")
sTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Combining all the components from the training set into a total training set
TotalTrain <- cbind(sTrain,yTrain,xTrain)

#Combining all the component from the test set into a total test set
TotalTest <- cbind(sTest,yTest,xTest)

#Combining the total train en test set into one total data set
TotalData <- data.frame(rbind(TotalTrain,TotalTest))

###2. Extracts only the measurements on the mean and 
### standard deviation for each measurement. 

###I start with naming the variables based on the features file before
###I can select only the mean and stdev variables

#Reading the features from the features file
Features <- data.frame(read.table("UCI HAR Dataset/features.txt"))

#Setting the names of the 561 variables using the features names
#Note that the first 2 names are skipped, this are the subject and y component
names(TotalData)[3:563] <- as.character(Features[,2])

#Construct a vector with 0's and 1's where 1's indicate that mean was
#present in the variable name
MeanNrstmp <- as.numeric(grepl("mean",as.character(Features[,2])))

#Since I decided to exclude the variables where meanFreq was included 
#a second vector is constructed to indicate where these were present (1's)
MeanFreqNrs <- as.numeric(grepl("meanFreq",as.character(Features[,2])))

#The subtraction of the meanNrstmp and MeanFreqNrs result in a vector which
# only has 1s where 'mean' was present but not 'meanFreq'.
MeanNrs <- MeanNrstmp-MeanFreqNrs

#Another vector of 0's and 1's is constructed to indicate where
# the std() variables are
StdNrs <- as.numeric(grepl("std()",as.character(Features[,2])))

#The StdNrs and MeanNrs vectors are added and converted to a logical vector
#two 'TRUE' entries are added for the subjects and activities columns (first 2)
MeanandStdCols <- c(TRUE,TRUE,as.logical(MeanNrs+StdNrs))

#The data is subsetted based on the logical vector (MeanandStdCols)
#This leaves only the variables with mean and std in it in addition to
#the subject and activity columns
MeanenStdData<-TotalData[,MeanandStdCols]

#The subject and activities column are labelled with their names
names(MeanenStdData)[1:2]<-c("Subjects","Activities")

###3.Uses descriptive activity names to name the activities in the data set
###4.Appropriately labels the data set with descriptive activity names. 

###The activities are renamed from 1...6 into the actual activities
###The names are determined from the content of the activity_label file

#Activity data is read from the activity_labels.txt file
ActivityData <- read.table("UCI HAR Dataset/activity_labels.txt")

#The activities from the main data set are converted into a factor
ActivityLevels <- as.factor(MeanenStdData$Activities)

#The levels of this factor (1...6) are next converted into new level names
#These level names are determined by the activity dataset
levels(ActivityLevels) <- as.character(ActivityData[,2])

#Lastly the activities column from the dataset is replaced by the
#new activities vector in which the names are included instead of the numbers
MeanenStdData[,2] <- as.character(ActivityLevels)

###5.Creates a second, independent tidy data set with the average 
###of each variable for each activity and each subject. 

#The reshape2 package is loaded ad required
install.packages("reshape2")
library(reshape2)
require(reshape2)

#The data is melted using the melt function from the reshape2 package
#It is specified that the subjects and activities are the ID's
Melted <- melt(MeanenStdData, id=c("Subjects","Activities"))

#Based on this melted data, the means are calculated for all variables
#The mean is calculated for each unique combination of subject and activity
Casted <- dcast(Melted, Subjects + Activities ~ variable, mean)

#The final data is determined and printed.
FinalData <- Casted

FinalData

#The final data is written to a .txt file.

write.table(FinalData,"TidyDataSet.txt",row.names=F)
