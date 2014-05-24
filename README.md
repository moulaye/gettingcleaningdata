run_analysis.R is a program that generates a tidy data set, it uses the data contained in the following Zip file:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
The README.txt (within the zipped file) explains the content of the Zip file

The program reads and processes the following data:
"test/X_test.txt"
"train/X_train.txt"
"test/y_test.txt"
"train/y_train.txt"
"test/subject_test.txt"
"train/subject_train.txt"
"features.txt"

The program does the following tasks:
1 - Merges the training and the test sets to create one data set called mergeddata.  
2 - Extracts only the measurements on the mean and standard deviation for each measurement and put them into only_means_sd_data. 
3 - Provides descriptive activity names to mergeddata
4 - Appropriately labels the data set with descriptive activity names. 
5 - Creates a second, independent tidy data set (tidydata) with the average of each variable for each activity and each subject. 
6 - Exports the tidy data set