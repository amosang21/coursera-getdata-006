###############################################################
# Things to submit:
# 1. To GitHub: This R script file entitled "run_analysis.R".
# 2. To GitHub: README.md.
# 3. To GitHub: CodeBook.md.
# 4. To Coursera: Tidy Data Set ("DATASET_TIDY.txt").
#
###############################################################
# Assumptions:
# 1. This R script file (run_analysis.R) should be placed in the "UCI HAR Dataset" folder. All paths are relative to this folder.
# 2. All the data source file names and file locations are as provided by the instructor.
# 3. My GitHub location: https://github.com/amosang21/coursera-getdata-006
#
###############################################################

### (0) Preliminary steps, such as loading the supporting files.
# Load activity_labels.txt: Links the ActivityCode (Values: 1-6) with the ActivityName
df_actlab <- read.table(file = "activity_labels.txt", sep = " ", col.names = c("ActCode", "ActName"))

# Load features.txt: Provides the column names for the X dataset. Noted 561 features present.
df_features <- read.table(file = "features.txt", sep = " ", col.names = c("FeatureCode", "FeatureName"))


### (1) Merge the training and the test sets to create one data set.
# Read in the training dataset.
df_subject_train <- read.table(file = "train/subject_train.txt", sep = " ", col.names = "SubjectNo")
df_y_train <- read.table(file = "train/y_train.txt", sep = " ", col.names = "ActCode")
df_X_train <- read.table(file = "train/X_train.txt", sep = "")  # Default separator of "" means whitespace. Handles the case of 2 consecutive spaces.

# Read in the test dataset.
df_subject_test <- read.table(file = "test/subject_test.txt", sep = " ", col.names = "SubjectNo")
df_y_test <- read.table(file = "test/y_test.txt", sep = " ", col.names = "ActCode")
df_X_test <- read.table(file = "test/X_test.txt", sep = "")  # Default separator of "" means whitespace. Handles the case of 2 consecutive spaces.

# Merge the train and test datasets.
df_subject_merge <- rbind(df_subject_train, df_subject_test)  # Always put the train dataset first, to avoid ordering issues!
df_y_merge <- rbind(df_y_train, df_y_test)  
df_X_merge <- rbind(df_X_train, df_X_test)

# Free up some memory, by deleting the intermediate data frames. 
rm(list = c("df_subject_train", "df_y_train", "df_X_train", "df_subject_test", "df_y_test", "df_X_test"))


### (2) Extract only the measurements on the mean and standard deviation for each measurement.
# Notice that all measurements pertaining to mean or standard deviation, have certain keywords in the column names. We only want these columns.
df_X_merge_small <- df_X_merge[ , grep("Mean|mean|std()", df_features$FeatureName)]
# Putting together the Subject, Activity Labels, and Measurements, to get the full ("big") dataset.
df_X_merge_final <- cbind(df_subject_merge, df_y_merge, df_X_merge_small)


### (3) Use descriptive activity names to name the activities in the data set.
# Merge df_actlab and df_y_merge. This matches the ActivityNames to the ActivityCodes in df_y_merge.
df_X_merge_final <- merge(x = df_actlab, y = df_X_merge_final, by.X = "ActCode", by.Y = "ActCode")
df_X_merge_final$ActCode <- NULL  # Delete the ActCode column. Not needed as we have ActName already.

# Tidying up df_X_merge_final.
df_X_merge_final <- df_X_merge_final[ , c(2, 1, 3:88)]  # Re-ordering the columns, to put SubjectNo first.
# Sort by SubjectNo and ActName, for more orderliness.
df_X_merge_final <- df_X_merge_final[order(df_X_merge_final$SubjectNo, df_X_merge_final$ActName), ]


### (4) Appropriately label the data set with descriptive variable names.
# Notice that this works because we run grep() using the same parameters and operands as in the earlier call, so the same columns are selected.
colnames(df_X_merge_final)[3:88] <- as.character(df_features[grep("Mean|mean|std()", df_features$FeatureName), "FeatureName"])  # Add the FeatureNames as the column names. Should be 86 columns. 


### (5) Create a second, independent tidy data set with the average of each variable, for each activity, and each subject.
df_X_merge_final_out <- aggregate(df_X_merge_final[ ,3:88], list(SubjectNo=df_X_merge_final$SubjectNo, ActName=df_X_merge_final$ActName), mean)  # See how to use aggregate() here: http://davetang.org/muse/2013/05/22/using-aggregate-and-apply-in-r/
# Sort again by SubjectNo and ActName, for more orderliness in the output file.
df_X_merge_final_out <- df_X_merge_final_out[order(df_X_merge_final_out$SubjectNo, df_X_merge_final_out$ActName), ]
# Output the tidy data set.
write.table(df_X_merge_final_out, file="DATASET_TIDY.txt", sep=" ", row.names=F)
