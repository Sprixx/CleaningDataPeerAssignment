README
========================================================

This is the **README.rmd** file as is required for the peer assignment.
This peer assignment is part of the **Cleaning and getting data** course from
**Coursera**.

In this markdown file I will describe how my script works. 
For more information about the original data set, the tidy data set, the variables and the reasoning behind the steps I took I refer to the **CodeBook.md** file which can also be found in this repository.

In the repository you will find this file, the **CodeBook.md** file and the **run_analysis.R** file in which the script for this assignment is. In this **README.md** file the script is also given but also more extended explanation on how it works. 

The **run_analysis.R** file is the script and should be run once placed in the same directory as the **UCI HAR Dataset folder**. The script is constructed in such a way that it will then load the data from this folder.

## Code ##
I will present my code in this file and also explain what happens at each step after a piece of code. 

    xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
    yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
    sTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

    xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
    yTest <- read.table("UCI HAR Dataset/test/y_test.txt")
    sTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
    
I start by reading 6 data files into R and assignment them to 6 variables. The datasets are the X, Y and 'subject' of both the test and training part of the data.
I use the `read.table` command and specify the path in which the files can be found.
This is a relative path to the current working directory the run_analysis.R file is stored.

    TotalTrain <- cbind(sTrain,yTrain,xTrain)

I continue by combining all the part of the training data set into one big training data set. I do this by column binding them together (`cbind`). I specifically started with the subject file, then the y file and last the x file. This way the data set wil start with a vector of subject IDs, next a vector of activities and finally a matrix with the measurement from the sensors of the smartphone.

    TotalTest <- cbind(sTest,yTest,xTest)
    
Exactly the same is done for the test set.
    

    TotalData <- data.frame(rbind(TotalTrain,TotalTest))
    
Next, I row bind the train and test set into one big matrix and convert this into a data frame using the `data.frame` function. I now have all the data merged into one file for which the first column consists of the subjects, the second column consists of the activitiy IDs and the other columns are the signalling from the sensors.
    
The second part of the assignment was to extract only the measurements from the data which correspond to the mean and standard deviation of the measurement.

Therefore I start by labelling the variables such that I can next filter the variables to end up with only the mean and standard deviation variables.

In order to name the variables I use the features.txt file which was provided with the data. In this file the variable names are included. For an explanation of the variable names I refer to the **CodeBook** file.
    
    Features <- data.frame(read.table("UCI HAR Dataset/features.txt"))
    
This features file is loaded similar to the previously loaded datasets.
    
    names(TotalData)[3:563] <- as.character(Features[,2])
    
The second column of the Features data set contains the names of the 561 variables in my total dataset. This is a factor and is therefore converted to a character vector using the `as.character` function. Next I set the names of my Dataset equal to this features vector. Before doing this I specify that only the 3rd untill the 563th element of the names of my data are set to the features vector. The first two variables names correspond to the subjects and activities and should be skipped when naming the variables using the features vector.
    
    MeanNrstmp <- as.numeric(grepl("mean",as.character(Features[,2])))
 
Next, I construct a numberic vector of 0's and 1's out of the same features columns. I do this using the `grepl` function and specify that only entries which contain the word *mean* should get a TRUE and all others should get a FALSE. This `grepl` function returns a logical vector which I next convert to a numeric vector (0's and 1's) using the `as.numeric` command.
 
    MeanFreqNrs <- as.numeric(grepl("meanFreq",as.character(Features[,2])))
 
Similarly I next construct a vector in which a 1 corresponds to a variables in which *meanFreq* was present and a 0 otherwise.
 
    #The subtraction of the meanNrstmp and MeanFreqNrs result in a vector which
    # only has 1s where 'mean' was present but not 'meanFreq'.
    MeanNrs <- MeanNrstmp-MeanFreqNrs
    
Subtracting these two vector (remember they are numeric) results in a vector which has a 1 on the position where *mean* was present but not also *meanFreq*. The resulting vector thus indicates which column numbers correspond to a 'mean-variables'.
    
    StdNrs <- as.numeric(grepl("std()",as.character(Features[,2])))

Next a similar vector is constructed for the 'std-variables'. 
 
    MeanandStdCols <- c(TRUE,TRUE,as.logical(MeanNrs+StdNrs))
    
Here I construct a logical vector. I do this by adding the previous two numeric vectors and since they are mutually exclusive (a variables cannot be a mean and std at the same time) I end up with a new vector of 0's and 1's where a 1 indicate a mean or a standard deviation. I convert this vector to a logical vector and concatenate two times 'TRUE'. THis vector will serve as selection method for the mean and standard deviation variables. The first two 'TRUE' entries are to make sure that I do not exclude the activities and subjects columns.

    MeanenStdData<-TotalData[,MeanandStdCols]

Here I take the subset of the data based on my logical vector I just constructed.

    names(MeanenStdData)[1:2]<-c("Subjects","Activities")

I furthermore specify the names of the first two columns and set these equal to 'subjects' and 'activities'. Now all columns are named. 
 
    ActivityData <- read.table("UCI HAR Dataset/activity_labels.txt")
    
Here the activity data is loaded from the activity_labels.txt file

    ActivityLevels <- as.factor(MeanenStdData$Activities)

The activity column from the main data frame is converted into a factor. This enables me to convert the levels of the factor to the new activity names.
 
    levels(ActivityLevels) <- as.character(ActivityData[,2])

In this step I convert the levels of the activity (1..6) into the names as specified from the acitivity data file.

    MeanenStdData[,2] <- as.character(ActivityLevels)

Next the activities data column in the data frame is replaced by the new activity labels which first have been converted in a character vector.
 
    install.packages("reshape2")
    library(reshape2)
    require(reshape2)
    
Now I install the 'reshape2' package, load this and make sure this is loaded using the `install.packages`, `library` and `require` commands.

    Melted <- melt(MeanenStdData, id=c("Subjects","Activities"))

Here I 'melt' the data using the `melt` command from the reshape2 package. I specify the subjects and activities columns to be id variables which is input for the `melt` command. The result is a dataset in which the data variables are 'rotated' into a variable column next to the original subjects and avticities columns. This is needed for the next step, the casting.
 
    Casted <- dcast(Melted, Subjects + Activities ~ variable, mean)

The melted data is reshaped using the `dcast` command which transforms the data into a new dataset. A function should be given from which the `dcast` command can interpret for which variables which function should be applied. It is specified that we should take the mean of the 'variable' column (a result of the melting) for each combination of subjects and activities. Resulting in the dataset we want.

    FinalData <- Casted

The casted dataset is renamed to FinalData

    FinalData
    
The FinalData set is printed to visually check the output.

    write.table(FinalData,"TidyDataSet.txt",row.names=F)
    
Lastly the data is written into a .txt file called 'TidyDataSet.txt' which is the file uploaded for the peer assignment.
    
This is the end of the **README** file, again I refer to the **CodeBook** file for information about the variables, the data and my reasoning.
    
    
