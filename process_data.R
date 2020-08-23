library(tidyverse)

setwd('./UCI HAR Dataset/')

# Get the data:

# From features.txt we need the names for the column names of the main data
features <- read.table("features.txt", col.names = c("n","functions"))
names <- features$functions

# Main data, containing all the numbers
x <- rbind(read.table("./train/X_train.txt"), read.table("./test/X_test.txt"))
names(x) <- names

# Activities, will be renamed using activity_code_table, see below
activity_codes <- rbind(read.table("./train/y_train.txt"), read.table("./test/y_test.txt"))
names(activity_codes) <- "code"

# the subjects (participants)
subject <- rbind(read.table("./train/subject_train.txt"), read.table("./test/subject_test.txt"))
names(subject) <- "subject"

# Merges the training and the test sets to create one data set.
MergedData <- cbind(subject, activity_codes, x)

# Extract only the measurements on the mean and standard deviation for each measurement.
TidyData <- select(MergedData, subject, code, contains("mean"), contains("std"))

# Step 3: Uses descriptive activity names to name the activities in the data set
activity_code_table <- read.table("activity_labels.txt", col.names = c("code", "activity"))
TidyData$code <- activity_code_table[TidyData$code, 2]

# Step 4: Appropriately labels the data set with descriptive variable names.
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

# Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
StatsData <- aggregate(. ~subject + activity, TidyData, mean)

# Write the data
write.table(TidyData, "../TidyData.txt", row.name=FALSE)
write.table(StatsData, "../StatsData.txt", row.name=FALSE)

