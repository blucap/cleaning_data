The script `download_and_unzip_data_files.R` downloads and extracts under the folder called `UCI HAR Dataset`

The script `process_data.R` executes the steps required as described in the course project’s definition.

1. Assign each data to variables
   - `features` <- `features.txt` : 561 rows, 2 columns 
      *We need this file because it contains the 561 variable names of the main data* : 
      `names <- features$functions`
      
   - `x <- rbind(read.table("./train/X_train.txt"), read.table("./test/X_test.txt"))`
     
   - `names(x) <- names`
     
     *Table* `x` *contains the main data, with all the numbers we need. The columns are properly named.*
     
     *Note, the* `train`*-ing and `test` data are merged in one go*.
   
   - `activity_codes <- rbind(read.table("./train/y_train.txt"), read.table("./test/y_test.txt"))`
     
   - `names(activity_codes) <- "code"` 
      
      *The* `activity_codes` *series contains 10,299 observations, coded by numbers. These codes will be renamed using the table*  `activity_code_table`, *see below*.
      
      *Note, the `train`-ing and `test` data are merged in one go.*
      
   - `subject <- rbind(read.table("./train/subject_train.txt"), read.table("./test/subject_test.txt"))
      names(subject) <- "subject"` 
      *The* `subject` *series contains 10,299 rows, coded with numbers representing the volunteer test subjects*.
   
2. Merges the data to create one data set
   
   - `MergedData <- cbind(subject, activity_codes, x)`
3. Extracts only the measurements on the **mean** and **standard deviation** for each measurement

   - `TidyData <- select(MergedData, subject, code, contains("mean"), contains("std"))`
   - *This table contains 10,299 rows and 88 columns selected from* `MergedData` 

4. Uses descriptive activity names to name the activities in the data set:

   - `activity_code_table <- read.table("activity_labels.txt", col.names = c("code", "activity"))` *This table contains the descriptive names of the six activities.* 
      *We will map these activities to* `TidyData`:  
      `TidyData$code <- activity_code_table[TidyData$code, 2]`

5. Appropriately labels the data set with descriptive variable names
   - `code` column in `TidyData` renamed into `activities`
   - All `Acc` in column’s name replaced by `Accelerometer`
   - All `Gyro` in column’s name replaced by `Gyroscope`
   - All `BodyBody` in column’s name replaced by `Body`
   - All `Mag` in column’s name replaced by `Magnitude`
   - All start with character `f` in column’s name replaced by `Frequency`
   - All start with character `t` in column’s name replaced by `Time`
   - etc.
   - `TidyData` now contains 10,299 rows and 88 columns.
   
6. From the `TidyData` data set, creates a second, independent  tidy data set with the average of each variable for each activity and  each subject
   - `StatsData <- aggregate(. ~subject + activity, TidyData, mean)`
   - *This table contains 180 rows, 88 columns created by taking the means of `TidyData`  activities  grouped by* `subject` *and* `activity`.

7. Export the data:

   - `write.table(TidyData, "../TidyData.txt", row.name=FALSE)`
   - `write.table(StatsData, "../StatsData.txt", row.name=FALSE)`
