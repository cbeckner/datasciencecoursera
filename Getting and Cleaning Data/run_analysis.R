#Load required Libraries
library(dplyr)
#Load raw data
message("Loading Test Data...")
testx <- read.table("test/X_test.txt")
testy <- read.table("test/Y_test.txt")
testsubject <- read.table("test/subject_test.txt")

message("Loading Train Data...")
trainx <- read.table("train/X_train.txt")
trainy <- read.table("train/Y_train.txt")
trainsubject <- read.table("train/subject_train.txt")

message("Loading Activies...")
activities <- read.table("activity_labels.txt")
names(activities) <- c("activityId","activity")

message("Loading Headers...")
featureNamesRaw <- read.table("features.txt")
#isolate desired columns with mean and std
meanstdNames <- featureNamesRaw[grepl("mean|std",featureNamesRaw$V2),]

message("Filtering Columns...")
testx <- testx[,meanstdNames[,1]]
trainx <- trainx[,meanstdNames[,1]]

#make final list of names for the merged data
featureNames <- append(c("subjectId","activityId"),as.vector(meanstdNames[,2]))
#Clean the column names
featureNames <- make.names(featureNames)
featureNames <- gsub(".mean","Mean",featureNames)
featureNames <- gsub(".std","Std",featureNames)
featureNames <- gsub("\\.","",featureNames)
featureNames <- gsub("tBody","timeBody",featureNames)
featureNames <- gsub("tGravity","timeGravity",featureNames)
featureNames <- gsub("fBody","freqBody",featureNames)

#Combine data
message("Merging Data...")
testdata <- cbind(testsubject,testy,testx)
traindata <- cbind(trainsubject,trainy,trainx)
data <- rbind(testdata,traindata)

#Apply column names to the data
names(data) <- featureNames

#Make the tidy dataset
message("Tidying up...")
tidydata <- data %>%
    group_by(subjectId,activityId) %>%
    summarise_each(funs(mean)) %>%
    inner_join(activities, by="activityId") %>%
    select(subjectId, activity, timeBodyAccMeanX:freqBodyBodyGyroJerkMagMeanFreq)
tidydata <- data.frame(tidydata)


#clean up
rm(testx)
rm(testy)
rm(testsubject)
rm(testdata)
rm(trainx)
rm(trainy)
rm(trainsubject)
rm(traindata)
rm(featureNamesRaw)
rm(featureNames)
rm(meanstdNames)
rm(activities)