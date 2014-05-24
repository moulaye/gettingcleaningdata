#library data.table is required
library(data.table)


#Set location of the main files
test_file                   <- "test/X_test.txt"
train_file                  <- "train/X_train.txt"
test_lbl_file               <- "test/y_test.txt"
train_lbl_file              <- "train/y_train.txt"
test_oid_file               <- "test/subject_test.txt"
train_oid_file              <- "train/subject_train.txt"
features_file               <- "features.txt"

#Read files and create data.frames
testdata                    <- read.table(test_file)
traindata                   <- read.table(train_file)
test_label_data             <- read.table(test_lbl_file)
train_label_data            <- read.table(train_lbl_file)
test_oid_data               <- read.table(test_oid_file)
train_oid_data              <- read.table(train_oid_file)
featuresdata                <- read.table(features_file,stringsAsFactors=FALSE)

#Give friendly names to column names
names(test_label_data)[1]         <- "activityid"
names(train_label_data)[1]        <- "activityid"
names(test_oid_data)[1]           <- "vid"
names(train_oid_data)[1]          <- "vid"

#Select feature name
featurelist                       <- c(featuresdata[,2])

#Give friendly names to features
for (f in seq_along(featurelist)) {
  
  names(testdata)[f]        <- featurelist[f]
  names(traindata)[f]       <- featurelist[f]

}

#merge data sets
fulltestdata                  <- cbind(test_oid_data,test_label_data,testdata) 
fulltraindata                 <- cbind(train_oid_data,train_label_data,traindata)

############### One data set that groups test and train data ##################
mergeddata                    <- rbind(fulltestdata,fulltraindata)


#Create the data frame that will contain only the mean
only_means_sd_data               <-  mergeddata[,c(1,2)]

#Extract mean and sd measurements from merged data set
# first create a seq of number = total number of columns
colnum <- seq(1,ncol(mergeddata))

for (i in colnum){
  
    if(grepl("mean()",names(mergeddata)[i]) == TRUE){
      
      newdata               <- data.frame(mergeddata[,i])
      names(newdata)[1]     <- names(mergeddata)[i]   
      only_means_sd_data    <- cbind(only_means_sd_data,newdata)
      
    }
    if(grepl("std()",names(mergeddata)[i]) == TRUE){
      
      newdata               <- data.frame(mergeddata[,i])
      names(newdata)[1]     <- names(mergeddata)[i]   
      only_means_sd_data    <- cbind(only_means_sd_data,newdata)
      
    }    
  
}

########################### merged data set created #############################

#Recode activity name
names(mergeddata)[2]                            <- "activity" #rename activityid to activity
mergeddata$activity[mergeddata$activity==1]     <- "WALKING"
mergeddata$activity[mergeddata$activity==2]     <- "WALKING_UPSTAIRS"
mergeddata$activity[mergeddata$activity==3]     <- "WALKING_DOWNSTAIRS"
mergeddata$activity[mergeddata$activity==4]     <- "SITTING"
mergeddata$activity[mergeddata$activity==5]     <- "STANDING"
mergeddata$activity[mergeddata$activity==6]     <- "LAYING"

#Create tidy data set
#Transform data frame to data table
newdata <- data.table(mergeddata)
#create tidy data grouped by obs id and activity
tidydata <- newdata[,lapply(.SD,mean),by="vid,activity",.SDcols=3:563]

#Write tidy data in working directory
write.table(tidydata,"tidydata.txt",sep=",", col.names=colnames(tidydata))

print("Tidy data created, file name => tidydata.txt")



