CodeBook
========================================================

This is the **CodeBook.rmd** file as is required for the peer assignment.
This peer assignment is part of the **Cleaning and getting data** course from
**Coursera**.

In this markdown file I will describe the original data, the resulting tidy
data set, all variables and all the transformations and work I have performed to clean up the original data.

### Original data ###

I will start by describing the original data set.

The data is called **Human Activity Recognition Using Smartphones Dataset**
and I reference the following publication:

>*[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*


It concerns data collected from smartphone's inertial sensors while being carried
by 30 subjects which were performing daily activities such as walking, standing and sitting.



The following is cited from the original data description as found in the README:

>*The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.*

>*The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.*

>*For each record it is provided:*

>*- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.*
>*- Triaxial Angular velocity from the gyroscope.*
>*- A 561-feature vector with time and frequency domain variables.* 
>*- Its activity label.* 
>*- An identifier of the subject who carried out the experiment.*

The data folder contained different files which I will shortly discuss:

- README.txt

This is a README file in which explanation is given about the data. Part of this is already cited above. Furthermore also a list of files is specified in here.

- featuresinfo

In this file an extended explanation about the features is given. In here it is specified how the variable names are constructed and what they mean. More on this in the **Variables** chapter.

- features.txt

This is a list of all the features (variables). This is used in the script to name the variables according to their order in this file.


- activity_labels

This is a list of all the activities (Walking etc). This is used as mapping between the activity number and the activity description in the script.

Furthermore the data contains two subfolders names 'train' and 'test'.
As specified in the README, these correspond to two partions of the total dataset.
One of the datasets contains 70% of the data and the other contains the other 30%.

My reasoning is that they have split this for machine learning purposes. They have specified a training test, on which the algorithm can be calibrated and later an test set to test the performance of the model on 'out-of-sample' data.
Both data part originally originate from one large data set.


In both these folders there are 3 files: X\_Train and Y\_Train and Subject\_Train and similar for the test set. (so a total of 6 files).

In the X part of the data the preprocessed data from the sensors in included. A list of 561 variables is included with all numeric values.

In the Y part of the data only a vector of the activities is included. So a numeric vector of 1's,2's.. and 6's. These correspond to the activities like Walking etc.

My reasoning would be that this is the feature that the machine learning algorithm should be able to 'predict' once the model is finished. So the X data is used as input and the result should be the Y. This way your phone is able to identify which activity you are currently doing by applying the algorithm to the sensor measurements.

The subject part of the data contains numeric values from 1 to 30. This are the subjects used to generate this data. The volunteers for this research.

Furthermore there are two folders (in the train and test folder) called inertial signals. This is the raw data from the sensors from the smartphone.
My reasoning is that the processed data is also given, in the previous discussed files which justifies ignoring the inertial signal raw data.


### Tidy Data Set ###

The resulting data set from the script is the Tidy data set as also handed in for the peer assignment. This is the result of the assignment:

 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive activity names. 
 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

The resulting data set can be found in the **TidyDataSet.txt** file. It contains 180 rows and 68 columns. 
The rows are determined by the combinations of subjects and activities `30*6=180`.
The number of columns is determined by a **Subject** Column, a **Activity** Column and 66 data columns each representing a different variable. 

This corresponds to the second indepenent tidy data set as specified in the description. After the merging and renaming already a tidy data set was constructed, however the description asked to construct another dataset with the average of each variable for each activity and each subject.
My reasoning was that this latter dataset should be uploaded as tidy data set.
The previous dataset is also constructed within my code and used as input to construct the second tidy data set. 

I have furthermore concluded that the means of the latter data set should have been constructed for each combination of activity and subject and not for each acitivity separately and each subject separately. This thus is the way I have constructed the final Tidy data set.

### Variables ###
Below (at the end of this section) are given all the variables in the final (second) tidy data set

The first variable "subjects" is a numeric vector containing numeric (integer) values ranging from 1 to 30. They correspond to the subject ID, making it possible to distinguish between subject.

The second variable "Activities" is a character vector containing the activites (in words). This variable indicates the activity the subject was doing.
All possible activities:

- WALKING
- WALKING_UPSTAIRS
- WALKING_DOWNSTAIRS
- SITTING
- STANDING
- LAYING

All other variables have structured names which I will explain from which the meaning of all variables can be derived.
Furtermore I have to note that all variables have numeric entries which are between -1 and 1.

The 't' indicites that indicates time domain signals.

The 'f' indicates that a Fast Fourier Transformation has been applied.

'Acc' indicates data from the accelerometer

'Gyro' indiciates data from the gyroscope

'Body' indicates that the signal is the body acceleration signal which is a separation of the total signal after applying a filter

'Gravity' indicates that the signal is the gravity acceleration signal which is a separaten of the total signal after applying a filter

'Mag' indicates magnitude of the signal which is calculated using the euclideon norm

'Jerk' indicates that this concerns a jerk signal which is derived from the linear acceleration and the anglular velocity

'-X' indicates a signal in the X direction

'-Y' indicates a signal in the Y direction

'-Z' iddicates a signal in the Z direction

'mean()' indicates that this concerns the mean value

'std()' indicaites that this concerns the standard deviation


- [1] "Subjects"
- [2] "Activities"                 
- [3] "tBodyAcc-mean()-X"          
- [4] "tBodyAcc-mean()-Y"          
- [5] "tBodyAcc-mean()-Z"          
- [6] "tBodyAcc-std()-X"           
- [7] "tBodyAcc-std()-Y"           
- [8] "tBodyAcc-std()-Z"           
- [9] "tGravityAcc-mean()-X"       
- [10] "tGravityAcc-mean()-Y"       
- [11] "tGravityAcc-mean()-Z"       
- [12] "tGravityAcc-std()-X"        
- [13] "tGravityAcc-std()-Y"        
- [14] "tGravityAcc-std()-Z"        
- [15] "tBodyAccJerk-mean()-X"      
- [16] "tBodyAccJerk-mean()-Y"      
- [17] "tBodyAccJerk-mean()-Z"      
- [18] "tBodyAccJerk-std()-X"       
- [19] "tBodyAccJerk-std()-Y"       
- [20] "tBodyAccJerk-std()-Z"       
- [21] "tBodyGyro-mean()-X"         
- [22] "tBodyGyro-mean()-Y"         
- [23] "tBodyGyro-mean()-Z"         
- [24] "tBodyGyro-std()-X"          
- [25] "tBodyGyro-std()-Y"          
- [26] "tBodyGyro-std()-Z"          
- [27] "tBodyGyroJerk-mean()-X"     
- [28] "tBodyGyroJerk-mean()-Y"     
- [29] "tBodyGyroJerk-mean()-Z"     
- [30] "tBodyGyroJerk-std()-X"      
- [31] "tBodyGyroJerk-std()-Y"      
- [32] "tBodyGyroJerk-std()-Z"      
- [33] "tBodyAccMag-mean()"         
- [34] "tBodyAccMag-std()"          
- [35] "tGravityAccMag-mean()"      
- [36] "tGravityAccMag-std()"       
- [37] "tBodyAccJerkMag-mean()"     
- [38] "tBodyAccJerkMag-std()"      
- [39] "tBodyGyroMag-mean()"        
- [40] "tBodyGyroMag-std()"         
- [41] "tBodyGyroJerkMag-mean()"    
- [42] "tBodyGyroJerkMag-std()"     
- [43] "fBodyAcc-mean()-X"          
- [44] "fBodyAcc-mean()-Y"          
- [45] "fBodyAcc-mean()-Z"          
- [46] "fBodyAcc-std()-X"           
- [47] "fBodyAcc-std()-Y"           
- [48] "fBodyAcc-std()-Z"           
- [49] "fBodyAccJerk-mean()-X"      
- [50] "fBodyAccJerk-mean()-Y"      
- [51] "fBodyAccJerk-mean()-Z"      
- [52] "fBodyAccJerk-std()-X"       
- [53] "fBodyAccJerk-std()-Y"       
- [54] "fBodyAccJerk-std()-Z"       
- [55] "fBodyGyro-mean()-X"         
- [56] "fBodyGyro-mean()-Y"         
- [57] "fBodyGyro-mean()-Z"         
- [58] "fBodyGyro-std()-X"          
- [59] "fBodyGyro-std()-Y"          
- [60] "fBodyGyro-std()-Z"          
- [61] "fBodyAccMag-mean()"         
- [62] "fBodyAccMag-std()"          
- [63] "fBodyBodyAccJerkMag-mean()" 
- [64] "fBodyBodyAccJerkMag-std()"  
- [65] "fBodyBodyGyroMag-mean()"    
- [66] "fBodyBodyGyroMag-std()"     
- [67] "fBodyBodyGyroJerkMag-mean()"
- [68] "fBodyBodyGyroJerkMag-std()"

### Cleaning transformations ###

Note that the steps are also documented within the **README.md** file next to the code. This section serves as more of short overview of all steps including some of my reasonings for these steps.

The transformations I have applied  to end up with the final Tidy Data Set are the following:

- I have merged the subject, X and Y data of both the training and test set separately.
My reasoning and understanding would be that this would correspond to a machine learning data set. X is the data, Y is the activity which a possible algorithm might predict and subject is the subject(volunteer) who 'constructed' the data using his smartphone.

- I have merged the total training and test sets together to one big data set.

- I have labelled the variables according to the features list.

- I have only left the variables in the data set which corresponded to mean or standard deviation. As is indicated in the **features\_info ** file is the mean represented by mean() in the variable name and similar std() for standard devation. This implies that meanfreq() should be excluded which is what I did.
Furthermore the additional angle() variables are also excluded.

- I have labelled the subject and acitivities columns accordingly.

- I have mapped the activities numbers into descriptive names. No longer 1..6 are included but now WALKING and STANDING are included.

- I have taken the mean of all variables for each combination of subject and activity as specified in the project description. 

- The resulting tidy data set is exported into TidyDataSet.txt once the code is run.


