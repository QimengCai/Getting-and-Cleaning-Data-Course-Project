## Merges the training and the test sets to create one data set.

# download the file and put the file in the data folder

if(!file.exists("/Users/MENGMENG/Desktop/CouseraR/data")) {dir.create("/Users/MENGMENG/Desktop/CouseraR/data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "/Users/MENGMENG/Desktop/CouseraR/data/Databaset.zip", method = "curl")

# unzip the file

unzip(zipfile="/Users/MENGMENG/Desktop/CouseraR/data/Databaset.zip", exdir ="/Users/MENGMENG/Desktop/CouseraR/data")

# get the list of files

path_rf <- file.path("/Users/MENGMENG/Desktop/CouseraR/data" , "UCI HAR Dataset")
files <- list.files(path_rf, recursive=TRUE)
files

# Read the Activity files
dataActivityTest <- read.table(file.path(path_rf, "test" , "Y_test.txt"), header =  FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train" , "Y_train.txt"), header =  FALSE)


#Read the Subject files

dataSubjectTrain <- read.table(file.path(path_rf, "Train", "subject_train.txt"), header = FALSE)
dataSubjectTest <- read.table(file.path(path_rf, "Test", "subject_test.txt"), header = FALSE)

# Read Features file

dataFeatureTest <- read.table(file.path(path_rf, "Test", "X_test.txt"), header =  FALSE)
dataFeatureTrain <- read.table(file.path(path_rf, "Train", "X_train.txt"), header =  FALSE)

# Look at the properties of the above varilbes

str(dataActivityTest)
str(dataActivityTrain)
str(dataSubjectTrain)
str(dataSubjectTest)
str(dataFeatureTest)
str(dataFeatureTrain)

# Concatenate the data tables by rows

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
dataFeatures <- rbind(dataFeatureTrain, dataFeatureTest)

# Set names to variables

names(dataSubject) <- c("Subject")
names(dataActivity) <- c("Activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"), head = FALSE)
names(dataFeatures) <- dataFeaturesNames$V2

#Merge columns to get the data frame Data for all data

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)
Data

## Extracts only the measurements on the mean and standard deviation for each measurement

data_mean_sd <- Data[,grepl("mean|std|Subject|ActivityId", names(Data))]
data_mean_sd
str(data_mean_sd)
## Uses descriptive activity names to name the activities in the data set

ActivityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
factor(data_mean_sd$Activity, labels = ActivityLabels[,2])

##Appropriately labels the data set with descriptive variable names. 

names(data_mean_sd) <- gsub('Acc',"Acceleration",names(data_mean_sd))
names(data_mean_sd) <- gsub('GyroJerk',"AngularAcceleration",names(data_mean_sd))
names(data_mean_sd) <- gsub('Gyro',"Gyroscope",names(data_mean_std))
names(data_mean_sd) <- gsub('Mag',"Magnitude",names(data_mean_sd))
names(data_mean_sd)<-gsub("BodyBody", "Body", names(data_mean_sd))
names(data_mean_sd) <- gsub('^t',"TimeDomain.",names(data_mean_sd))
names(ata_mean_sd) <- gsub('^f',"FrequencyDomain.",names(data_mean_sd))
names(data_mean_sd) <- gsub('\\.mean',".Mean",names(data_mean_sd))
names(data_mean_sd) <- gsub('\\.std',".StandardDeviation",names(data_mean_sd))
names(data_mean_sd) <- gsub('Freq\\.',"Frequency.",names(data_mean_sd))
names(data_mean_sd) <- gsub('Freq$',"Frequency",names(data_mean_sd))
names(data_mean_sd)

## creates a second, independent tidy data set with the average of each variable for each activity and each subject


library(plyr);
DataSecond <- aggregate(. ~Subject + Activity, Data, mean)
DataSecond <- DataSecond[order(DataSecond$Subject, DataSecond$Activity),]
write.table(DataSecond, file = "tidydata.txt", row.name = FALSE)
